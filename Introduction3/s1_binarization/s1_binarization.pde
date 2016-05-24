PImage srcImg, dstImg;

void setup(){
  color c;
  float r, g, b;
  float r1, g1, b1, r2, g2, b2;
  
  // 画像の読み込みと出力用メモリの準備
  srcImg = loadImage("画像のファイルパス");
  surface.setSize(srcImg.width, srcImg.height);
  dstImg = new PImage(srcImg.width, srcImg.height);
  
  // マウス(検出したい対象)の色定義
  r1 = 80;
  r2 = 115;
  g1 = 10;
  g2 = 35;
  b1 = 5;
  b2 = 30;
  
  // 画像の2値化
  for(int j = 0; j < srcImg.height; j++){
    for(int i = 0; i < srcImg.width; i++){
      c = srcImg.pixels[i + j * srcImg.width];
      r = red(c);
      g = green(c);
      b = blue(c);
      if(r1 < r && r < r2 && g1 < g && g < g2 && b1 < b && b < b2){
        dstImg.set(i, j, color(255));
      }else{
        dstImg.set(i, j, color(0));
      }
    }
  }
}

void draw(){
  // setup関数で準備した画像を表示し続ける
  image(dstImg, 0, 0);
}