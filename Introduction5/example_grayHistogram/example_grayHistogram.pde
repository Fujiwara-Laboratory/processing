PImage srcImg, dstImg;
PGraphics histImg = null;
int histScale = 2; // ヒストグラムのグラフを表示する祭の倍率

void setup(){
  // 画像の読み込みと出力用メモリの準備
  srcImg = loadImage("画像のファイルパス");
  dstImg = new PImage(srcImg.width, srcImg.height);
  // ヒストグラム用の画像(描画関数を使うためPGraphics)用のメモリ
  histImg = createGraphics(256 * histScale, 180 * histScale);
  // 画像サイズに応じたウィンドウサイズの決定
  surface.setSize(srcImg.width + histImg.width, srcImg.height * 2);
  // 画像をグレースケールに
  PRGB2gray(srcImg, dstImg);
  // ヒストグラムを算出してグラフを画像化
  genHistogram(dstImg, histImg, histScale);
}

void draw(){
  // 入力画像
  image(srcImg, 0, 0);
  
  // 入力画像の下にグレースケール画像
  image(dstImg, 0, srcImg.height);
  
  // 入力画像の右にヒストグラム
  image(histImg, srcImg.width, 0);
}

void genHistogram(PImage gray, PGraphics hist, int hScale){
  long histAry[] = new long[256], maxValue = 0;
  int i, j, g;
  float px, py, x, y;
  for(i = 0; i < 256; i++) histAry[i] = 0; // 各ビンを0に初期化
  
  // ヒストグラムへ保存
  for(j = 0; j < gray.height; j++){
    for(i = 0; i < gray.width; i++){
       // RGB全て同じ値が入っているという前提なので青取得と同じ演算で済ましている
      g = gray.pixels[i + j * gray.width] & 0xFF;
      histAry[g]++;
    }
  }
  // 最大頻度を探す
  for(i = 0; i < 256; i++) if(maxValue < histAry[i]) maxValue = histAry[i];
  
  // グラフ描画の開始
  hist.beginDraw();
  hist.background(255);

  // 折れ線グラフの描画
  hist.stroke(0);
  hist.strokeWeight(hScale);
  // 一番左の点
  px = 0;
  py = hist.height - (hist.height * histAry[0]) / maxValue  - 1;
  for(i = 0; i < 256; i++){
    // 配列の中身の値で順に折れ線グラフを描いていく
    x = i * hScale;
    y = hist.height - (hist.height * histAry[i]) / maxValue - 1;
    hist.line(x, y, px, py);
    px = x;
    py = y;
  }
  hist.endDraw(); // PGraphicsの描画完了
}

void PRGB2gray(PImage src, PImage dst){
  color c;
  float r, g, b, f;
  // 画像のグレースケール化
  for(int j = 0; j < src.height; j++){
    for(int i = 0; i < src.width; i++){
      c = src.pixels[i + j * src.width];
      r = red(c);
      g = green(c);
      b = blue(c);
      f = (0.298912 * r + 0.586611 * g + 0.114478 * b);
      dst.set(i, j, color(f));
    }
  }
}