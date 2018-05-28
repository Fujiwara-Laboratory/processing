// kinect V2用のライブラリ
import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;
ArrayList<KSkeleton> skeletonArray;
ArrayList<KSkeleton> skltnAry3D;

float skScale, skExp;// 画面表示のスケール変数
float hr2Dx, hr2Dy, hl2Dx, hl2Dy; // 両手のXY座標
int f_hr = 0, f_hl = 0; // 両手の状態フラグ
PVector hr3D = new PVector(0, 0, 0), hl3D = new PVector(0, 0, 0);

PImage srcImg, qtImg;
int w, h;

ksklPosLog logger;

void setup(){
  // スケールに応じたウィンドウサイズ
  skScale = 0.3;
  skExp = 1 / skScale;
  w = (int)(1920 * skScale);
  h = (int)(1080 * skScale);
  surface.setSize(w, h);
  // kinect関連の初期化
  kinect = new KinectPV2(this);
  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);
  kinect.enableSkeleton3DMap(true); // 3D座標用のフラグ
  kinect.init();
  
  // 描画の各種設定
  strokeWeight(5);
  textSize(28);
  qtImg = createImage(w, h, RGB);
  
  // ロガーの生成
  logger = new ksklPosLog(1000);
}

void draw(){
  // カラー画像用にスケルトンを生成する
  // (表示用の情報がいらなければこちらは無しでもよい)
  skeletonArray =  kinect.getSkeletonColorMap();
  
  // 3D位置用のスケルトンも生成する
  skltnAry3D = kinect.getSkeleton3d();
  
  // 背景をカラー画像に (image関数やリサイズは遅いのでべたに縮小)
  srcImg = kinect.getColorImage();
  int i, j, u, v;
  qtImg.loadPixels();
  for(j = 0; j < h; j++){
    for(i = 0; i < w; i++){
      u = (int)(i * skExp + 0.5);
      v = (int)(j * skExp + 0.5) * srcImg.width;
      qtImg.pixels[i + j * w] = srcImg.pixels[u + v];
    }
  }
  qtImg.updatePixels();
  image(qtImg, 0, 0);
  
  // 一人用のプログラム (個別に対応させるにはクラス化したほうがよい)
  for(i = 0; i < skeletonArray.size(); i++){
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    KSkeleton skltn3D = (KSkeleton) skltnAry3D.get(i); // 3D版の取得
    if(skeleton.isTracked()){
      KJoint[] joints = skeleton.getJoints();
      KJoint[] joints3D = skltn3D.getJoints(); // 3D版の取得
      
      // 両手の座標を取得 (ウィンドウ座標系)
      hr2Dx = joints[KinectPV2.JointType_HandRight].getX() * skScale;
      hr2Dy = joints[KinectPV2.JointType_HandRight].getY() * skScale;
      hl2Dx = joints[KinectPV2.JointType_HandLeft].getX() * skScale;
      hl2Dy = joints[KinectPV2.JointType_HandLeft].getY() * skScale;
      
      // 両手の座標を取得 (3D座標系・単位をcmに)
      hr3D.x = joints3D[KinectPV2.JointType_HandRight].getPosition().x * 100;
      hr3D.y = joints3D[KinectPV2.JointType_HandRight].getPosition().y * 100;
      hr3D.z = joints3D[KinectPV2.JointType_HandRight].getPosition().z * 100;
      hl3D.x = joints3D[KinectPV2.JointType_HandLeft].getPosition().x * 100;
      hl3D.y = joints3D[KinectPV2.JointType_HandLeft].getPosition().y * 100;
      hl3D.z = joints3D[KinectPV2.JointType_HandLeft].getPosition().z * 100;
      
      // 右手の状態：パーで1、グーで2、チョキで3
      if(joints[KinectPV2.JointType_HandRight].getState() == KinectPV2.HandState_Open) f_hr = 1;
      else if(joints[KinectPV2.JointType_HandRight].getState() == KinectPV2.HandState_Closed) f_hr = 2;
      else if(joints[KinectPV2.JointType_HandRight].getState() == KinectPV2.HandState_Lasso) f_hr = 3;
      else f_hr = 0;
      
      // 左手の状態
      if(joints[KinectPV2.JointType_HandLeft].getState() == KinectPV2.HandState_Open) f_hl = 1;
      else if(joints[KinectPV2.JointType_HandLeft].getState() == KinectPV2.HandState_Closed) f_hl = 2;
      else if(joints[KinectPV2.JointType_HandLeft].getState() == KinectPV2.HandState_Lasso) f_hl = 3;
      else f_hl = 0;
      
      // 手の状態で線の色付けした位置描画
      noFill();
      if(f_hr == 1) stroke(255, 0, 0);
      else if(f_hr == 2) stroke(0, 255, 0);
      else if(f_hr == 3) stroke(0, 0, 255);
      else stroke(0, 0, 0);
      ellipse(hr2Dx, hr2Dy, 70, 70);
      
      if(f_hl == 1) stroke(255, 0, 0);
      else if(f_hl == 2) stroke(0, 255, 0);
      else if(f_hl == 3) stroke(0, 0, 255);
      else stroke(0, 0, 0);
      ellipse(hl2Dx, hl2Dy, 70, 70);
      
      // 手位置の3D座標を表示
      fill(0);
      text((int)hr3D.x + ", " + (int)hr3D.y + ", " + (int)hr3D.z, hr2Dx, hr2Dy);
      text((int)hl3D.x + ", " + (int)hl3D.y + ", " + (int)hl3D.z, hl2Dx, hl2Dy);
      
      // 座標の記録
      if(logger.on){
        logger.posPartsSet(hr3D, hl3D);
      }
      
    }
  }
  
  fill(255, 0, 0);
  text((int)frameRate + "  Log: " +  logger.flame, 20, 50);
}

void keyPressed(){
  if(key == ' ') logger.getTrigger();
}
