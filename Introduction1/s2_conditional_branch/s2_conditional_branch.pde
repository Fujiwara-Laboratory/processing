void setup(){
  size(800, 300); // ウィンドウサイズ
  textSize(300); // フォントサイズ
  textAlign(RIGHT); // テキストのレイアウト
}

void draw(){
  background(0); // 背景のクリア
  if(frameCount % 10 == 0) fill(255);
  else fill(100, 255, 255);
  text(frameCount, 800, 260);
}
