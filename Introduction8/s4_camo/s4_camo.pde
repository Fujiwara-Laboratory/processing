// kinect用ライブラリ
import kinect4WinSDK.*;

// RGBDカメラ用変数
Kinect kinect;
ArrayList <SkeletonData> bodies;
PImage bgImg = null, mskImg;
color blk = color(0, 0, 0);

void setup() {
  size(640, 480);

  // RGBDカメラ関係の初期化
  kinect = new Kinect(this);
  
  bodies = new ArrayList<SkeletonData>();
}

void draw() {
  int i, j;
  // 最初のフレームを背景画像として保存しておく
  if(frameCount > 2) bgImg = kinect.GetImage();
  if(bgImg == null) return;
  image(kinect.GetImage(), 0, 0);
  
  if(bodies.size () > 0){ // ユーザの認識ができている場合
  
    // ユーザ毎の塗り情報を取得
    mskImg = kinect.GetMask();
    loadPixels();
    for(j = 0; j < 480; j++){
      for(i = 0; i < 640; i++){
        int alp = (mskImg.pixels[i + j * width] >> 24) & 0xFF;
        if(alp == 255){ // アルファ値が255は人体領域
          // ユーザ領域(人が描画されているところ)を背景画像に置き換え(ウィンドウに直接書き込む)
          pixels[i + j * width] = bgImg.pixels[i + j * width];
        }
      }
    }
    updatePixels();
  }
}


void appearEvent(SkeletonData _s){
  if (_s.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED){
    return;
  }
  synchronized(bodies){
    bodies.add(_s);
  }
}

void disappearEvent(SkeletonData _s){
  synchronized(bodies){
    for(int i = bodies.size() - 1; i >= 0; i--){
      if(_s.dwTrackingID == bodies.get(i).dwTrackingID){
        bodies.remove(i);
      }
    }
  }
}

void moveEvent(SkeletonData _b, SkeletonData _a){
  if(_a.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED){
    return;
  }
  synchronized(bodies){
    for(int i=bodies.size() - 1; i >= 0; i--){
      if(_b.dwTrackingID == bodies.get(i).dwTrackingID){
        bodies.get(i).copy(_a);
        break;
      }
    }
  }
}