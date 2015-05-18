void setup(){
  size(800, 300);
  textSize(300);
  textAlign(RIGHT);
}

void draw(){
  background(0);
  if(frameCount % 20 == 0) text(frameCount, 800, 260);
}
