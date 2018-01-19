void scn1_mainContents(){
  // 画面の描画 or コンテンツの動作
  fill(200, 255, 200);
  rect(0, 0, width, height);
  fill(0);
  textSize(64);
  text("main contents", 100, 100);
  
  textSize(28);
  text("click the screen by RIGHT button", 100, height - 100);
  
  // 画面遷移の条件
  if(mousePressed == true && mouseButton == RIGHT){
    flagStage = 2; // フラグを二つ目のメインへ
  }
}