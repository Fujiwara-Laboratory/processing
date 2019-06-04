// kinect V2用のライブラリ
import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;

float hrx, hry, hrz, hlx, hly, hlz; // 両手のXY座標 (PVector等の方が本当はよい)
int f_hr = 0, f_hl = 0; // 両手の状態フラグ
int f_Shr = 0, f_Shl = 0; // 両手の前後手振りフラグ

// 前後手振り用の履歴 (Z座標)
ArrayList<Float> rHist = new ArrayList<Float>();
ArrayList<Float> lHist = new ArrayList<Float>();

PImage rsImg;
float scaleRatio = 2, rsScale; // 画面表示のスケール変数
int w, h; // 変更後の画像サイズ

void settings(){
  // スケールに応じたウィンドウサイズ
  rsScale = 1.0 / scaleRatio;
  w = (int)(1920 * rsScale);
  h = (int)(1080 * rsScale);
  size(w, h, P3D);
  rsImg = createImage(w, h, RGB);
}

void setup(){
  // kinect関連の初期化
  kinect = new KinectPV2(this);
  kinect.enableColorImg(true);
  kinect.enableSkeletonColorMap(true);
  kinect.enableSkeleton3DMap(true);
  kinect.init();
  
  // 描画の各種設定
  rectMode(CENTER);
  textSize(20);
}

void draw(){
  // カラー画像用のスケルトン
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();
  // Z座標取得用のスケルトン情報
  ArrayList<KSkeleton> skeletonArray3D =  kinect.getSkeleton3d();

  // カラー画像の高速リサイズ
  imageResize(kinect.getColorImage(), rsImg, rsScale);
  image(rsImg, 0, 0);

  // 一人用のプログラム (個別に対応させるにはクラス化したほうがよい)
  for(int i = 0; i < skeletonArray.size(); i++){
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    KSkeleton skeleton3D = (KSkeleton) skeletonArray3D.get(i);
    if(skeleton.isTracked()){
      KJoint[] joints = skeleton.getJoints();
      KJoint[] joints3D = skeleton3D.getJoints();
      
      // 両手の座標を取得
      hrx = joints[KinectPV2.JointType_HandRight].getX() * rsScale;
      hry = joints[KinectPV2.JointType_HandRight].getY() * rsScale;
      hlx = joints[KinectPV2.JointType_HandLeft].getX() * rsScale;
      hly = joints[KinectPV2.JointType_HandLeft].getY() * rsScale;
      
      // Z座標はスケールが異なる(前後の手振り評価のみなのでそのまま使う)
      hrz = joints3D[KinectPV2.JointType_HandRight].getPosition().z;
      hlz = joints3D[KinectPV2.JointType_HandLeft].getPosition().z;
      
      // 右手の状態：パーで1、グーで2
      if(joints[KinectPV2.JointType_HandRight].getState() == KinectPV2.HandState_Open){
        f_hr = 1;
      }else if(joints[KinectPV2.JointType_HandRight].getState() == KinectPV2.HandState_Closed){
        f_hr = 2;
      }else{
        f_hr = 0;
      }
      
      // 左手の状態
      if(joints[KinectPV2.JointType_HandLeft].getState() == KinectPV2.HandState_Open){
        f_hl = 1;
      }else if(joints[KinectPV2.JointType_HandLeft].getState() == KinectPV2.HandState_Closed){
        f_hl = 2;
      }else{
        f_hl = 0;
      }
      
      noFill();
      strokeWeight(5);
      // 手の状態で線の色付けした位置描画 (右)
      if(f_hr == 1){
        stroke(255, 0, 0);
      }else if(f_hr == 2){
        stroke(0, 255, 0);
      }else{
        stroke(0, 0, 0);
      }
      if(evBF(rHist, hrz) == 0){
        ellipse(hrx, hry, 70, 70);
      }else{
        fill(100, 255, 100);
        rect(hrx, hry, 70, 70);
      }
      
      // 手の状態で線の色付けした位置描画 (左)
      if(f_hl == 1){
        stroke(255, 0, 0);
      }else if(f_hl == 2){
        stroke(0, 255, 0);
      }else{
        stroke(0, 0, 0);
      }
      if(evBF(lHist, hlz) == 0){
        ellipse(hlx, hly, 70, 70);
      }else{
        fill(100, 255, 100);
        rect(hlx, hly, 70, 70);
      }
    }
  }
  
  fill(255, 0, 0);
  text(frameRate , 50, 50);
}

// 前後手振りの評価関数
int evBF(ArrayList<Float> data, float z){
  int bfNUM = 20; // 確認フレーム数
  float bfMagTh = 0.1; // ベクトルの大きさの平均に対する閾値
  float bfVarTh0 = 0.07, bfVarTh1 = 0.3;  // 分散による判別用の閾値
  
  int i;
  float mag = 0, ave = 0, var = 0;
  
  data.add(z * 10); // リストの最後へ今回のZ値を挿入(10を掛けたほうが処理しやすい)
  if(data.size() > bfNUM){
    ave = data.get(0);
    for(i = 1; i < bfNUM; i++){
      ave += data.get(i); // 合計の算出
      mag += abs(data.get(i - 1) - data.get(i));
    }
    ave /= bfNUM; // 個数で割って平均にする
    mag /= bfNUM;
    for(i = 0; i < bfNUM; i++){
      var += (ave - data.get(i)) * (ave - data.get(i));
    }
    var /= bfNUM; // 個数で割って分散にする
    data.remove(0); // リストの先頭(履歴の最も古いもの)を削除
    
    // 分散および凸回数が閾値以上のため前後手振り状態と判定
    if(bfVarTh0 < var && var < bfVarTh1 && bfMagTh < mag) return 1;//  &&  > ) 
  }
  return 0;
}

// 画像の高速リサイズ (簡易版の縮小用)
void imageResize(PImage src, PImage dst, float s){
  int i, j, u, v;
  if(s == 1){
    dst = src.get();
    return;
  }
  float rate = 1 / s;
  dst.loadPixels();
  for(j = 0; j < h; j++){
    for(i = 0; i < w; i++){
      u = (int)(i * rate + s);
      v = (int)(j * rate + s) * src.width;
      dst.pixels[i + j * w] = src.pixels[u + v];
    }
  }
  dst.updatePixels();
}
