// kinect用ライブラリ
import SimpleOpenNI.*;

// RGBDカメラ用変数
SimpleOpenNI kinect;

void setup(){
  size(640, 480);
  
  // RGBDカメラの起動
  kinect = new SimpleOpenNI(this);
  
  // 距離計測を有効にする
  kinect.enableDepth();
}

void draw(){
  // RGBDカメラの更新
  kinect.update();
  
  // 距離画像の表示
  image(kinect.depthImage(), 0, 0);
}
