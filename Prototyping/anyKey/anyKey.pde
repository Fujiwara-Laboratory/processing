import java.awt.Robot;
import java.awt.event.KeyEvent;

Robot robot;
int stateFlag = 0;

void setup(){
  frameRate(30);
  fill(0);
  textSize(32);
}

void settings(){
  try {
    robot = new Robot();
  }
  catch(Exception e) {
  }
}
  
void draw(){
  background(255);
  text(stateFlag, 10, 30);
  if(stateFlag == 1){
    kp1(KeyEvent.VK_SLASH, 150, 100);
  }
}

void keyPressed(){
  if(key == 't'){
    stateFlag = 1;
    robot.delay(1500);
  }
  if(key == 'y') stateFlag = 0;
}

void kp1(int bt, int tm, int dl){
  robot.keyPress(bt);
  robot.delay(tm);
  robot.keyRelease(bt);
  robot.delay(dl);
}