// kinect V2用のライブラリ
import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;

float skScale = 0.5; // 画面表示のスケール変数

void settings(){
  size((int)(1920 * skScale), (int)(1080 * skScale));
}

void setup(){
  // kinect関連の初期化
  kinect = new KinectPV2(this);
  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);
  kinect.init();
}

void draw(){
  // カラー画像用にスケルトンを生成する
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();
  // 背景をカラー画像に
  image(kinect.getColorImage(), 0, 0, width, height);

  // ボディー毎にスケルトン表示
  for(int i = 0; i < skeletonArray.size(); i++){
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if(skeleton.isTracked()){
      KJoint[] joints = skeleton.getJoints();

      color col  = skeleton.getIndexColor();
      fill(col);
      stroke(col);
      drawBody(joints);

      // 手状態の表示
      drawHandState(joints[KinectPV2.JointType_HandRight]);
      drawHandState(joints[KinectPV2.JointType_HandLeft]);
    }
  }

  fill(255, 0, 0);
  text(frameRate, 50, 50);
}

// スケルトンの描画
void drawBody(KJoint[] joints) {
  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
  drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);
  drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

  // Right Arm
  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

  // Left Arm
  drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
  drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

  // Right Leg
  drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
  drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
  drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

  // Left Leg
  drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
  drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
  drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

  drawJoint(joints, KinectPV2.JointType_HandTipLeft);
  drawJoint(joints, KinectPV2.JointType_HandTipRight);
  drawJoint(joints, KinectPV2.JointType_FootLeft);
  drawJoint(joints, KinectPV2.JointType_FootRight);

  drawJoint(joints, KinectPV2.JointType_ThumbLeft);
  drawJoint(joints, KinectPV2.JointType_ThumbRight);

  drawJoint(joints, KinectPV2.JointType_Head);
}

// 各関節部の描画(スケール用の変数で大きさを調整している)
void drawJoint(KJoint[] joints, int jointType) {
  pushMatrix();
  translate(joints[jointType].getX() * skScale, joints[jointType].getY() * skScale);
  ellipse(0, 0, 25, 25);
  popMatrix();
}

// 各パーツの描画(スケール用の変数で大きさを調整している)
void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  pushMatrix();
  translate(joints[jointType1].getX() * skScale, joints[jointType1].getY() * skScale);
  ellipse(0, 0, 25, 25);
  popMatrix();
  line(joints[jointType1].getX() * skScale, joints[jointType1].getY() * skScale, joints[jointType2].getX() * skScale, joints[jointType2].getY() * skScale);
}

// 手の状態に応じた色の表示
void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX() * skScale, joint.getY() * skScale);
  ellipse(0, 0, 70, 70);
  popMatrix();
}

// 手状態の判定(ライブラリにて)
void handState(int handState) {
    noFill();
  switch(handState){
  case KinectPV2.HandState_Open: // パー
    fill(0, 255, 0, 128);
    break;
  case KinectPV2.HandState_Closed: // グー
    fill(255, 0, 0, 128);
    break;
  case KinectPV2.HandState_Lasso: // チョキ (3本とかだと不安定)
    fill(0, 0, 255, 128);
    break;
  case KinectPV2.HandState_NotTracked:
    fill(255, 255, 255, 128);
    break;
  }
}