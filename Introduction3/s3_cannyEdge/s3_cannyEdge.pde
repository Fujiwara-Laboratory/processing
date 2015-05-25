// ライブラリの読み込み
import gab.opencv.*;

// ProcessingおよびOpenCV用の画像メモリ
PImage srcImg, dstImg;
OpenCV opencv;

void setup(){
  // 画像の読み込みと出力用メモリの準備
  srcImg = loadImage("../../Image/redMouse.bmp");
  size(srcImg.width, srcImg.height);
  opencv = new OpenCV(this, srcImg);
  
  // cannyエッジの抽出
  opencv.findCannyEdges(20,75);
  
  // 処理結果をProcessing用メモリへコピー
  dstImg = opencv.getSnapshot();
}

void draw(){
  // setup関数で準備した画像を表示し続ける
  image(dstImg, 0, 0);
}
