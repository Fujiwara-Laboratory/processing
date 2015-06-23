// videoライブラリの読み込み(キャプチャに利用)
import processing.video.*;
// カメラ用の変数
Capture cam;
int w = 640, h = 480;

PImage srcImg = null, dstImg = null;
PGraphics histImg = null;
int histScale = 2; // ヒストグラムのグラフを表示する際の倍率

void setup(){
  // サイズを決めて初期化
  size(w, h);
  cam = new Capture(this, w, h, 30);
  
  // 取り込み開始
  cam.start();
  
  // 画像の読み込みと出力用メモリの準備
  dstImg = new PImage(w, h);
  // ヒストグラム用の画像(描画関数を使うためPGraphics)用のメモリ
  histImg = createGraphics(256 * histScale, 180 * histScale);
  
  // 画像の配置を考慮したウィンドウサイズ
  size(w + histImg.width, h * 2);
}

void draw(){
  // カメラが取り込める状態(動いている場合)はメモリに
  if(cam.available()) cam.read();
  
  // 取り込んだフレームをコピー
  srcImg = cam;
  
  // ヒストグラムを算出してグラフを画像化
  genHistogram(srcImg, histImg, histScale);
  
  // 入力画像
  image(srcImg, 0, 0);
  
  // 入力画像の下にグレースケール画像
  image(dstImg, 0, h);
  
  // 入力画像の右にヒストグラム
  image(histImg, w, 0);
}

// 移植性を考慮して画像や倍率を引数にしておく
void genHistogram(PImage src, PGraphics hist, int hScale){
  long aryR[] = new long[256], aryG[] = new long[256], aryB[] = new long[256], maxValue = 0;
  int i, j;
  float px, x, pry, ry, pgy, gy, pby, by;
  for(i = 0; i < 256; i++) aryR[i] = aryG[i] = aryB[i] = 0; // 各ビンを0に初期化
  
  // ヒストグラムへ保存
  for(j = 0; j < src.height; j++){
    for(i = 0; i < src.width; i++){
      aryR[src.pixels[i + j * w] >> 16 & 0xFF]++;
      aryG[src.pixels[i + j * w] >> 8 & 0xFF]++;
      aryB[src.pixels[i + j * w] & 0xFF]++;
    }
  }
  // 最大頻度を探す
  for(i = 0; i < 256; i++){
    if(maxValue < aryR[i]) maxValue = aryR[i];
    if(maxValue < aryG[i]) maxValue = aryG[i];
    if(maxValue < aryB[i]) maxValue = aryB[i];
  }
  
  // グラフ描画の開始
  hist.beginDraw();
  hist.background(255);

  // 折れ線グラフの描画
  stroke(0);
  strokeWeight(hScale);
  // 一番左の点
  px = 0;
  pry = hist.height - (hist.height * aryR[0]) / maxValue  - 1;
  pgy = hist.height - (hist.height * aryG[0]) / maxValue  - 1;
  pby = hist.height - (hist.height * aryB[0]) / maxValue  - 1;
  for(i = 0; i < 256; i++){
    // 配列の中身の値で順に折れ線グラフを描いていく
    x = i * hScale;
    ry = hist.height - (hist.height * aryR[i]) / maxValue  - 1;
    gy = hist.height - (hist.height * aryG[i]) / maxValue  - 1;
    by = hist.height - (hist.height * aryB[i]) / maxValue  - 1;
    hist.stroke(255, 0, 0);
    hist.line(x, ry, px, pry);
    hist.stroke(0, 255, 0);
    hist.line(x, gy, px, pgy);
    hist.stroke(0, 0, 255);
    hist.line(x, by, px, pby);
    px = x;
    pry = ry;
    pgy = gy;
    pby = by;
  }
  hist.endDraw(); // PGraphicsの描画完了
}
