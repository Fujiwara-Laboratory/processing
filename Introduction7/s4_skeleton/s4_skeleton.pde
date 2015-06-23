// kinect用ライブラリ
import SimpleOpenNI.*;

// RGBDカメラ用変数
SimpleOpenNI kinect;

void setup(){
  size(640, 480);
  
  // RGBDカメラ関係の初期化
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();
  kinect.setMirror(true); // 鏡写し(falseで無効)
  kinect.alternativeViewPointDepthToImage(); // 位置の微調整
  kinect.enableUser(); // 姿勢推定を有効にする
  
  strokeWeight(5);
}

void draw(){
  kinect.update();

  // カラー画像の表示
  image(kinect.rgbImage(), 0, 0);
  
  // 検出したユーザ毎に処理
  int[] userList = kinect.getUsers();
  for(int i = 0; i < userList.length; i++){
    if(kinect.isTrackingSkeleton(userList[i])){
      drawSkeleton(userList[i]);
    }
  }
}

// スケルトン表示の処理
void drawSkeleton(int userId){
  stroke(255, 0, 0);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);

  stroke(0, 0, 255);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  stroke(0, 255, 0);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
}

void onNewUser(SimpleOpenNI curkinect, int userId){
  curkinect.startTrackingSkeleton(userId);
}
