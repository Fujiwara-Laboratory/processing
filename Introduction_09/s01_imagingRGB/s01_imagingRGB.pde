// kinect V2用のライブラリ
import KinectPV2.*;

// RGBDカメラ用
KinectPV2 kinect;

// サイズ変更関連の変数
PImage rsImg;
float rsScale = 0.5; // 画面表示のスケール変数
int w, h; // 変更する画像サイズ

void setup(){
  // スケールに合わせた画面サイズ
  w = (int)(1920 * rsScale);
  h = (int)(1080 * rsScale);
  surface.setSize(w, h);
  rsImg = createImage(w, h, RGB);
  
  // kinect関連の初期化
  kinect = new KinectPV2(this);
  kinect.enableColorImg(true);
  kinect.init();

  // 文字の設定
  textSize(24);
  fill(255, 0, 0);
}

void draw(){
  // カラー画像のリサイズ
  imageResize(kinect.getColorImage(), rsImg, rsScale);
  
  // カラー画像の表示
  image(rsImg, 0, 0);
  
  text(frameRate, 20, 40);
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
