// kinect用ライブラリ
import SimpleOpenNI.*;

// RGBDカメラ用変数
SimpleOpenNI kinect;
int w, h, ew = 30; // 縦横サイズと処理をしない範囲

// 最も近い点の座標, 1フレーム前の点、XY平面上の距離の閾値、円の描画位置
int cX, cY, pX = 320, pY = 240, distTh = 100, dX, dY;

void setup(){
  size(640, 480);
  
  // RGBDカメラ関係の初期化
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();
  kinect.setMirror(true); // 鏡写し(falseで無効)
  kinect.alternativeViewPointDepthToImage(); // 位置の微調整
  
  w = kinect.depthWidth();
  h = kinect.depthHeight();
  
  fill(255, 0, 0);
}

void draw(){
  int i, j, d, cV = 8000;
  kinect.update();
  image(kinect.rgbImage(), 0, 0);
  
  // 距離値の分布をint型配列にコピー
  int data[] = kinect.depthMap();
  
  // 端は処理をせずに最も距離の小さい(値が入っている)座標を探す
  for(j = ew; j < h - ew; j++){
    for(i = ew; i < w - ew; i++){
      d = data[i + j * kinect.depthWidth()];
      if(d > 0 && d < cV){
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
