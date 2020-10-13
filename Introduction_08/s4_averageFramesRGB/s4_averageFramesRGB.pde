// videoライブラリの読み込み(キャプチャに利用)
import processing.video.*;
// カメラ用の変数
Capture cam;
int w = 640, h = 480;

// 画像の時間平均用の変数
int sampleFrames = 30;
PImage srcImg = null, aveImg = null;
int bufImagesR[][] = new int[sampleFrames][w * h];
int bufImagesG[][] = new int[sampleFrames][w * h];
int bufImagesB[][] = new int[sampleFrames][w * h];
int bufR[] = new int[w * h], bufG[] = new int[w * h], bufB[] = new int[w * h];
int count = 0;

void setup(){
  // サイズを決めて初期化
  cam = new Capture(this, w, h, 30);
  
  // 取り込み開始
  cam.start();
  
  // 出力用メモリの準備
  aveImg = new PImage(w, h);
  
  for(int i = 0; i < w * h; i++) bufR[i] =  bufG[i] =  bufB[i] = 0;
  
  // 画像の配置を考慮したウィンドウサイズ
  surface.setSize(w * 2, h);
  
  // text用のフォント設定
  fill(255, 0, 0);
  textSize(20);
}

void draw(){
  int i, j, selFrame = count % sampleFrames;
  // カメラが取り込める状態(動いている場合)はメモリに
  if(cam.available()) cam.read();
  
  // 取り込んだフレームをコピー
  srcImg = cam;
  
  // 入力画像
  image(srcImg, 0, 0);
  
  if(count > sampleFrames){ // Nフレーム以上になったので、消えるフレームをマイナス
    for(j = 0; j < h; j++){
      for(i = 0; i < w; i++){
        bufR[i + j * w ] -= bufImagesR[selFrame][i + j * w];
        bufG[i + j * w ] -= bufImagesG[selFrame][i + j * w];
        bufB[i + j * w ] -= bufImagesB[selFrame][i + j * w];
      }
    }
  }
  
  // 各ピクセルをグレースケールにして保存用の配列にコピー
  for(j = 0; j < h; j++){
    for(i = 0; i < w; i++){
      bufImagesR[selFrame][i + j * w] = srcImg.pixels[i + j * w] >> 16 & 0xFF;
      bufImagesG[selFrame][i + j * w] = srcImg.pixels[i + j * w] >> 8 & 0xFF;
      bufImagesB[selFrame][i + j * w] = srcImg.pixels[i + j * w] & 0xFF;
    }
  }
  
  for(j = 0; j < h; j++){
    for(i = 0; i < w; i++){
      bufR[i + j * w] += bufImagesR[selFrame][i + j * w];
      bufG[i + j * w] += bufImagesG[selFrame][i + j * w];
      bufB[i + j * w] += bufImagesB[selFrame][i + j * w];
    }
  }
  
  if(count > sampleFrames){
    // ため込んだフレーム数で合計値を割ることで平均を得る
    aveImg.loadPixels();
    for(j = 0; j < h; j++){
      for(i = 0; i < w; i++){
        aveImg.pixels[i + j * w ] = color(bufR[i + j * w] / sampleFrames, bufG[i + j * w] / sampleFrames, bufB[i + j * w] / sampleFrames);
      }
    }
    aveImg.updatePixels();
    
    // Nフレームの時間平均画像の表示
    image(aveImg, w, 0);
  }
  
  count++;
  text(frameRate, 10, 30);
}