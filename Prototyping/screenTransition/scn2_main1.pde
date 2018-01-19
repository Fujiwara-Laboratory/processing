void scn1_mainSecond(){
  // 画面の描画 or コンテンツの動作
  fill(200, 200, 255);
  rect(0, 0, width, height);
  fill(0);
  textSize(64);
  text("second screen", 100, 100);
  
  textSize(28);
  text("click the screen by CENTER button", 100, height - 100);
  
  // 画面遷移の条件
  if(mousePressed == true && mouseButton == CENTER){
    flagStage = 3; // フラグをクロージングへ
  }
}