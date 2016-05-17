// videoライブラリの読み込み(キャプチャに利用)
import processing.video.*;
// OpenCVライブラリの読み込み
import gab.opencv.*;
// 矩形ライブラリの読み込み
import java.awt.Rectangle;

// カメラ用の変数
Capture cam;
int w = 640, h = 480;
PImage ipImg;

// OpenCV用の画像メモリ
OpenCV cvImg;

// 顔検出結果の座標
Rectangle[] faces;

int faceCount = 0;
int scale = 2;

void setup(){
  // ウィンドウサイズと取り込みサイズを決めて初期化
  size(w, h);
  cam = new Capture(this, w, h, 30); // VGAだと処理落ちがひどい
  
  // 取り込み開始
  cam.start();
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
}

void draw(){
  // カメラが取り込める状態(動いている場合)はメモリに
  if(cam.available()) cam.read();
  // キャプチャした画像を表示する
  image(cam, 0, 0);
  
  // リサイズ用の画像へコピーしてから処理
  ipImg = cam.get();
  ipImg.resize(w / scale, h / scale);
  
  // 小さくした画像をOpenCV形式へ
  cvImg = new OpenCV(this, ipImg);
  
  // 顔検出
  cvImg.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  faces = cvImg.detect();
  
  // 検出した顔位置へ矩形を表示する
  for(int i = 0; i < faces.length; i++){
    rect(faces[i].x * scale, faces[i].y * scale, 
         faces[i].width * scale, faces[i].height * scale);
  }
}
