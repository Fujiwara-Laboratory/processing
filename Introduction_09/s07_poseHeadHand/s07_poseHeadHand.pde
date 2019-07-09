// kinect V2用のライブラリ
import KinectPV2.*;

// RGBDカメラ用変数
KinectPV2 kinect;
ArrayList<KSkeleton> skeletonArray;

// サイズ変更関連の変数
PImage rsImg;
float rsScale = 0.5; // 画面表示のスケール変数
int w, h; // 変更後の画像サイズ

// 個別の部品 (頭、右手、左手)
PVector hd = new PVector(), hr = new PVector(), hl = new PVector();
int f_hr = 0, f_hl = 0; // 両手の状態フラグ

void setup(){
  // スケールに合わせた画面サイズ
  w = (int)(1920 * rsScale);
  h = (int)(1080 * rsScale);
  surface.setSize(w, h);
  rsImg = createImage(w, h, RGB);
  
  // kinect関連の初期化
  kinect = new KinectPV2(this);
  kinect.enableColorImg(true);
  kinect.enableSkeletonColorMap(true);
  kinect.init();
  
  strokeWeight(5);
}

void draw(){
  // カラー画像の高速リサイズ
  imageResize(kinect.getColorImage(), rsImg, rsScale);
  
  // カラー画像の表示
  image(rsImg, 0, 0);
  
  // スケルトン情報の取得
  skeletonArray =  kinect.getSkeletonColorMap();
  
  // 人数分(n人)ループする
  for(int i = 0; i < skeletonArray.size(); i++){
    // n人目のスケルトン情報を skeleton へ
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    
    // skeleton が使えるならば
    if(skeleton.isTracked()){
      // 関節の集合となる配列に変換
      KJoint[] joints = skeleton.getJoints();

      // 頭部の座標を取得・描画
      hd.x = joints[KinectPV2.JointType_Head].getX() * rsScale;
      hd.y = joints[KinectPV2.JointType_Head].getY() * rsScale;
      
      noFill();
      stroke(0, 0, 255);
      ellipse(hd.x, hd.y, 50, 50);
      
      // 両手の座標を取得
      hr.x = joints[KinectPV2.JointType_HandRight].getX() * rsScale;
      hr.y = joints[KinectPV2.JointType_HandRight].getY() * rsScale;
      hl.x = joints[KinectPV2.JointType_HandLeft].getX() * rsScale;
      hl.y = joints[KinectPV2.JointType_HandLeft].getY() * rsScale;
      
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
      
      // 手の状態で線の色付けした位置に描画
      if(f_hr == 1){
        stroke(255, 0, 0);
      }else if(f_hr == 2){
        stroke(0, 255, 0);
      }else{
        stroke(0, 0, 0);
      }
      ellipse(hr.x, hr.y, 50, 50);
      
      if(f_hl == 1){
        stroke(255, 0, 0);
      }else if(f_hl == 2){
        stroke(0, 255, 0);
      }else{
        stroke(0, 0, 0);
      }
      ellipse(hl.x, hl.y, 50, 50);
    }
  }
  
  fill(255, 0, 0);
  text(frameRate, 20, 40);
}

// 画像のリサイズ (簡易版の縮小用)
void imageResize(PImage src, PImage dst, float s){
  int i, j, u, v;
  float rate = 1 / s;
  int w_s = (int)(src.width * s), h_s = (int)(src.height * s);
  if(s == 1){
    dst = src.get();
    return;
  }
  dst.loadPixels();
  for(j = 0; j < h_s; j++){
    for(i = 0; i < w_s; i++){
      u = (int)(i * rate + s);
      v = (int)(j * rate + s) * src.width;
      dst.pixels[i + j * w_s] = src.pixels[u + v];
    }
  }
  dst.updatePixels();
}
