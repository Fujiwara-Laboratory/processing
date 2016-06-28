// kinect用ライブラリ
import kinect4WinSDK.*;

// RGBDカメラ用
Kinect kinect;

// 処理用の画像
PImage img;
float scale = 8192.0 / 256;

void setup(){
  size(640, 480);
  
  // RGBDカメラの起動
  kinect = new Kinect(this);
  
  textSize(50); // 文字サイズの設定
  fill(255, 0, 0);
}

void draw(){
  int x, y, distRaw, distance = -1;
  img = kinect.GetDepth();
  
  // カラー画像の表示
  image(img, 0, 0);
  
  // カラー画像の表示
  image(img, 0, 0);
  x = 640 / 2;
  y = 480 / 2;
  distRaw = img.pixels[x + y * width] & 0xFF;
  if(distRaw > 0) distance = (int)((255 - distRaw) * scale);
  
  // 中心座標のガイド(円)と距離の表示
  ellipse(x, y, 10, 10);
  if(distance > 0) text(distance +" mm", x + 10, y - 10);
  else text("-- mm", x + 10, y - 10);
}