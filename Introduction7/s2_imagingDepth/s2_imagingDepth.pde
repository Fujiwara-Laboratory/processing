// kinect V2用のライブラリ
import KinectPV2.*;

// RGBDカメラ用
KinectPV2 kinect;

void setup(){
  size(512, 424);
  
  // kinect関連の初期化
  kinect = new KinectPV2(this);
  kinect.enableDepthImg(true);
  kinect.init();
}

void draw(){
  // カラー画像の表示
  image(kinect.getDepthImage(), 0, 0);
}