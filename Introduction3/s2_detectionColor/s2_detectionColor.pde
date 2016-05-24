PImage srcImg;
float x1, y1, x2, y2;

void setup(){
  color c;
  float r, g, b;
  float r1, g1, b1, r2, g2, b2;
  
  // 画像の読み込みと出力用メモリの準備
  srcImg = loadImage("画像のファイルパス");
  surface.setSize(srcImg.width, srcImg.height);
  
  // マウス(検出したい対象)の色定義矩形の初期位置
  x1 = width;
  x2 = 0;
  y1 = height;
  y2 = 0;
  
  // マウス(検出したい対象)の色定義
  r1 = 80;
  r2 = 115;
  g1 = 10;
  g2 = 35;
  b1 = 10;
  b2 = 30;
  
  // 画像の2値化(内部処理なので画像は作らない)と矩形の座標の決定
  for(int j = 0; j < srcImg.height; j++){
    for(int i = 0; i < srcImg.width; i++){
      c = srcImg.pixels[i + j * srcImg.width];
      r = red(c);
      g = green(c);
      b = blue(c);
      if(r1 < r && r < r2 && g1 < g && g < g2 && b1 < b && b < b2){
        x1 = min(x1, i);
        y1 = min(y1, j);
        x2 = max(x2, i);
        y2 = max(y2, j);
      }
    }
  }
}

void draw(){
  // 入力画像を表示し続ける(背景の変わり)
  image(srcImg, 0, 0);
  
  // setup関数で準備した矩形を表示し続ける
  noFill();
  stroke(255, 0, 0);
  strokeWeight(3);
  rect(x1, y1, x2 - x1, y2 - y1);
}