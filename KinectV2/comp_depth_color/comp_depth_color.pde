// kinect V2用のライブラリ
import KinectPV2.*;

// RGBDカメラ用変数
KinectPV2 kinect;

// サイズ変更関連の変数
PImage rsImg;
float scaleRatio = 4, rsScale; // 何分の一にするか、画面表示のスケール変数
int w, h; // 変更後の画像サイズ

// 距離画像用
float dX, dY, dW, dH;

void setup(){
  // スケールに合わせた画面サイズ
  rsScale = 1.0 / scaleRatio;
  w = (int)(1920 * rsScale);
  h = (int)(1080 * rsScale);
  
  float offsetD = 2.3;
  dW = 512 * rsScale * offsetD;
  dH = 424 * rsScale * offsetD;
  dX = (w - dW) / 2;
  dY = (h - dH) / 2;
  
  surface.setSize(w, h + (int)dH);
  rsImg = createImage(w, h, RGB);
  
  // kinect関連の初期化
  kinect = new KinectPV2(this);
  kinect.enableColorImg(true);
  kinect.enableDepthImg(true);
  kinect.enableDepthMaskImg(true);
  kinect.enablePointCloud(true);
  kinect.init();
  
}

void draw(){
  background(0);
  image(kinect.getDepthImage(), dX, dY, dW, dH); // 距離画像(512x424)の貼り付け
  
  // カラー画像の高速リサイズ
  imageResize(kinect.getColorImage(), rsImg, rsScale);
  image(rsImg, 0, h);

  fill(255, 0, 0);
  text(frameRate , 50, 50);
}

// 画像の高速リサイズ (簡易版の縮小用)
void imageResize(PImage src, PImage dst, float s){
  int i, j, u, v;
  if(s == 1){
    dst = src.get();
    return;
  }
  float rate = 1 / s;
  dst.loadPixels();
  for(j = 0; j < h; j++){
    for(i = 0; i < w; i++){
      u = (int)(i * rate + s);
      v = (int)(j * rate + s) * src.width;
      dst.pixels[i + j * w] = src.pixels[u + v];
    }
  }
  dst.updatePixels();
}
