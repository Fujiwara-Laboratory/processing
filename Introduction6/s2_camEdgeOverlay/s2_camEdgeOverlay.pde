// videoライブラリの読み込み(キャプチャに利用)
import processing.video.*;
// OpenCVライブラリの読み込み
import gab.opencv.*;

// カメラ用の変数
Capture cam;
int w = 640, h = 480;

// ProcessingおよびOpenCV用の画像メモリ
PImage dstImg;
OpenCV cvImg;

// エッジの濃度値
color edgeCol = color(255, 255, 255);

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
  // キャプチャした画像を表示する
  image(cam, 0, 0);
  
  // 取り込んだ画像をOpenCV形式へ
  cvImg.loadImage(cam);
  
  // cannyエッジの抽出
  cvImg.findCannyEdges(70, 120);
  
  // 処理結果をProcessing形式へ
  dstImg = cvImg.getSnapshot();
  
  // エッジの画素にのみ、黒を描画(縁取り)
  for(int j = 0; j < h; j++){
    for(int i = 0; i < w; i++){
      color c = dstImg.pixels[i + j * w];
      if(c == edgeCol){ // エッジは白い
        set(i, j, color(0)); // 濃度値を黒へ
      }
    }
  }
}