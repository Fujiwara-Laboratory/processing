void setup(){
  size(800, 300); // ウィンドウサイズ
  textSize(300); // フォントサイズ
  textAlign(RIGHT); // テキストのレイアウト
}

void draw(){
  background(0); // 背景のクリア
  text(frameCount, 800, 260);
}
