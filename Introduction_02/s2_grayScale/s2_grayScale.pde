PImage srcImg, dstImg;
boolean flagDispOrignal = true;

void setup(){
  // 画像の読み込みとウィンドウの準備
  srcImg = loadImage("画像のファイルパス");
  surface.setSize(srcImg.width, srcImg.height);
  
  color c;
  float r, g, b, f;
  
  // 出力用メモリの準備
  dstImg = new PImage(srcImg.width, srcImg.height);
  
  // 画像のグレースケール化
  for(int j = 0; j < srcImg.height; j++){
    for(int i = 0; i < srcImg.width; i++){
      c = srcImg.pixels[i + j * srcImg.width];
      r = red(c);
      g = green(c);
      b = blue(c);
      f = (0.298912 * r + 0.586611 * g + 0.114478 * b);
      dstImg.set(i, j, color(f)); // 位置を指定してその画素へ書き込む
    }
  }
}

void draw(){
  // フラグに応じて入力画像 or グレースケール画像の切り替え
  if(flagDispOrignal){
    image(srcImg, 0, 0);
  }else{
    image(dstImg, 0, 0);
  }
}

void keyPressed(){
  // booleanの値を反転
  if(key == ' ') flagDispOrignal = ! flagDispOrignal;
}
