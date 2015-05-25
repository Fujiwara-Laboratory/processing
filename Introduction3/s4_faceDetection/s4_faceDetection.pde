// ライブラリの読み込み
import gab.opencv.*;
import java.awt.Rectangle;

// OpenCV用の画像メモリ
OpenCV opencv;

// 顔検出結果の座標
Rectangle[] faces;

void setup(){
  // 画像の読み込みと出力用メモリの準備
  opencv = new OpenCV(this, "../../Image/faces.jpg");
  size(opencv.width, opencv.height);

  // 顔検出
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  faces = opencv.detect();
}

void draw(){
  // setup関数で準備した画像を表示し続ける
  image(opencv.getInput(), 0, 0);

  // setup関数で準備した矩形を表示し続ける
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  for(int i = 0; i < faces.length; i++){
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }
}
