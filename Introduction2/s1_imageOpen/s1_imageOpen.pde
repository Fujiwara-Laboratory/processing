PImage srcImg;

void setup(){
  // 画像の読み込みとウィンドウの準備
  srcImg = loadImage("../../../../IMG/BostonCityFlow.jpg");
  size(srcImg.width, srcImg.height);
}

void draw(){
  // setup関数で準備した画像を表示し続ける
  image(srcImg, 0, 0);
}
