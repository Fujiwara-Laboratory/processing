int flagStage = 0;

void setup(){
  size(800, 600);
}

void draw(){
  background(255);
  
  // 画面遷移の分岐
  if(flagStage == 0){
    scn0_opening();
  }else if(flagStage == 1){
    scn1_mainContents();
  }else if(flagStage == 2){
    scn1_mainSecond();
  }else if(flagStage == 3){
    scn1_closing();
  }
  
}