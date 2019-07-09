// kinect V2用のライブラリ
import KinectPV2.*;

// RGBDカメラ用
KinectPV2 kinect;

// 処理用の画像
PImage img;
int rawData[] = null;

void setup(){
  size(512, 424);
  img = createImage(512, 424, RGB);
  
  // kinect関連の初期化
  kinect = new KinectPV2(this);
  kinect.enableDepthImg(true);
  kinect.init();
  
  textSize(50); // 文字サイズの設定
  fill(255, 0, 0);
}

void draw(){
  int x, y, distance;
  
  rawData = kinect.getRawDepthData(); // 各画素における距離値の取得
  
  // 距離値から256諧調に変換
  img.loadPixels();
  for(int i = 0; i < 512 * 424; i++){
    img.pixels[i] = color(rawData[i] * 256 / 4500);
  }
  img.updatePixels();
  
  image(img, 0, 0); // 距離画像の表示
  
  // この例では中心点の計測とする
  x = 512 / 2;
  y = 424 / 2;
  distance = rawData[x + y * width];
  
  // 中心座標のガイド(円)と距離の表示
  ellipse(x, y, 10, 10);
  if(distance > 0) text(distance +" cm", x + 10, y - 10);
  else text("-- cm", x + 10, y - 10);
}
