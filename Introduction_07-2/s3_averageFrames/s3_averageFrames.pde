// videoライブラリの読み込み(キャプチャに利用)
import processing.video.*;
// カメラ用の変数
Capture cam;
int w = 640, h = 480;

// 画像の時間平均用の変数
int sampleFrames = 100;
PImage srcImg = null, aveImg = null;
int bufImages[][] = new int[sampleFrames][], buf[] = new int[w * h];
int count = 0;

void setup(){
  // サイズを決めて初期化 
  cam = new Capture(this, w, h, 30);
  
  // 取り込み開始
  cam.start();
  
  // 出力用メモリの準備
  aveImg = new PImage(w, h);
  for(int i = 0; i < sampleFrames; i++) bufImages[i] = new int[w * h];
  
  // 画像の配置を考慮したウィンドウサイズ
  surface.setSize(w * 2, h);
  
  // text用のフォント設定
  fill(255, 0, 0);
  textSize(20);
}

void draw(){
  int i, j, n, selFrame = count % sampleFrames, r, g, b;
  // カメラが取り込める状態(動いている場合)はメモリに
  if(cam.available()) cam.read();
  
  // 取り込んだフレームをコピー
  srcImg = cam;
  
  // 入力画像
  image(srcImg, 0, 0);
  
  // 各ピクセルをグレースケールにして保存用の配列にコピー
  for(j = 0; j < h; j++){
    for(i = 0; i < w; i++){
      r = srcImg.pixels[i + j * w] >> 16 & 0xFF;
      g = srcImg.pixels[i + j * w] >> 8 & 0xFF;
      b = srcImg.pixels[i + j * w] & 0xFF;
      bufImages[selFrame][i + j * w] = (r * 77 + g * 151 + b * 28) / 256;
    }
  }
  
  if(count > sampleFrames){ // 必要なフレーム数に達したら開始
  
    // ため込んだフレーム数をループ
    for(n = 0; n < sampleFrames; n++){
      
      // ため込んだフレーム数から合計を計算
      for(j = 0; j < h; j++){
        for(i = 0; i < w; i++){
          // 1回目のループのみ代入(その後は加算することで初期化の代わりとする)
          if(n == 0) buf[i + j * w ] = bufImages[n][i + j * w];
          else buf[i + j * w ] += bufImages[n][i + j * w];
        }
      }
    }
    // ため込んだフレーム数で合計値を割ることで平均を得る
    aveImg.loadPixels();
    for(j = 0; j < h; j++){
      for(i = 0; i < w; i++){
        aveImg.pixels[i + j * w ] = color(buf[i + j * w] / sampleFrames);
      }
    }
    aveImg.updatePixels();
    
    // Nフレームの時間平均画像の表示
    image(aveImg, w, 0);
  }
  
  count++;
  text(frameRate, 10, 30);
}
