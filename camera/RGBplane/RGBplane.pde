// videoライブラリの読み込み(キャプチャに利用)
import processing.video.*;
// カメラ用の変数
Capture cam;
int w = 640, h = 480;
PImage srcImg, rImg, gImg, bImg;

void setup(){
  // ウィンドウサイズと取り込みサイズを決めて初期化
  size(w, h);
  cam = new Capture(this, w, h, 30);
  
  // 取り込み開始
  cam.start();
  
  size(w * 2, h * 2);
  rImg = new PImage(w, h);
  gImg = new PImage(w, h);
  bImg = new PImage(w, h);
}

void draw(){
  color c;
  // カメラが取り込める状態(動いている場合)はメモリに
  if(cam.available()) cam.read();
  
  srcImg = cam;
  
  for(int j = 0; j < h; j++){
    for(int i = 0; i < w; i++){
      c = srcImg.pixels[i + j * w];
      rImg.set(i, j, color(red(c)));
      gImg.set(i, j, color(green(c)));
      bImg.set(i, j, color(blue(c)));
    }
  }
  image(srcImg, 0, 0);
  image(rImg, w, 0);
  image(gImg, 0, h);
  image(bImg, w, h);
}
