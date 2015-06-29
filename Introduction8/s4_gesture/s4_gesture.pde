// kinect用ライブラリ
import SimpleOpenNI.*;

// RGBDカメラ用変数
SimpleOpenNI kinect;

PVector p = new PVector(); // 検出された点
int gesCount[] = new int[3];

void setup(){
  size(640, 480);

  // RGBDカメラ関係の初期化
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();
  kinect.setMirror(true); // 鏡写し(falseで無効)
  kinect.alternativeViewPointDepthToImage(); // 位置の微調整
  kinect.enableUser(); // 姿勢推定を有効にする
  
  // 手ジェスチャー用の有効化
  kinect.enableHand();
  kinect.startGesture(SimpleOpenNI.GESTURE_WAVE);
  kinect.startGesture(SimpleOpenNI.GESTURE_HAND_RAISE);
  kinect.startGesture(SimpleOpenNI.GESTURE_CLICK);
  
  println(SimpleOpenNI.GESTURE_WAVE);
  println(SimpleOpenNI.GESTURE_CLICK);
  println(SimpleOpenNI.GESTURE_HAND_RAISE);
  
  strokeWeight(3);
  for(int i = 0; i < 3; i++) gesCount[i] = 0;
  
  // テキスト用の初期化(日本語を使うためフォントも指定する)
  textFont(createFont("MSゴシック", 30));
}

void draw(){
  PVector p2d = new PVector();
  
  kinect.update();
  image(kinect.rgbImage(),0,0);
  
  if(p != null){ // IDが割り当てられている点を描画
    kinect.convertRealWorldToProjective(p, p2d);
    stroke(255, 0, 0);
    noFill();
    ellipse(p2d.x, p2d.y, 30, 30);
  }
  
  stroke(0);
  fill(255);
  rect(5, 5, 200, 110);
  
  fill(0);
  text("手振り: " + gesCount[0], 20, 35);
  text("手前後: " + gesCount[1], 20, 70);
  text("手上げ: " + gesCount[2], 20, 105);
}

// 検出後呼び続ける関数
void onTrackedHand(SimpleOpenNI curkinect, int handId, PVector pos){
  p = pos;
}

// 手をロストした場合
void onLostHand(SimpleOpenNI curkinect,int handId){
  p = null;
}

// ジェスチャーを検出した座標を保存している関数なので基本的に変更しない(消すのもだめ)
void onCompletedGesture(SimpleOpenNI curkinect, int gestureType, PVector pos){
  curkinect.startTrackingHand(pos);
  gesCount[gestureType]++;
}
