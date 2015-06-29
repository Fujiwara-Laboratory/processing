// kinect用ライブラリ
import SimpleOpenNI.*;

// RGBDカメラ用変数
SimpleOpenNI kinect;
int[] userMap;
PImage bgImg = null;

void setup() {
  size(640, 480);

  // RGBDカメラ関係の初期化
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();
  kinect.setMirror(true); // 鏡写し(falseで無効)
  kinect.alternativeViewPointDepthToImage(); // 位置の微調整
  kinect.enableUser(); // 姿勢推定を有効にする
  
  // 最初のフレームを背景画像として保存しておく
  kinect.update();
  bgImg = kinect.rgbImage().get();
}

void draw() {
  kinect.update();
  image(kinect.rgbImage(), 0, 0);
  
  if(kinect.getNumberOfUsers() > 0){ // ユーザの認識ができている場合
  
    // ユーザ毎の塗り情報を取得
    userMap = kinect.userMap();
    loadPixels();
    for(int i = 0; i < userMap.length; i++){
      if(userMap[i] != 0){ // 0は背景
        // ユーザ領域(人が描画されているところ)を背景画像に置き換え(ウィンドウに直接書き込む)
        pixels[i] = bgImg.pixels[i];
      }
    }
    updatePixels();
  }
}
