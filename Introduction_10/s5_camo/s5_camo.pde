// kinect V2用のライブラリ
import KinectPV2.*;

// RGBDカメラ用変数
KinectPV2 kinect;

// サイズ変更関連の変数
PImage rsImg;
float scaleRatio = 2.8, rsScale; // 何分の一にするか、画面表示のスケール変数
int w, h; // 変更後の画像サイズ

// 距離-RGBの変換関連の変数
float mapDCT[]; // マッピング用のテーブル
PImage dImg; // 距離画像をもとにしたマスク画像(背景領域が白)

// 背景画像用の変数
PImage bgImg, bufImg; // bufImgはきちんと深いコピーにするための仮置き変数
int startFrame = 70;

void setup(){
  rsScale = 1.0 / scaleRatio;
  w = (int)(1920 * rsScale);
  h = (int)(1080 * rsScale);
  surface.setSize(w, h);
  rsImg = createImage(w, h, RGB);
  
  // kinect関連の初期化
  kinect = new KinectPV2(this);
  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);
  kinect.enableDepthImg(true);
  kinect.enableDepthMaskImg(true);
  kinect.enablePointCloud(true);
  kinect.init();
  
  textSize(20);
}

void draw(){
  int i, j, u, v;
  float x, y;
  color c, wh = color(255);
  
  // 映像が取得できるまで一定フレーム待つ
  if(frameCount < startFrame){
    bufImg = kinect.getColorImage();
    bgImg = bufImg.get(); // 背景画像のメモリへの保存
    image(bgImg, 0, 0);
    text(frameCount , 50, 50);
    return;
  }
  
  // カラー画像の高速リサイズ
  imageResize(kinect.getColorImage(), rsImg, rsScale);
  
  mapDCT = kinect.getMapDepthToColor(); // 距離-RGBの変換テーブル
  dImg = kinect.getBodyTrackImage(); // マスク画像
  
  // 距離画像から得られるマスクををRGBの座標にマッピング
  rsImg.loadPixels();
  int count = 0;
  for(i = 0; i < KinectPV2.WIDTHDepth; i++){
    for(j = 0; j < KinectPV2.HEIGHTDepth; j++){
      // 変換テーブルから距離画像における座標がRGBのどこか(x, y)を取得する
      x = mapDCT[count * 2 + 0];
      y = mapDCT[count * 2 + 1];
      
      // (念のため)すみを省いて処理をする
      if(20 < x && x < 1900 && 20 < y && y < 1060){
        // 白画素でない(人体領域)は予め取得しておいた背景を描画する
        if(dImg.pixels[i* KinectPV2.HEIGHTDepth + j] != wh){
          u = (int)(x * rsScale); // RGB座標の修正
          v = (int)(y * rsScale);
          rsImg.pixels[u + v * w] = bgImg.pixels[(int)x + (int)y * 1920]; 
        }
      }

      count++;
    }
  }
  rsImg.updatePixels();
  
  image(rsImg, 0, 0);

  fill(255, 0, 0);
  text(frameRate , 50, 50);
}

// 画像のリサイズ (簡易版の縮小用)
void imageResize(PImage src, PImage dst, float s){
  int i, j, u, v;
  float rate = 1 / s;
  int w_s = (int)(src.width * s), h_s = (int)(src.height * s);
  if(s == 1){
    dst = src.get();
    return;
  }
  dst.loadPixels();
  for(j = 0; j < h_s; j++){
    for(i = 0; i < w_s; i++){
      u = (int)(i * rate + s);
      v = (int)(j * rate + s) * src.width;
      dst.pixels[i + j * w_s] = src.pixels[u + v];
    }
  }
  dst.updatePixels();
}
