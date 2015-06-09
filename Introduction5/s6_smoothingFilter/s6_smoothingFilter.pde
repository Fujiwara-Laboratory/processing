// videoライブラリの読み込み(キャプチャに利用)
import processing.video.*;
// カメラ用の変数
Capture cam;
int w = 640, h = 480;

PImage srcImg = null, dstImg = null;
int kSize = 11; // 奇数にする

void setup(){
  // ウィンドウサイズと取り込みサイズを決めて初期化
  size(w, h);
  cam = new Capture(this, w, h, 30);
  
  // 取り込み開始
  cam.start();
  
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
  
  dstImg = srcImg.get(); // dstImg = srcImg;はダメ(順番を変えればなんとかなるが)
  dstImg.filter(BLUR, 6);
  
  // 入力画像
  image(srcImg, 0, 0);
  // 平滑化画像
  image(dstImg, w, 0);
}

