// videoライブラリの読み込み(キャプチャに利用)
import processing.video.*;
// OpenCVライブラリの読み込み
import gab.opencv.*;

// カメラ用の変数
Capture cam;
int w = 640, h = 480;

// OpenCV用の画像メモリ
OpenCV cvImg;

void setup(){
  // ウィンドウサイズと取り込みサイズを決めて初期化
  surface.setSize(w, h);
  cam = new Capture(this, w, h, 30);
  
  // 取り込み開始
  cam.start();
  
  // OpenCV形式の画像メモリを取得
  cvImg = new OpenCV(this, cam);
}

void draw(){
  // カメラが取り込める状態(動いている場合)はメモリに
  if(cam.available()) cam.read();
  
  // 取り込んだ画像をOpenCV形式へ
  cvImg.loadImage(cam);
  
  // cannyエッジの抽出
  cvImg.findCannyEdges(50, 120);
  
  // 処理結果を表示
  image(cvImg.getSnapshot(), 0, 0);
}
