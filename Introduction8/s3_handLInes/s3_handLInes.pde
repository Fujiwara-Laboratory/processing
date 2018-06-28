// kinect V2用のライブラリ
import KinectPV2.*;

// RGBDカメラ用変数
KinectPV2 kinect;
ArrayList<KSkeleton> skeletonArray;

// サイズ変更関連の変数
PImage rsImg;
float rsScale = 0.5; // 画面表示のスケール変数
int w, h; // 変更後の画像サイズ

// 線描画関連の変数
int maxPointsNUM = 200; // 線が描ける(ストックしておく)フレーム数
ArrayList<PVector> hrLOG, hlLOG;
int pointCount = 0; // 取得したフレーム数

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
  hrLOG = new ArrayList<PVector>();
  hlLOG = new ArrayList<PVector>();
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
  
  // 軌跡の表示 (取得したフレーム数だけを描画する)
  if(pointCount > 0){
    for(i = 1; i < pointCount; i++){
      stroke(255, 0, 0);
      line(hrLOG.get(i - 1).x, hrLOG.get(i - 1).y, hrLOG.get(i).x, hrLOG.get(i).y);
      stroke(0, 255, 0);
      line(hlLOG.get(i - 1).x, hlLOG.get(i - 1).y, hlLOG.get(i).x, hlLOG.get(i).y);
    }
  }
  
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
      
      // それぞれのログの末尾に追加
      hrLOG.add(hr);
      hlLOG.add(hl);
      
      if(pointCount < maxPointsNUM){
        pointCount++; // 最大フレーム数にたどり着くまではカウントを増やす
      }else{
        // 最大フレーム数になったら、最初(最も古い情報)の項目を削除
        hrLOG.remove(0);
        hlLOG.remove(0);
      }
      
      noFill();
      stroke(255, 0, 0);
      ellipse(hr.x, hr.y, 50, 50);
      
      stroke(0, 255, 0);
      ellipse(hl.x, hl.y, 50, 50);
    }
  }
  
  fill(255, 0, 0);
  text(frameRate, 20, 40);
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
