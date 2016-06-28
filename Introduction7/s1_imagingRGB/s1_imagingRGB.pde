// kinect用ライブラリ
import kinect4WinSDK.*;

// RGBDカメラ用
Kinect kinect;

void setup(){
  size(640, 480);
  
  // RGBDカメラの起動
  kinect = new Kinect(this);
}

void draw(){
  // カラー画像の表示
  image(kinect.GetImage(), 0, 0);
}