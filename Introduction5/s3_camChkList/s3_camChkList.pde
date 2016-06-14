// Capture(this, 横幅, 縦幅, カメラ名, フレームレート);でもよい
// カメラ名はコンソール一覧で確認する

// videoライブラリの読み込み(キャプチャに利用)
import processing.video.*;
// カメラ用の変数
Capture cam;

void setup() {
  // 画面サイズはリストにあわせて考える (とりあえず以下は適当な大きさ)
  size(720, 540);
  String[] cameras = Capture.list();
  
  // とりあえず、一度起動してコンソールのセッティング一覧を確認する
  if (cameras.length == 0) exit();
  else for (int i = 0; i < cameras.length; i++) println(i + ": " + cameras[i]);

  // セッティングで利用したい数値をcamerasの要素へ指定する
  cam = new Capture(this, cameras[0]);
  
  // カメラの名前で指定する場合
  //cam = new Capture(this, 横幅, 縦幅, "カメラ名", フレームレート);
  
  cam.start();
}

void draw() {
  if(cam.available() == true) cam.read();
  // 縦や横に伸びて見える場合は、対応する4:3等へ変更する
  // 以下のように表示だけであれば狭めるのみでも可 (変更しない場合は4、5引数が必要ない)
  image(cam, 0, 0);
}