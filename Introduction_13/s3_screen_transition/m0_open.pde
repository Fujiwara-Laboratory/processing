void scn0_opening(){
  // 画面の描画 or コンテンツの動作
  fill(255, 200, 200);
  rect(0, 0, width, height);
  fill(0);
  textSize(64);
  text("Opening credits", 100, 100);
  
  textSize(28);
  text("click the screen by LEFT button", 100, height - 100);
  
  // 画面遷移の条件
  if(mousePressed == true && mouseButton == LEFT){
    flagStage = 1; // フラグを一つ目のメインへ
  }
}