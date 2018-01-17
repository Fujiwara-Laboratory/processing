float cx, cy, px, py;

void setup(){
  size(900, 700);
  textSize(24);
  cx = width / 2;
  cy = height / 2;
  textFont(createFont("Osaka", 32));
}

void draw(){
  background(255);
  float betD, betA, th;
  px = mouseX;
  py = mouseY;
  
  fill(0);
  stroke(0);
  strokeWeight(1);
  ellipse(cx, cy, 21, 21);
  noFill();
  stroke(255, 0, 0);
  strokeWeight(3);
  ellipse(px, py, 11, 11);
  
  // 中心位置と任意の座標から距離と角度(右を0度で時計回り)を計算
  betD = dist(cx, cy, px, py);
  th = atan2(py - cy, px - cx);
  if(th < 0) th += 2 * PI; // そのままではマイナスゾーンがあるので0 - 360にする
  betA = degrees(th);
  
  fill(0);
  text("距離: " + int(betD), 10, 30);
  text("角度: " + int(betA), 10, 64);
}