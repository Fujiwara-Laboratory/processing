// kinect用ライブラリ
import SimpleOpenNI.*;

// RGBDカメラ用変数
SimpleOpenNI kinect;

// ボタンの押下の状態
boolean onBtn = false; 

// ボタンの座標(左上と右下)
int btnLX = 30, btnLY = 100, btnRX = 300, btnRY = 200;

void setup(){
  size(640,480);
  
  // RGBDカメラ関係の初期化
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();
  kinect.setMirror(true); // 鏡写し(falseで無効)
  kinect.alternativeViewPointDepthToImage(); // 位置の微調整
  kinect.enableUser(); // 姿勢推定を有効にする
  
  strokeWeight(5);
  
  // テキスト用の初期化(日本語を使うためフォントも指定する)
  textAlign(CENTER, CENTER);
  textFont(createFont("MSゴシック", 40));
}

void draw(){
  kinect.update();
  image(kinect.rgbImage(), 0, 0);
  
  // フラグを毎フレーム初期化(このタイミングでしないとスケルトンロスト等の対処が複雑になる)
  onBtn = false;
  
  // 検出したユーザ毎に処理
  int[] userList = kinect.getUsers();
  for(int i=0;i<userList.length;i++){
    if(kinect.isTrackingSkeleton(userList[i])){
      // 両手と頭の位置
      PVector handR3D = new PVector();
      PVector handR2D = new PVector();
      PVector handL3D = new PVector();
      PVector handL2D = new PVector();
      
      kinect.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_HAND, handR3D);
      kinect.convertRealWorldToProjective(handR3D, handR2D);
      kinect.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_HAND, handL3D);
      kinect.convertRealWorldToProjective(handL3D, handL2D);
      
      // 念のため手の座標を描画(荒ぶるので無い方が見栄えはよい)
      fill(255, 215, 0);
      ellipse(handR2D.x, handR2D.y, 50, 50);
      fill(128, 128, 0);
      ellipse(handL2D.x, handL2D.y, 50, 50);
      
      // 手座標がボタンの範囲に入っているかを判定
      if(handR2D.x > btnLX && handR2D.x < btnRX && handR2D.y > btnLY && handR2D.y < btnRY &&
         handL2D.x > btnLX && handL2D.x < btnRX && handL2D.y > btnLY && handL2D.y < btnRY){
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

void onNewUser(SimpleOpenNI curkinect, int userId){
  curkinect.startTrackingSkeleton(userId);
}
