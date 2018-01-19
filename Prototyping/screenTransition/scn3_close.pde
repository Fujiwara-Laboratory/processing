void scn1_closing(){
  // 画面の描画 or コンテンツの動作
  fill(255, 165, 0);
  rect(0, 0, width, height);
  fill(0);
  textSize(64);
  text("Closing screen", 100, 100);
  
  textSize(28);
  text("click the screen by RIGHT button", 100, height - 100);
  
  // 画面遷移の条件
  if(mousePressed == true && mouseButton == RIGHT){
    flagStage = 0; // フラグをオープニングへ
  }
}