// kinect用ライブラリ
import kinect4WinSDK.*;

// RGBDカメラ用変数
Kinect kinect;
ArrayList <SkeletonData> bodies;

// 縦横サイズと処理をしない範囲
int w, h, ew = 30;

// 最も近い点の座標, 1フレーム前の点、XY平面上の距離の閾値、円の描画位置
int cX, cY, pX = 320, pY = 240, distTh = 100, dX, dY;

// 処理用の画像
PImage img;

void setup(){
  size(640, 480);
  
  // RGBDカメラ関係の初期化
  kinect = new Kinect(this);
  
  bodies = new ArrayList<SkeletonData>();
  
  w = 640;
  h = 480;
  
  fill(255, 0, 0);
}

void draw(){
  int i, j, d, cV = 0;
  
  // カラー画像
  image(kinect.GetImage(), 0, 0);
  
  // 距離値の分布をPImageにコピー
  img = kinect.GetDepth();
  
  // 端は処理をせずに最も距離の小さい(値が入っている)座標を探す
  for(j = ew; j < h - ew; j++){
    for(i = ew; i < w - ew; i++){
      d = img.pixels[i + j * width] & 0xFF;
      if(d > cV){
        cV = d;
        cX = i;
        cY = j;
      }
    }
  } // 全体をなめた後にi, jへ最近点の座標が、cVへその距離が代入されている
  
  // 本来は上記のサーチ範囲を以下の閾値を元に限定すべき(その方がよりコスト減)
  if(abs(pX - cX) > distTh || abs(pY - cY) > distTh){
    // 前フレームから離れすぎていたら前フレームの値を採用
    cX = pX;
    cY = pY;
  }
  
  // 最もカメラに近い点の描画
  ellipse(cX, cY, 32, 32);
  pX = cX;
  pY = cY;
}