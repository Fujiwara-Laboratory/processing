// videoライブラリの読み込み(キャプチャに利用)
import processing.video.*;
// OpenCVライブラリの読み込み
import gab.opencv.*;
// 矩形ライブラリの読み込み
import java.awt.Rectangle;

// カメラ用の変数
Capture cam;
int w = 640, h = 480;

// OpenCV用の画像メモリ
OpenCV cvImg;

// 顔検出結果の座標
Rectangle[] faces;

void setup(){
  // ウィンドウサイズと取り込みサイズを決めて初期化
  surface.setSize(w, h);
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[0]); // VGAだと処理落ちがひどいかも
  
  // 取り込み開始
  cam.start();
  
  // OpenCV形式の画像メモリを取得
  cvImg = new OpenCV(this, cam);
  
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
  
  // 取り込んだ画像をOpenCV形式へ
  cvImg.loadImage(cam);
  
  // 顔検出 
  faces = cvImg.detect();
  
  // 検出した顔位置へ矩形を表示する
  noFill();
  for(int i = 0; i < faces.length; i++){
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }
  
  // FPSの表示
  fill(255, 0, 0);
  text(frameRate , 30, 30);
}
