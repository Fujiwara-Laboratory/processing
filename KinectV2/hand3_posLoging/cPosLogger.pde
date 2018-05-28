class ksklPosLog{
  posParts p[];
  int flame, maxFlame;
  boolean on;
  int takeNum;
  
  // 最大フレーム数でメモリを確保しておく
  ksklPosLog(int n){
    flame = 0; // フレーム数
    on = false;
    p = new posParts[n];
    maxFlame = n;
    takeNum = 0;
    
    for(int i = 0; i < n; i++) p[i] = new posParts();
  }
  
  // ログをしなおすためにリセット
  void initLogger(){
    flame = 0;
    takeNum++;
    on = false;
  }
  
  // ※要追加※ パーツを増やす場合は引数を追加する
  void posPartsSet(PVector hr, PVector hl){
    if(!on) return;
    
    // ※要追加※ パーツを増やす場合は追加する
    p[flame].rightHand = hr.copy(); // このフレームの右手をメモリに追加
    p[flame].leftHand = hl.copy(); // このフレームの左手をメモリに追加
    
    flame++; // 各パーツをフィールドにコピーした後に配列の要素を次に
    if(flame == maxFlame){ // 最大フレーム数にたどり着いたらログ終了
      on = false;
      savePosLog(); // セーブへ
    }
  }
  
  void getTrigger(){
    if(on){ // 記録中でのトリガ発生時
      on = false;
      savePosLog(); // セーブへ
    }else{ // 非記録状態でのトリガ発生時
      on = true;
    }
  }
  
  void savePosLog(){
    Table tbl = new Table();
    int i, j;
    
    // ※要追加※ パーツを増やす場合は追加する
    // 必要な情報だけを選定してもよい
    tbl.addColumn("r hand x");
    tbl.addColumn("r hand y");
    tbl.addColumn("r hand z");
    tbl.addColumn("l hand x");
    tbl.addColumn("l hand y");
    tbl.addColumn("l hand z");
    
    for(i = 0; i < flame; i++){
      TableRow row = tbl.addRow();
      j = 0;
      // ※要追加※ パーツを増やす場合は追加する
      // 必要な情報だけを選定してもよい
      row.setFloat(j, p[i].rightHand.x); j++;
      row.setFloat(j, p[i].rightHand.y); j++;
      row.setFloat(j, p[i].rightHand.z); j++;
      row.setFloat(j, p[i].leftHand.x); j++;
      row.setFloat(j, p[i].leftHand.y); j++;
      row.setFloat(j, p[i].leftHand.z); j++;
    }
    
    saveTable(tbl, "log_" + nf(takeNum, 2) + ".csv");
    initLogger();
  }
}

class posParts{
  // ※要追加※ パーツを増やす場合はフィールドを追加する
  PVector rightHand; 
  PVector leftHand;
  
  posParts(){
    rightHand = new PVector(0, 0, 0);
    leftHand = new PVector(0, 0, 0);
    
    // ※要追加※ パーツを増やす場合は追加する
  }
}
