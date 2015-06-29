// kinect用ライブラリ
import SimpleOpenNI.*;

// RGBDカメラ用変数
SimpleOpenNI kinect;

int maxHandsNUM = 4; // 1人あたり2本の手用だが、ゆるくコーディングするために冗長化を図って4点まで対応させる
int id[] = new int[maxHandsNUM]; // 点0〜3に対応する手ID
PVector p[] = new PVector[maxHandsNUM]; // 検出された点
color[] userClr = new color[]{color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), color(255, 255, 0)};

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
  kinect.startGesture(SimpleOpenNI.GESTURE_HAND_RAISE);
  noFill();
  strokeWeight(3);
  
  for(int i = 0; i < maxHandsNUM; i++) id[i] = -1; // 手IDの初期化(1以上だけど念のためデータ無しは-1とする)
}

void draw(){
  PVector p2d = new PVector();
  
  kinect.update();
  image(kinect.rgbImage(),0,0);
  
  for(int i = 0; i < maxHandsNUM; i++){
    if(id[i] != -1){ // IDが割り当てられている点を描画
      kinect.convertRealWorldToProjective(p[i], p2d);
      stroke(userClr[i]);
      ellipse(p2d.x, p2d.y, 30, 30);
    }
  }
}

// 新たに手を発見した場合
void onNewHand(SimpleOpenNI curkinect, int handId, PVector pos){
  for(int i = 0; i < maxHandsNUM; i++){
    if(id[i] == -1){ // 空きスロットを探して手IDを代入
      id[i] = handId;
      p[i] = pos;
      break;
    }
  }
  println("handId: " + handId);
}

// 検出後呼び続ける関数
void onTrackedHand(SimpleOpenNI curkinect, int handId, PVector pos){
  for(int i = 0; i < maxHandsNUM; i++){
    if(id[i] == handId){ // IDと一致するスロットへ座標を代入
      p[i] = pos;
      break;
    }
  }
}

// 手をロストした場合
void onLostHand(SimpleOpenNI curkinect,int handId){
  for(int i = 0; i < maxHandsNUM; i++){
    if(id[i] == handId){ // 対応するIDをクリア(-1として割り当て無しに)する
      id[i] = -1;
      break;
    }
  }
}

// ジェスチャーを検出した座標を保存している関数なので基本的に変更しない(消すのもだめ)
void onCompletedGesture(SimpleOpenNI curkinect, int gestureType, PVector pos){
  curkinect.startTrackingHand(pos);
}
