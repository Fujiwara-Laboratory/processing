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

// 処理用画像を作るときのスケール
int scale = 2;

void setup(){
  // ウィンドウサイズと取り込みサイズを決めて初期化
  surface.setSize(w, h);
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[0]);
  
  // 取り込み開始
  cam.start();
  
  // OpenCV形式の画像メモリを取得
  cvImg = new OpenCV(this, w / scale, h / scale);
  
  //顔検出器の読み込み
  cvImg.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
  

  // 線の初期化
  stroke(0, 255, 0);
  strokeWeight(3);
  
  // FPS表示用の文字サイズ定義
  textSize(24);
}

void draw(){
  // カメラが取り込める状態(動いている場合)はメモリに
  if(cam.available()) cam.read();
  
  // キャプチャした画像を表示する
  image(cam, 0, 0);
  
  // リサイズ用の画像へコピーしてから処理
  dstImg = cam.get();
  dstImg.resize(w / scale, h / scale);
  
  // 小さくした画像をOpenCV形式へ
  cvImg.loadImage(dstImg);
  
  // 顔検出 
  faces = cvImg.detect();
  
  // 検出した顔位置へ矩形を表示する
  noFill();
  for(int i = 0; i < faces.length; i++){
    rect(faces[i].x * scale, faces[i].y * scale, faces[i].width * scale, faces[i].height * scale);
  }
  
  // FPSの表示
  fill(255, 0, 0);
  text(frameRate , 30, 30);
}
