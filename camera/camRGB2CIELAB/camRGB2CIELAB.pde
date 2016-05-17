// videoライブラリの読み込み(キャプチャに利用)
import processing.video.*;
// カメラ用の変数
Capture cam;
int w = 640, h = 480;
PImage srcImg, lImg, uImg, vImg;

void setup(){
  // ウィンドウサイズと取り込みサイズを決めて初期化
  size(w, h);
  cam = new Capture(this, w, h, 30);
  
  // 取り込み開始
  cam.start();
  
  size(w * 2, h * 2);
  lImg = new PImage(w, h);
  uImg = new PImage(w, h);
  vImg = new PImage(w, h);
}

void draw(){
  color c;
  int r, g, b, luv[] = new int[3];
  // カメラが取り込める状態(動いている場合)はメモリに
  if(cam.available()) cam.read();
  
  srcImg = cam;
  
  for(int j = 0; j < h; j++){
    for(int i = 0; i < w; i++){
      r = srcImg.pixels[i + j * w] >> 16 & 0xFF;
      g = srcImg.pixels[i + j * w] >> 8 & 0xFF;
      b = srcImg.pixels[i + j * w] & 0xFF;
      rgb2luv(r, g, b, luv);
      lImg.set(i, j, color(luv[0]));
      uImg.set(i, j, color(luv[1]));
      vImg.set(i, j, color(luv[2]));
    }
  }
  image(srcImg, 0, 0);
  image(lImg, w, 0);
  image(uImg, 0, h);
  image(vImg, w, h);
}

void rgb2luv(int R, int G, int B, int CIELAB[]){
  float r, g, b, X, Y, Z;
  
  // RGB to XYZ
  r = R / 255.f; //R 0..1
  g = G / 255.f; //G 0..1
  b = B / 255.f; //B 0..1
  
  // assuming sRGB (D65)
  if(r <= 0.04045) r = r / 12;
  else r = (float)Math.pow((r + 0.055) / 1.055, 2.4);
  
  if(g <= 0.04045) g = g / 12;
  else g = (float)Math.pow((g + 0.055) / 1.055, 2.4);
  
  if(b <= 0.04045) b = b / 12;
  else b = (float)Math.pow((b + 0.055) / 1.055, 2.4);
  
  r *= 100;
  g *= 100;
  b *= 100;
  
  X =  0.436052025f * r + 0.385081593f * g + 0.143087414f * b;
  Y =  0.222491598f * r + 0.71688606f  * g + 0.060621486f * b;
  Z =  0.013929122f * r + 0.097097002f * g + 0.71418547f  * b;
  
  // XYZ to CIE LAB
  double x = X / 95.047;
  double y = Y / 100;
  double z = Z / 108.883;
  
  if(x > 0.008856) x = Math.pow(x, 1.0 / 3.0);
  else x = (7.787 * x) + (16.0 / 116.0);
  
  if(y > 0.008856) y = Math.pow(y, 1.0 / 3.0);
  else y = (7.787 * y) + (16.0 / 116.0);
  
  if(z > 0.008856) z = Math.pow(z, 1.0 / 3.0);
  else z = (7.787 * z) + (16.0 / 116.0);

  CIELAB[0] = (int)(116.0 * y) - 16;
  CIELAB[1] = (int)(500.0 * (x - y));
  CIELAB[2] = (int)(200.0 * (y - z));
}
