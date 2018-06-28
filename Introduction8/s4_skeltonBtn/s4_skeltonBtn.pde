// kinect V2用のライブラリ
import KinectPV2.*;

// RGBDカメラ用変数
KinectPV2 kinect;
ArrayList<KSkeleton> skeletonArray;

// サイズ変更関連の変数
PImage rsImg;
float rsScale = 0.5; // 画面表示のスケール変数
int w, h; // 変更後の画像サイズ

// ボタンの押下の状態
boolean onBtn;

// ボタンの座標(左上と右下)
int btnLX = 30, btnLY = 100, btnRX = 300, btnRY = 200;

void setup(){
  // スケールに合わせた画面サイズ
  w = (int)(1920 * rsScale);
  h = (int)(1080 * rsScale);
  surface.setSize(w, h);
  rsImg = createImage(w, h, RGB);
  
  // kinect関連の初期化
  kinect = new KinectPV2(this);
  kinect.enableColorImg(true);
  kinect.enableSkeletonColorMap(true);
  kinect.init();
  
  // テキスト用の初期化(日本語を使うためフォントも指定する)
  textAlign(CENTER, CENTER);
  textFont(createFont("MSゴシック", 40));
  
  strokeWeight(5);
}

void draw(){
  int i;
  // 個別の部品 (右手、左手)
  PVector hr = new PVector(), hl = new PVector();
  // カラー画像の高速リサイズ
  imageResize(kinect.getColorImage(), rsImg, rsScale);
  
  // カラー画像の表示
  image(rsImg, 0, 0);
  
  
  // スケルトン情報の取得
  skeletonArray =  kinect.getSkeletonColorMap();
  
  // 一人のみでの動作を前提とする
  if(skeletonArray.size() == 1){
    // n人目のスケルトン情報を skeleton へ
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(0);
    
    // skeleton が使えるならば
    if(skeleton.isTracked()){
      // 関節の集合となる配列に変換
      KJoint[] joints = skeleton.getJoints();

      // 両手の座標を取得
      hr.x = joints[KinectPV2.JointType_HandRight].getX() * rsScale;
      hr.y = joints[KinectPV2.JointType_HandRight].getY() * rsScale;
      hl.x = joints[KinectPV2.JointType_HandLeft].getX() * rsScale;
      hl.y = joints[KinectPV2.JointType_HandLeft].getY() * rsScale;
      
      // 念のため手の座標を描画
      noFill();
      stroke(255, 0, 0);
      ellipse(hr.x, hr.y, 50, 50);
      
      stroke(0, 255, 0);
      ellipse(hl.x, hl.y, 50, 50);
      
      
      // 手座標がボタンの範囲に入っているかを判定
      if(hr.x > btnLX && hr.x < btnRX && hr.y > btnLY && hr.y < btnRY &&
         hl.x > btnLX && hl.x < btnRX && hl.y > btnLY && hl.y < btnRY){
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

// 画像の高速リサイズ (簡易版の縮小用)
void imageResize(PImage src, PImage dst, float s){
  int i, j, u, v;
  float rate = 1 / s;
  if(s == 1){
    dst = src.get();
    return;
  }
  dst.loadPixels();
  for(j = 0; j < h; j++){
    for(i = 0; i < w; i++){
      u = (int)(i * rate + s);
      v = (int)(j * rate + s) * src.width;
      dst.pixels[i + j * w] = src.pixels[u + v];
    }
  }
  dst.updatePixels();
}
