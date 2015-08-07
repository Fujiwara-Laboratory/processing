// videoライブラリの読み込み(キャプチャに利用)
import processing.video.*;
// OpenCVライブラリの読み込み
import gab.opencv.*;
// 矩形ライブラリの読み込み
import java.awt.Rectangle;

// カメラ用の変数
Capture cam;

// OpenCV用の画像メモリ
OpenCV ipCV;

// 顔検出結果の座標
Rectangle[] faces;

int dScl = 2;
PImage ipImg, histoImg;
int [][]histo2D;

// ウィンドウサイズと取り込みサイズを決めて初期化
//  int w = 1280, h = 720;
int w = 640, h = 480;
  
void setup(){
  size(w, h);
//  cam = new Capture(this, w, h, "FaceTime HD カメラ（内蔵）", 30);
//  cam = new Capture(this, w, h, "FaceTime Camera (Built-in)", 30);
  cam = new Capture(this, w, h, 30);
  cam.start(); // 取り込み開始
  
  histoImg = createImage(256, 256, RGB);
  histo2D = new int[256][256];
}

void draw(){
  int i, j, fNum = 0, faceArea = 0, fx, fy, fw, fh, r, g, b, luv[] = new int[3];
  // カメラが取り込める状態(動いている場合)はメモリに
  if(cam.available()) cam.read();
  ipImg = cam.get();
  ipImg.resize(w / dScl, h / dScl);
  
  // 取り込んだ画像をOpenCV形式へ
  ipCV = new OpenCV(this, ipImg);
  
  // 顔検出
  ipCV.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  faces = ipCV.detect();
  
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  image(cam, 0, 0);
  if(faces.length == 0) return; // 顔が検出されなければ終了
  for(i = 0; i < faces.length; i++){ // 最大面積の矩形を探す
    if(faceArea < faces[i].width * faces[i].height){
      faceArea = faces[i].width * faces[i].height;
      fNum = i;
    }
  }
  fx = faces[fNum].x * dScl;
  fy = faces[fNum].y * dScl;
  fw = faces[fNum].width * dScl;
  fh = faces[fNum].height * dScl;
  rect(fx, fy, fw, fh);
  for(i = 0; i < 256 * 256; i++) 
  
  for(j = fy; j < fy + fh; j++){
    for(i = fx; i < fx + fw; i++){
      r = cam.pixels[i + j * w] >> 16 & 0xFF;
      g = cam.pixels[i + j * w] >> 8 & 0xFF;
      b = cam.pixels[i + j * w] & 0xFF;
      rgb2luv(r, g, b, luv);
      
    }
  }
  
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
