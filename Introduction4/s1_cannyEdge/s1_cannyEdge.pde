// ライブラリの読み込み
import gab.opencv.*;

// ProcessingおよびOpenCV用の画像メモリ
PImage srcPImg, dstPImg;
OpenCV cvImg;

void setup(){
  // 画像の読み込みと処理用メモリ(OpenCV)の準備
  srcPImg = loadImage("画像のファイルパス");
  surface.setSize(srcPImg.width, srcPImg.height);
  cvImg = new OpenCV(this, srcPImg);
  
  // cannyエッジの抽出
  cvImg.findCannyEdges(20, 75);
  
  // 処理結果をProcessing用メモリへコピー
  dstPImg = cvImg.getSnapshot();
}

void draw(){
  // setup関数で準備した画像を表示し続ける
  image(dstPImg, 0, 0);
}