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
OpenCV cvImg;
PImage faceImg;

// 顔検出結果の座標
Rectangle[] faces;

void setup(){
  // ウィンドウサイズと取り込みサイズを決めて初期化
  surface.setSize(w, h);
  cam = new Capture(this, w, h, 30); // VGAだと処理落ちがひどい
  
  // 取り込み開始
  cam.start();
  
  // OpenCV形式の画像メモリを取得
  cvImg = new OpenCV(this, cam);
  
  //顔検出器の読み込み
  cvImg.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
  
  // 各種設定の初期化
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  faceImg = loadImage("画像ファイル名");
}

void draw(){
  // カメラが取り込める状態(動いている場合)はメモリに
  if(cam.available()) cam.read();
  // キャプチャした画像を表示する
  image(cam, 0, 0);
  
  // 取り込んだ画像をOpenCV形式へ
  cvImg.loadImage(cam);
  
  // 顔検出
  faces = cvImg.detect();
  
  // 検出した顔位置へ矩形を表示する
  for(int i = 0; i < faces.length; i++){
    image(faceImg, faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }
}
