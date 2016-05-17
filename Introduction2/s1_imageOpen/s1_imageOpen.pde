PImage srcImg;

void settings(){
  // 画像の読み込みとウィンドウの準備
  srcImg = loadImage("画像のファイルパス");
  size(srcImg.width, srcImg.height);
}

void draw(){
  // setup関数で準備した画像を表示し続ける
  image(srcImg, 0, 0);
}