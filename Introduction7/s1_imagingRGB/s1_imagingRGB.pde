// kinect用ライブラリ
import SimpleOpenNI.*;

// RGBDカメラ用
SimpleOpenNI kinect;

void setup(){
  size(640, 480);
  
  // RGBDカメラの起動
  kinect = new SimpleOpenNI(this);
  
  // カラー画像取得を有効にする
  kinect.enableRGB();
}

void draw(){
  // RGBDカメラの更新
  kinect.update();
  
  // カラー画像の表示
  image(kinect.rgbImage(), 0, 0);
}
