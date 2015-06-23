// kinect用ライブラリ
import SimpleOpenNI.*;

// RGBDカメラ用変数
SimpleOpenNI kinect;
 
void setup() {
  size(640, 480);
  
  // RGBDカメラの起動
  kinect = new SimpleOpenNI(this);
  
  // 距離計測を有効にする
  kinect.enableDepth();
  
  textSize(50); // 文字サイズの設定
  fill(255, 0, 0);
}
 
void draw() {
  // RGBDカメラの更新
  kinect.update();
  
  // 距離画像の表示
  image(kinect.depthImage(), 0, 0);
   
  // 中心の距離を表示
  int[] depthMap = kinect.depthMap();
  int x = width / 2; // 画像中心
  int y = height / 2; // 画像中心
  int index = x + y * width;
  int distance = depthMap[index];
  
  // 中心座標のガイド(円)と距離の表示
  ellipse(x, y, 10, 10);
  if(distance > 0) text(distance +" mm", x + 10, y - 10);
  else text("-- mm", x + 10, y - 10);
}
