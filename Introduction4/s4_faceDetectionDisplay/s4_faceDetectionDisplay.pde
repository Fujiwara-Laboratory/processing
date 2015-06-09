// ライブラリの読み込み
import gab.opencv.*;
import java.awt.Rectangle;

// ProcessingおよびOpenCV用の画像メモリ
PImage srcPImg, facePImg;
OpenCV cvImg;

// 顔検出結果の座標
Rectangle[] faces;

void setup(){
  // 画像の読み込みと処理用メモリ(OpenCV)の準備
  srcPImg = loadImage("../../Image/faces.jpg");
  size(srcPImg.width, srcPImg.height);
  cvImg = new OpenCV(this, srcPImg);

  // 顔検出
  cvImg.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  faces = cvImg.detect();
}

void draw(){
  int wPos = 0;
  // 読み込んだ画像を表示し続ける
  image(cvImg.getInput(), 0, 0);

  // setup関数で準備した矩形を表示し続ける
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  for(int i = 0; i < faces.length; i++){
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    
    // 矩形の領域を画像として保存
    facePImg = get(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    image(facePImg, wPos, 0);
    wPos += facePImg.width;
  }
}
