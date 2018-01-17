import de.voidplus.leapmotion.*;

LeapMotion leap;
int lx, ly, rx, ry;

void setup(){
  size(600, 600);
  rectMode(CENTER);
  leap = new LeapMotion(this);
  lx = 100;
  rx = 500;
  ly = ry = height / 2;
  textSize(28);
}

void draw(){
  background(255);
  PVector p;
  
  // 指の本数格納用変数
  int lnumF, rnumF;
  lnumF = rnumF = -1;
  
  for(Hand hand : leap.getHands()){
    if(hand.isLeft()){
      p = hand.getFinger(1).getBone(0).getPrevJoint();
      lx = (int)p.x;
      ly = (int)p.y;
      
      // 左手の伸ばした指の本数
      ArrayList<Finger> f = hand.getOutstretchedFingers();
      lnumF = f.size();
    }
    if(hand.isRight()){
      p = hand.getFinger(1).getBone(0).getPrevJoint();
      rx = (int)p.x;
      ry = (int)p.y;
      
      // 右手の伸ばした指の本数
      ArrayList<Finger> f = hand.getOutstretchedFingers();
      rnumF = f.size();
    }
  }
          
  fill(0);
  text(lx, 80, 150);
  text(ly, 80, 200);
  
  text(rx, 500, 150);
  text(ry, 500, 200);
  
  // 指の本数の表示
  if(lnumF >= 0) text(lnumF, lx, ly);
  if(rnumF >= 0) text(rnumF, rx, ry);
  
  noFill();
  strokeWeight(3);
  stroke(0,255,0);
  rect(lx, ly, 80, 80);//左側矩形
  stroke(255,0,0);
  rect(rx, ry, 80, 80);//右側矩形
}