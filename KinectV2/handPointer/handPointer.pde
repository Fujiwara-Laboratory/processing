// kinect V2用のライブラリ
import KinectPV2.KJoint;
import KinectPV2.*;

// マウス制御用
import java.awt.Robot;
import java.awt.event.*;

KinectPV2 kinect;

Robot robot;

float skScale = 0.5; // 画面表示のスケール変数
float hrx, hry, hlx, hly; // 両手のXY座標 (PVector等の方が本当はよい)
int f_hr = 0, f_hl = 0; // 両手の状態フラグ

void settings(){
  // スケールに応じたウィンドウサイズ
  size((int)(1920 * skScale), (int)(1080 * skScale));
  
  try{
    robot = new Robot();
  }
  catch(Exception e) {
  }
}

void setup(){
  // kinect関連の初期化
  kinect = new KinectPV2(this);
  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);
  kinect.init();
  
  // 描画の各種設定
  strokeWeight(5);
  noFill();
}

void draw(){
  // カラー画像用にスケルトンを生成する
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();
  
  // 背景をカラー画像に
  image(kinect.getColorImage(), 0, 0, width, height);
  
  // 一人用のプログラム (個別に対応させるにはクラス化したほうがよい)
  for(int i = 0; i < skeletonArray.size(); i++){
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if(skeleton.isTracked()){
      KJoint[] joints = skeleton.getJoints();
      
      // 両手の座標を取得
      hrx = joints[KinectPV2.JointType_HandRight].getX() * skScale;
      hry = joints[KinectPV2.JointType_HandRight].getY() * skScale;
      hlx = joints[KinectPV2.JointType_HandLeft].getX() * skScale;
      hly = joints[KinectPV2.JointType_HandLeft].getY() * skScale;
      
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
      
      int shiftX = 185, shiftY = 122;
      // 手の状態で線の色付けした位置描画
      if(f_hr == 1){
        stroke(255, 0, 0);
        
        robot.mouseMove((int)hrx + shiftX, (int)hry + shiftY);
        // パーでクリックボタンを離す
        robot.mouseRelease(InputEvent.BUTTON1_MASK);
      }else if(f_hr == 2){
        stroke(0, 255, 0);
        
        robot.mouseMove((int)hrx + shiftX, (int)hry + shiftY);
        // グーでクリックボタンを押す
        robot.mousePress(InputEvent.BUTTON1_MASK);
      }else{
        stroke(0, 0, 0);
      }
      ellipse(hrx, hry, 70, 70);
      
      if(f_hl == 1){
        stroke(255, 0, 0);
      }else if(f_hl == 2){
        stroke(0, 255, 0);
      }else{
        stroke(0, 0, 0);
      }
      ellipse(hlx, hly, 70, 70);
    }
  }
}