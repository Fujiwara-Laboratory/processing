// kinect用ライブラリ
import kinect4WinSDK.*;

// RGBDカメラ用変数
Kinect kinect;
ArrayList <SkeletonData> bodies;

// ボタンの押下の状態
boolean onBtn;

// ボタンの座標(左上と右下)
int btnLX = 30, btnLY = 100, btnRX = 300, btnRY = 200;

void setup(){
  size(640,480);
  
  // RGBDカメラ関係の初期化
  kinect = new Kinect(this);
  
  bodies = new ArrayList<SkeletonData>();
  
  strokeWeight(5);
  
  // テキスト用の初期化(日本語を使うためフォントも指定する)
  textAlign(CENTER, CENTER);
  textFont(createFont("MSゴシック", 40));
}

void draw(){
  int i;
  float rx, ry, lx, ly;
  image(kinect.GetImage(), 0, 0);
  
  // フラグを毎フレーム初期化(このタイミングでしないとスケルトンロスト等の対処が複雑になる)
  onBtn = false;
  
  // 検出したユーザ毎に処理
  for (i = 0; i < bodies.size (); i++){
    if((bodies.get(i).skeletonPositionTrackingState[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT] !=
      Kinect.NUI_SKELETON_POSITION_NOT_TRACKED)
      &&
      (bodies.get(i).skeletonPositionTrackingState[Kinect.NUI_SKELETON_POSITION_HAND_LEFT] != 
      Kinect.NUI_SKELETON_POSITION_NOT_TRACKED)){
      rx = bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].x * width;
      ry = bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].y * height;
      lx = bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_LEFT].x * width;
      ly = bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_LEFT].y * height;
      
      // 念のため手の座標を描画(荒ぶるので無い方が見栄えはよい)
      fill(255, 215, 0);
      ellipse(rx, ry, 50, 50);
      fill(128, 128, 0);
      ellipse(lx, ly, 50, 50);
      
      // 手座標がボタンの範囲に入っているかを判定
      if(rx > btnLX && rx < btnRX && ry > btnLY && ry < btnRY &&
         lx > btnLX && lx < btnRX && ly > btnLY && ly < btnRY){
        onBtn = true;
      }else{
        onBtn = false;
      }
    }
  }
  if(onBtn){
    // ボタンが押されているときの処理
    stroke(0);
    fill(255, 220);
    rect(btnLX, btnLY, btnRX - btnLX, btnRY - btnLY);
    fill(0);
    text("押されました", (btnRX + btnLX) / 2, (btnRY + btnLY) / 2);
  }else{
    // ボタンが押されていないときの処理
    noFill();
    stroke(255, 0, 0);
    rect(btnLX, btnLY, btnRX - btnLX, btnRY - btnLY);
    fill(255, 0, 0);
    text("押してね", (btnRX + btnLX) / 2, (btnRY + btnLY) / 2);
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