// kinect V2用のライブラリ
import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;

float skScale = 0.5; // 画面表示のスケール変数
float hrx, hry, hrz, hlx, hly, hlz; // 両手のXY座標 (PVector等の方が本当はよい)
int f_hr = 0, f_hl = 0; // 両手の状態フラグ
int f_Shr = 0, f_Shl = 0; // 両手の前後手振りフラグ

// 前後手振り用の履歴 (Z座標)
ArrayList<Float> rHist = new ArrayList<Float>();
ArrayList<Float> lHist = new ArrayList<Float>();

void settings(){
  // スケールに応じたウィンドウサイズ
  size((int)(1920 * skScale), (int)(1080 * skScale));
}

void setup(){
  // kinect関連の初期化
  kinect = new KinectPV2(this);
  kinect.enableColorImg(true);
  kinect.enableSkeletonColorMap(true);
  kinect.enableSkeleton3DMap(true);
  kinect.init();
  
  // 描画の各種設定
  strokeWeight(5);
  noFill();
  rectMode(CENTER);
}

void draw(){
  // カラー画像用のスケルトン
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();
  // Z座標取得用のスケルトン情報
  ArrayList<KSkeleton> skeletonArray3D =  kinect.getSkeleton3d();

  // 背景をカラー画像に
  image(kinect.getColorImage(), 0, 0, width, height);

  // 一人用のプログラム (個別に対応させるにはクラス化したほうがよい)
  for(int i = 0; i < skeletonArray.size(); i++){
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    KSkeleton skeleton3D = (KSkeleton) skeletonArray3D.get(i);
    if(skeleton.isTracked()){
      KJoint[] joints = skeleton.getJoints();
      KJoint[] joints3D = skeleton3D.getJoints();
      
      // 両手の座標を取得
      hrx = joints[KinectPV2.JointType_HandRight].getX() * skScale;
      hry = joints[KinectPV2.JointType_HandRight].getY() * skScale;
      hlx = joints[KinectPV2.JointType_HandLeft].getX() * skScale;
      hly = joints[KinectPV2.JointType_HandLeft].getY() * skScale;
      
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
        rect(hlx, hly, 70, 70);
      }
    }
  }
}

// 前後手振りの評価関数
int evBF(ArrayList<Float> data, float z){
  int bfNUM = 15; // 確認フレーム数
  float bfChTh = 0.01; // 凸形状検出用の閾値
  int bfCntTh = 2; // 凸形状の回数閾値
  float bfVarTh = 0.00002; // 分散による判別用の閾値
  
  int i, lmax = 0;
  float ave = 0, var = 0, f0, f1, f2;
  
  data.add(z); // リストの最後へ今回のZ値を挿入
  if(data.size() > bfNUM){
    for(i = 0; i < bfNUM; i++){
      ave += data.get(i); // 合計の算出
      if(i > 2){
        f2 = data.get(i - 2);
        f1 = data.get(i - 1);
        f0 = data.get(i);
        if((f2 < f1 - bfChTh && f1 - bfChTh > f0) || (f2 > f1 + bfChTh && f1 + bfChTh < f0)) lmax++;
      }
    }
    ave /= bfNUM; // 個数で割って平均にする
    for(i = 0; i < bfNUM; i++){
      var += (ave - data.get(i)) * (ave - data.get(i));
    }
    var /= bfNUM; // 個数で割って分散にする
    data.remove(0); // リストの先頭(履歴の最も古いもの)を削除
    // 分散および凸回数が閾値以上のため前後手振り状態と判定
    if(var > bfVarTh && lmax > bfCntTh) return 1;
  }
  return 0;
}