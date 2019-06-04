// videoライブラリの読み込み(キャプチャに利用)
import processing.video.*;
// カメラ用の変数
Capture cam1, cam2;
int w1 = 320, h1 = 180;
int w2 = 480, h2 = 270;

void setup(){
  // ウィンドウサイズと取り込みサイズを決めて初期化
  surface.setSize(w1 + w2, h1 > h2 ? h1 : h2);
  
  cam1 = new Capture(this, w1, h1, "FaceTime HD Camera (Built-in)", 30);
  cam2 = new Capture(this, w2, h2, "HD Pro Webcam C920", 30);
  
  // 取り込み開始
  cam1.start();
  cam2.start();
}

void draw(){
  // カメラが取り込める状態(動いている場合)はメモリに
  if(cam1.available()) cam1.read();
  if(cam2.available()) cam2.read();
  
  // 読み込んだ画像を表示
  image(cam1, 0, 0);
  image(cam2, w1, 0);
}
