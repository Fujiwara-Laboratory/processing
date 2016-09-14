float cx, cy, px, py;


void setup(){
  size(600, 500);
  textSize(20);
  cx = 300;
  cy = 300;
}

void draw(){
  background(255);
  float betD, betA, th;
  px = mouseX;
  py = mouseY;
  
  noFill();
  stroke(0);
  ellipse(cx, cy, 11, 11);
  stroke(255, 0, 0);
  ellipse(px, py, 11, 11);
  
  // 中心位置と任意の座標から距離と角度(右を0度で時計回り)を計算
  betD = dist(cx, cy, px, py);
  th = atan2(py - cy, px - cx);
  if(th < 0) th += 2 * PI; // そのままではマイナスゾーンがあるので0 - 360にする
  betA = degrees(th);
  
  fill(0);
  text(betD, 10, 30);
  text(betA, 10, 60);
}