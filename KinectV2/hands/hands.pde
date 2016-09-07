import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;

float skScale = 0.5;
int f_hr = 0, f_hl = 0;

void settings(){
  size((int)(1920 * skScale), (int)(1080 * skScale));
}

void setup() {

  kinect = new KinectPV2(this);

  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);

  kinect.init();
  strokeWeight(5);
  noFill();
}

void draw() {
  background(0);
  float hrx, hry, hlx, hly;

  image(kinect.getColorImage(), 0, 0, width, height);

  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();

  // 一人用のプログラム
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
      
      // 手の状態で線の色付けした位置描画
      if(f_hr == 1){
        stroke(255, 0, 0);
      }else if(f_hr == 2){
        stroke(0, 255, 0);
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