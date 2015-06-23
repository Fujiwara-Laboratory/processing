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
  
  strokeWeight(10);
  stroke(255, 0, 0);
}

void draw(){
  // RGBDカメラの更新
  kinect.update();
  
  // ユーザー領域の表示
  image(kinect.userImage(),0,0);
  
  // 検出したユーザ毎に処理
  int[] userList = kinect.getUsers();
  for(int i = 0; i < userList.length; i++){
    if(kinect.isTrackingSkeleton(userList[i])){
      
      // 両手と頭の位置
      PVector handR3D = new PVector();
      PVector handR2D = new PVector();
      PVector handL3D = new PVector();
      PVector handL2D = new PVector();
      PVector head3D = new PVector();
      PVector head2D = new PVector();
      
      kinect.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_HAND, handR3D);
      kinect.convertRealWorldToProjective(handR3D, handR2D);
      kinect.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_HAND, handL3D);
      kinect.convertRealWorldToProjective(handL3D, handL2D);
      kinect.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_HEAD, head3D);
      kinect.convertRealWorldToProjective(head3D, head2D);
      
      fill(255, 215, 0);
      ellipse(handR2D.x, handR2D.y, 50, 50);
      fill(128, 128, 0);
      ellipse(handL2D.x, handL2D.y, 50, 50);
      fill(247, 171, 166);
      ellipse(head2D.x, head2D.y, 50, 50);
    }
  }
}

void onNewUser(SimpleOpenNI curkinect, int userId){
  curkinect.startTrackingSkeleton(userId);
}
