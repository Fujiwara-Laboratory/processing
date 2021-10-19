// videoライブラリの読み込み(キャプチャに利用)
import processing.video.*;
// OpenCVライブラリの読み込み
import gab.opencv.*;

// カメラ用の変数
Capture cam;
int w = 640, h = 480;

// OpenCV用の画像メモリ
OpenCV cvImg;

// Canny用の変数
int val_l = 70, val_h = 120;

void setup(){
  // ウィンドウサイズと取り込みサイズを決めて初期化
  surface.setSize(w, h);
  cam = new Capture(this, w, h, 30);
  
  // 取り込み開始
  cam.start();
  
  // OpenCV形式の画像メモリを取得
  cvImg = new OpenCV(this, cam);
  
  textSize(20);
  fill(255);
}

void draw(){
  // カメラが取り込める状態(動いている場合)はメモリに
  if(cam.available()) cam.read();
  
  // 取り込んだ画像をOpenCV形式へ
  cvImg.loadImage(cam);
  
  // cannyエッジの抽出
  cvImg.findCannyEdges(val_l, val_h);
  
  // 処理結果を表示
  image(cvImg.getSnapshot(), 0, 0);
  
  // Canny用の閾値を画面へ表示
  text(val_l + " " + val_h, 10, 20);
}

void keyPressed(){
  if(keyCode == UP){
    if(val_l < val_h) val_l++;
  }else if(keyCode == DOWN){
    if(0 < val_l) val_l--;
  }
  if(keyCode == RIGHT){
    val_h++;
  }else if(keyCode == LEFT){
    if(val_l < val_h) val_h--;
  }
}
