// videoライブラリの読み込み(キャプチャに利用)
import processing.video.*;
// OpenCVライブラリの読み込み
import gab.opencv.*;
// 矩形ライブラリの読み込み
import java.awt.Rectangle;

// カメラ用の変数
Capture cam;
int w = 640, h = 480;

// ProcessingおよびOpenCV用の画像メモリ
PImage dstImg;
OpenCV cvImg;

// 顔検出結果の座標
Rectangle[] faces;

void setup(){
  // ウィンドウサイズと取り込みサイズを決めて初期化
  size(w, h);
  cam = new Capture(this, w / 2, h / 2, 30);
  dstImg = new PImage(w, h);
  
  // 取り込み開始
  cam.start();
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
}

void draw(){
  // カメラが取り込める状態(動いている場合)はメモリに
  if(cam.available()) cam.read();
  
  // 取り込んだ画像をOpenCV形式へ
  cvImg = new OpenCV(this, cam);
  
  // 顔検出
  cvImg.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  faces = cvImg.detect();
  
  // 縦横それぞれ1/2で読み込んだ画像を元に戻す
  dstImg.copy(cam, 0, 0, w / 2, h / 2, 0, 0, w, h);
  
  // setup関数で準備した画像を表示し続ける
  image(dstImg, 0, 0);
  
  // setup関数で準備した矩形を表示し続ける
  for(int i = 0; i < faces.length; i++){
    // 処理画像は縦横それぞれ1/2なので2倍して表示する
    rect(faces[i].x * 2, faces[i].y * 2, faces[i].width * 2, faces[i].height * 2);
  }
}
