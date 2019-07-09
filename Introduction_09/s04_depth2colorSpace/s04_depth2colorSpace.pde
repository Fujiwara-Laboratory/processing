// kinect V2用のライブラリ
import KinectPV2.*;

// RGBDカメラ用変数
KinectPV2 kinect;

// サイズ変更関連の変数
PImage rsImg;
float scaleRatio = 2, rsScale; // 何分の一にするか、画面表示のスケール変数
int w, h; // 変更後の画像サイズ

// 距離-RGBの変換関連の変数
float mapDCT[]; // マッピング用のテーブル
PImage d2cImg, clearImg; // 出力結果、バッファクリア用の画像

void setup(){
  int i, j;
  
  // スケールに合わせた画面サイズ
  rsScale = 1.0 / scaleRatio;
  w = (int)(1920 * rsScale);
  h = (int)(1080 * rsScale);
  surface.setSize(w, h * 2);
  rsImg = createImage(w, h, RGB);
  
  // kinect関連の初期化
  kinect = new KinectPV2(this);
  kinect.enableColorImg(true);
  kinect.enableDepthImg(true);
  kinect.enableDepthMaskImg(true);
  kinect.enablePointCloud(true);
  kinect.init();
  
  // RGB画像と同じ座標系における距離値
  d2cImg = createImage(w, h, PImage.RGB);
  
  // バッファクリア用の画像の準備
  clearImg = createImage(w, h, PImage.RGB);
  clearImg.loadPixels();
  for(j = 0; j < h; j++) for(i = 0; i < w; i++) clearImg.pixels[i + j * w] = 0;
  clearImg.updatePixels();
  
}

void draw(){
  // 距離画像(512x424)からRGB画像座標系へ
  d2cImg = clearImg.get();
  depth2RGBsp(kinect.getDepthImage(), d2cImg, mapDCT);
  image(d2cImg, 0, 0); // 距離画像の貼り付け
  
  // カラー画像の高速リサイズ
  imageResize(kinect.getColorImage(), rsImg, rsScale);
  image(rsImg, 0, h);

  fill(255, 0, 0);
  text(frameRate , 50, 50);
}

// RGB画像の座標系に変換した距離値取得
void depth2RGBsp(PImage src, PImage dst, float tbl[]){
  int i, j, u, v;
  float x, y;
  
  tbl = kinect.getMapDepthToColor(); // 距離-RGBの変換テーブル取得
  
  // 距離値をRGB画像の座標系にマッピング
  dst.loadPixels();
  int count = 0;
  for(i = 0; i < KinectPV2.WIDTHDepth; i++){
    for(j = 0; j < KinectPV2.HEIGHTDepth; j++){
      // 変換テーブルから距離画像における座標がRGBのどこか(x, y)を取得する
      x = tbl[count * 2 + 0];
      y = tbl[count * 2 + 1];
      
      // (念のため)すみを省いて処理をする
      if(20 < x && x < 1900 && 20 < y && y < 1060){
        u = (int)(x * rsScale);
        v = (int)(y * rsScale);
        
        // 距離画像の座標系(i, j)上の距離値をRGB画像の座標系(x, y)上にコピーする
        dst.pixels[u + v * w] = src.pixels[i* KinectPV2.HEIGHTDepth + j];
      }

      count++; // テーブルの座標を進める
    }
  }
  dst.updatePixels();
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
