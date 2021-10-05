// Capture(this, 横幅, 縦幅, カメラ名, フレームレート);でもよい
// カメラ名はコンソール一覧で確認する

// videoライブラリの読み込み(キャプチャに利用)
import processing.video.*;
// カメラ用の変数
Capture cam;
int cw, ch; // カメラの横幅・縦幅

void setup() {
  // 画面サイズは結果に合わせて後のプログラムで考える (とりあえず以下は適当な大きさ)
  size(640, 480);
  String[] cameras = Capture.list();
  printArray(cameras);

  // セッティングで利用したい数値をcamerasの要素へ指定する
  cam = new Capture(this, cameras[0]);
  
  // カメラの名前で指定する実装もあるがそこまで必要性はないかも
  //cam = new Capture(this, 横幅, 縦幅, "カメラ名");
  
  // カメラの取り込み開始
  cam.start();
  while(cw == 0 && ch == 0){
    if(cam.available()){
      cam.read();
      cw = cam.width;
      ch = cam.height;
      println(cw + ", " + ch);
    }
  }
  
}

void draw() {
  if(cam.available()) cam.read();
  // 縦や横に伸びて見える場合は、対応する4:3等へ変更する
  // 以下のように表示だけであれば狭めるのみでも可 (変更しない場合は4、5引数が必要ない)
  image(cam, 0, 0);
}
