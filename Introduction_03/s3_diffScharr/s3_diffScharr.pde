PImage srcImg, grayImg, sblImg;

void setup(){
  color c;
  float r, g, b, f ;
  
  // 画像の読み込みと出力用メモリの準備
  srcImg = loadImage("画像のファイルパス");
  surface.setSize(srcImg.width * 2, srcImg.height *2);
  grayImg = new PImage(srcImg.width, srcImg.height);
  sblImg = new PImage(srcImg.width, srcImg.height);
  
  // 画像のグレースケール化(内部処理なので画像は作らない)と矩形の座標の決定
  for(int j = 0; j < srcImg.height; j++){
    for(int i = 0; i < srcImg.width; i++){
      c = srcImg.pixels[i + j * srcImg.width];
      r = red(c);
      g = green(c);
      b = blue(c);
      f = (0.298912 * r + 0.586611 * g + 0.114478 * b);
      grayImg.set(i, j, color(f)); // 位置を指定してその画素へ書き込む
    }
  }
  
  sobelFilterScharr(grayImg, sblImg); // Scharrフィルタ
}

void draw(){
  image(srcImg, 0, 0); // 入力画像
  
  image(grayImg, 0, srcImg.height); // グレースケール画像
  
  image(sblImg, srcImg.width, srcImg.height); // ソーベルフィルタ
}

// 移植性を考慮して関数にしておく
void sobelFilterScharr(PImage src, PImage dst){
  int i, j, x, y, m, n;
  int sf[][] = {{ -3, 0, 3},
                {-10, 0, 10},
                { -3, 0, 3}};
  int k = 3, v, s;
  
  for(j = 0; j < src.height; j++){
    for(i = 0; i < src.width; i++){
      
      s = 0;
      for(n = 0; n < k; n++){
        for(m = 0; m < k; m++){
          x = i + m - 1;
          y = j + n - 1;
          x = constrain(x, 0, src.width - 1);
          y = constrain(y, 0, src.height - 1);
          v = src.pixels[x + y * src.width] & 0xFF;
          s += v * sf[n][m];
        }
      }
      s = abs(s);
      s /= 10;
      dst.set(i, j, color(s));
    }
  }
}
