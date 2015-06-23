// videoライブラリの読み込み(キャプチャに利用)
import processing.video.*;
// カメラ用の変数
Capture cam;
int w = 640, h = 480;

PImage srcImg = null, dstImg = null;
int kSize = 11; // 奇数にする

void setup(){
  cam = new Capture(this, w, h, 30);
  
  // 取り込み開始
  cam.start();
  
  // 画像の読み込みと出力用メモリの準備
  dstImg = new PImage(w, h);
  
  // 画像の配置を考慮したウィンドウサイズ
  size(w * 2, h);
}

void draw(){
  int i, j, m, n, r, g, b, x, y, k = kSize / 2, area;
  // カメラが取り込める状態(動いている場合)はメモリに
  if(cam.available()) cam.read();
  
  // 取り込んだフレームをコピー
  srcImg = cam;
  
  // 取り込んだフレームをコピー
  srcImg = cam;
  
  // 入力画像
  image(srcImg, 0, 0);
  
  // 各ピクセルをグレースケールにして保存用の配列にコピー
  dstImg.loadPixels();
  for(j = 0; j < h; j++){
    for(i = 0; i < w; i++){
      area = 0;
      r = g = b = 0;
      for(n = -k; n <= k; n++){
        for(m = -k; m <= k; m++){
          x = i + m;
          y = j + n;
          if(x >= 0 && x < w && y >= 0 && y < h){
            r += srcImg.pixels[x + y * w] >> 16 & 0xFF;
            g += srcImg.pixels[x + y * w] >> 8 & 0xFF;
            b += srcImg.pixels[x + y * w] & 0xFF;
            area++;
          }
        }
      }
      if(area > 0){
        r /= area;
        g /= area;
        b /= area;
      }
      dstImg.pixels[i + j * w] = color(r, g, b);
    }
  }
  dstImg.updatePixels();
  image(dstImg, w, 0);
}

