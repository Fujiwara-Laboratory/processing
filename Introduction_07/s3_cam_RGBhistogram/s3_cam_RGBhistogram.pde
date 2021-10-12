// videoライブラリの読み込み(キャプチャに利用)
import processing.video.*;
// カメラ用の変数
Capture cam;
int w = 640, h = 480, shiftPix = 3;

PImage srcImg = null;
PGraphics histImg;
int histScale = 2; // ヒストグラムのグラフを表示する際の倍率

void setup(){
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[0]);
  //cam = new Capture(this, w, h, 30);
  
  // 取り込み開始
  cam.start();
  
  // ヒストグラム用の画像(描画関数を使うためPGraphics)用のメモリ
  histImg = createGraphics(256 * histScale, 120 * histScale);
  
  // 画像の配置を考慮したウィンドウサイズ
  int dh = h;
  if(h < histImg.height * shiftPix) dh = histImg.height * shiftPix;
  surface.setSize(w + histImg.width, dh);
}

void draw(){
  background(0);
  // カメラが取り込める状態(動いている場合)はメモリに
  if(cam.available()) cam.read();
  
  // 取り込んだフレームをコピー
  srcImg = cam;
  // 入力画像
  image(srcImg, 0, 0);
  
  // 赤ヒストグラムを算出してグラフを画像化
  genHistogram(srcImg, histImg, histScale, 0);
  image(histImg, w + shiftPix, 0);
  
  // 緑ヒストグラムを算出してグラフを画像化
  genHistogram(srcImg, histImg, histScale, 1);
  image(histImg, w + shiftPix, histImg.height + shiftPix);
  
  // 青ヒストグラムを算出してグラフを画像化
  genHistogram(srcImg, histImg, histScale, 2);
  image(histImg, w + shiftPix, histImg.height * 2 + shiftPix * 2);
}

// 移植性を考慮して画像や倍率を引数にしておく
void genHistogram(PImage src, PGraphics hist, float hScale, int swRGB){
  long aryH[] = new long[256], maxValue = 0;
  int i, j;
  float px, x, py, y;
  for(i = 0; i < 256; i++) aryH[i] = 0; // 各ビンを0に初期化
  
  // ヒストグラムへ保存
  for(j = 0; j < src.height; j++){
    for(i = 0; i < src.width; i++){
      if(swRGB == 0) aryH[src.pixels[i + j * w] >> 16 & 0xFF]++;
      else if(swRGB == 1) aryH[src.pixels[i + j * w] >> 8 & 0xFF]++;
      else if(swRGB == 2) aryH[src.pixels[i + j * w] & 0xFF]++;
    }
  }
  // 最大頻度を探す
  for(i = 0; i < 256; i++){
    if(maxValue < aryH[i]) maxValue = aryH[i];
  }
  
  // グラフ描画の開始
  hist.beginDraw();
  hist.background(255);

  // 折れ線グラフの描画
  stroke(0);
  strokeWeight(hScale);
  if(swRGB == 0) hist.stroke(255, 0, 0);
  else if(swRGB == 1) hist.stroke(0, 255, 0);
  else if(swRGB == 2) hist.stroke(0, 0, 255);
  
  // 一番左の点
  px = 0;
  py = hist.height - (hist.height * aryH[0]) / maxValue  - 1;
  for(i = 0; i < 256; i++){
    // 配列の中身の値で順に折れ線グラフを描いていく
    x = i * hScale;
    y = hist.height - (hist.height * aryH[i]) / maxValue  - 1;
    
    hist.line(x, y, px, py);
    px = x;
    py = y;
  }
  hist.endDraw(); // PGraphicsの描画完了
}
