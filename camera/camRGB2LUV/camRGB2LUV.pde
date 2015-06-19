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

void rgb2luv(int R, int G, int B, int LUV[]){
  float rf, gf, bf;
  float r, g, b, X_, Y_, Z_, X, Y, Z, fx, fy, fz, xr, yr, zr;
  float L;
  float eps = 216.f / 24389.f;
  float k = 24389.f / 27.f;
  
  float Xr = 0.964221f;  // reference white D50
  float Yr = 1.0f;
  float Zr = 0.825211f;
  
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
  
  X =  0.436052025f * r + 0.385081593f * g + 0.143087414f * b;
  Y =  0.222491598f * r + 0.71688606f  * g + 0.060621486f * b;
  Z =  0.013929122f * r + 0.097097002f * g + 0.71418547f  * b;
  
  // XYZ to Luv
  float u, v, u_, v_, ur_, vr_;
  
  u_ = 4 * X / (X + 15 * Y + 3 * Z);
  v_ = 9 * Y / (X + 15 * Y + 3 * Z);
  
  ur_ = 4 * Xr / (Xr + 15 * Yr + 3 * Zr);
  vr_ = 9 * Yr / (Xr + 15 * Yr + 3 * Zr);
  
  yr = Y/Yr;
  
  if(yr > eps) L =  (float)(116 * Math.pow(yr, 1 / 3.) - 16);
  else L = k * yr;
  
  u = 13 * L * (u_ - ur_);
  v = 13 * L * (v_ - vr_);
  
  LUV[0] = (int) (2.55 * L + .5);
  LUV[1] = (int) (u + .5);
  LUV[2] = (int) (v + .5);
}
