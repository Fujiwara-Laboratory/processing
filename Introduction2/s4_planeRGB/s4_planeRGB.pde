PImage srcImg, rImg, gImg, bImg;

void setup(){
  // 画像の読み込みとウィンドウの準備
  srcImg = loadImage("画像のファイルパス");
  surface.setSize(srcImg.width * 2, srcImg.height * 2);
  
  color c;
  
  // 出力用メモリの準備
  rImg = new PImage(srcImg.width, srcImg.height);
  gImg = new PImage(srcImg.width, srcImg.height);
  bImg = new PImage(srcImg.width, srcImg.height);
  
  // 画像を各プレーンに分けて、そのプレーン毎にグレースケール化
  for(int j = 0; j < srcImg.height; j++){
    for(int i = 0; i < srcImg.width; i++){
      c = srcImg.pixels[i + j * srcImg.width];
      //rImg.set(i, j, color(red(c), 0, 0));
      //gImg.set(i, j, color(0, green(c), 0));
      //bImg.set(i, j, color(0, 0, blue(c)));
      rImg.set(i, j, color(red(c)));
      gImg.set(i, j, color(green(c)));
      bImg.set(i, j, color(blue(c)));
    }
  }
}

void draw(){
  image(srcImg, 0, 0);
  image(rImg, srcImg.width, 0);
  image(gImg, 0, srcImg.height);
  image(bImg, srcImg.width, srcImg.height);
}
