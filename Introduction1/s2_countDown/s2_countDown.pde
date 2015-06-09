void setup(){
  size(800, 300); // ウィンドウサイズ
  textSize(300); // フォントサイズ
  textAlign(RIGHT); // レイアウト
}

void draw(){
  background(0); // 背景のクリア
  text(10000 - frameCount, 800, 260);
}
