PImage srcImg, smallImg;

void settings(){
  // 画像の読み込みとウィンドウの準備
  srcImg = loadImage("画像のファイルパス");
  size(srcImg.width + srcImg.width / 2, srcImg.height);
}

void setup(){
  // 出力用メモリの準備
  //smallImg = srcImg;
  smallImg = srcImg.get();
  smallImg.resize(srcImg.width / 2, srcImg.height / 2);
}

void draw(){
  // setup関数で準備した画像を表示し続ける
  image(srcImg, 0, 0);
  // 入力画像の横にサイズを小さくした画像を表示
  image(smallImg, srcImg.width, 0);
}