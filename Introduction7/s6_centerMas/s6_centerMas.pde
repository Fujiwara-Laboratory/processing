// kinect用ライブラリ
import kinect4WinSDK.*;

// RGBDカメラ用変数
Kinect kinect;
ArrayList <SkeletonData> bodies;

void setup(){
  size(640, 480);
  
  // RGBDカメラ関係の初期化
  kinect = new Kinect(this);
  
  bodies = new ArrayList<SkeletonData>();
  
  strokeWeight(5);
  fill(255, 0, 0);
  textSize(30); // 文字サイズの設定
}

void draw(){
  int i;
  int x, y;

  // 背景にカラー画像の表示
  image(kinect.GetImage(), 0, 0);
  
  // 検出したユーザ毎に重心の描画
  for (i = 0; i < bodies.size (); i++){
    x = (int)(bodies.get(i).position.x * width);
    y = (int)(bodies.get(i).position.y * height);
  
    ellipse(x, y, 30, 30);
    text(x +"," + y, x + 10, y - 10);
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