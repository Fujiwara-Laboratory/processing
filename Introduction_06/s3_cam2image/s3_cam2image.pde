// videoライブラリの読み込み(キャプチャに利用)
import processing.video.*;
// カメラ用の変数
Capture cam;
int w = 640, h = 480;

// 保存用の画像
PImage saveImg;
int count = 0;

void setup(){
  // ウィンドウサイズと取り込みサイズを決めて初期化
  surface.setSize(w, h);
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[0]);
  
  // 取り込み開始
  cam.start();
}

void draw(){
  // カメラが取り込める状態(動いている場合)はメモリに
  if(cam.available()) cam.read();
  
  // 取り込んだフレームを保存用のメモリにコピー
  saveImg = cam;
  // 読み込んだ画像を表示
  image(cam, 0, 0);
}

void keyPressed(){
  // 保存用のメモリを画像ファイルに出力(実際にはcamでも問題ない)
  saveImg.save(nf(count, 4) + ".jpg");
  count++;
}
