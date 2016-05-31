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
  cvImg.findCannyEdges(20,75);
  
  // エッジの濃度値を定義しておく
  color edgeCol = color(255, 255, 255);

  // 処理結果をProcessing用メモリへコピー
  dstPImg = cvImg.getSnapshot();
  
  // 各画素で処理をする
  for(int j = 0; j < height; j++){
    for(int i = 0; i < width; i++){
      color c = dstPImg.get(i, j);
      if(c == edgeCol){ // エッジは白い
        srcPImg.set(i, j, color(0)); // 濃度値を黒へ
      }
    }
  }
}

void draw(){
  // setup関数で準備した画像を表示し続ける
  image(srcPImg, 0, 0);
}