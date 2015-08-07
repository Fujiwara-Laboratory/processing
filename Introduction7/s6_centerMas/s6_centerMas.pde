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
  fill(255, 0, 0);
}

void draw(){
  PVector com = new PVector();
  PVector com2d = new PVector();
  kinect.update();

  // カラー画像の表示
  image(kinect.rgbImage(), 0, 0);
  
  // 検出したユーザ毎に処理
  int[] userList = kinect.getUsers();
  for(int i = 0; i < userList.length; i++){
    if(kinect.isTrackingSkeleton(userList[i])){
      // 重心の取得
      if(kinect.getCoM(userList[i], com)){
        kinect.convertRealWorldToProjective(com, com2d);
        ellipse(com2d.x, com2d.y, 30, 30);
      }
    }
  }
}

void onNewUser(SimpleOpenNI curkinect, int userId){
  curkinect.startTrackingSkeleton(userId);
}
