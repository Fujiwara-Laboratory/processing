// kinect V2用のライブラリ
import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;

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

void setup() {
  // kinect関連の初期化
  kinect = new KinectPV2(this);
  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);
  kinect.enableSkeleton3DMap(true); // 3D座標用のフラグ
  kinect.init();
  
  // 描画の各種設定
  textSize(32);
}

void draw() {
  // カラー画像の高速リサイズ
  imageResize(kinect.getColorImage(), rsImg, rsScale);
  image(rsImg, 0, 0);

  // カラー画像用にスケルトンを生成する
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();
  
  // 3D位置用のスケルトンも生成する
  ArrayList<KSkeleton> skltnAry3D =  kinect.getSkeleton3d();

  // 各スケルトンでループ
  for(int i = 0; i < skeletonArray.size(); i++){
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    KSkeleton skltn3D = (KSkeleton) skltnAry3D.get(i); // 3D版の取得
    if(skeleton.isTracked()){
      KJoint[] joints = skeleton.getJoints();
      KJoint[] joints3D = skltn3D.getJoints(); // 3D版の取得

      color col  = skeleton.getIndexColor();
      fill(col);
      stroke(col);
      drawBody(joints);

      drawHandState(joints[KinectPV2.JointType_HandRight]);
      drawHandState(joints[KinectPV2.JointType_HandLeft]);
      
      // 3D座標の取得と表示
      fill(0, 0, 255);
      float rx, ry, rz;
      rx = joints3D[KinectPV2.JointType_HandRight].getPosition().x * 100;
      ry = joints3D[KinectPV2.JointType_HandRight].getPosition().y * 100;
      rz = joints3D[KinectPV2.JointType_HandRight].getPosition().z * 100;
      float tx, ty;
      tx = joints[KinectPV2.JointType_HandRight].getX() * skScale;
      ty = joints[KinectPV2.JointType_HandRight].getY() * skScale;
      text((int)rx + ", " + (int)ry + ", " + (int)rz, tx, ty);
    }
  }

  fill(255, 0, 0);
  text(frameRate, 50, 50);
}

//DRAW BODY
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

//draw joint
void drawJoint(KJoint[] joints, int jointType) {
  pushMatrix();
  translate(joints[jointType].getX() * skScale, joints[jointType].getY() * skScale, joints[jointType].getZ() * skScale);
  ellipse(0, 0, 25, 25);
  popMatrix();
}

//draw bone
void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  pushMatrix();
  translate(joints[jointType1].getX() * skScale, joints[jointType1].getY() * skScale, joints[jointType1].getZ() * skScale);
  ellipse(0, 0, 25, 25);
  popMatrix();
  line(joints[jointType1].getX() * skScale, joints[jointType1].getY() * skScale, joints[jointType1].getZ() * skScale, joints[jointType2].getX() * skScale, joints[jointType2].getY() * skScale, joints[jointType2].getZ() * skScale);
}

//draw hand state
void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX() * skScale, joint.getY() * skScale, joint.getZ() * skScale);
  ellipse(0, 0, 70, 70);
  popMatrix();
}

/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HandState_Lasso
 KinectPV2.HandState_NotTracked
 */
void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open: // パー
    fill(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed: // グー
    fill(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso: // チョキ (3本とかだと不安定)
    fill(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    fill(255, 255, 255);
    break;
  }
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
  for(j = 0; j < dst.height; j++){
    for(i = 0; i < dst.width; i++){
      u = (int)(i * rate + s);
      v = (int)(j * rate + s) * src.width;
      dst.pixels[i + j * dst.width] = src.pixels[u + v];
    }
  }
  dst.updatePixels();
}
