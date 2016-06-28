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
}

void draw(){
  int i, partsNum;
  float headx, heady, handRx, handRy, handLx, handLy;
  
  // 背景にカラー画像の表示
  image(kinect.GetImage(), 0, 0);
  
  // 検出したユーザ毎に処理
  for (i = 0; i < bodies.size (); i++){
    // 頭の描画
    partsNum = Kinect.NUI_SKELETON_POSITION_HEAD;
    if(bodies.get(i).skeletonPositionTrackingState[partsNum] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED){
      headx = bodies.get(i).skeletonPositions[partsNum].x * width;
      heady = bodies.get(i).skeletonPositions[partsNum].y * height;
      
      fill(255, 215, 0);
      ellipse(headx, heady, 50, 50);
    }
    
    // 右手の描画
    partsNum = Kinect.NUI_SKELETON_POSITION_HAND_RIGHT;
    if(bodies.get(i).skeletonPositionTrackingState[partsNum] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED){
      handRx = bodies.get(i).skeletonPositions[partsNum].x * width;
      handRy = bodies.get(i).skeletonPositions[partsNum].y * height;
      
      fill(128, 128, 0);
      ellipse(handRx, handRy, 50, 50);
    }
    
    // 左手の描画
    partsNum = Kinect.NUI_SKELETON_POSITION_HAND_LEFT;
    if(bodies.get(i).skeletonPositionTrackingState[partsNum] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED){
      handLx = bodies.get(i).skeletonPositions[partsNum].x * width;
      handLy = bodies.get(i).skeletonPositions[partsNum].y * height;
      
      fill(247, 171, 166);
      ellipse(handLx, handLy, 50, 50);
    }
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