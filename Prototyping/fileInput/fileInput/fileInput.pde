NotesSystem nset;
int f_notes = 0;

void setup(){
  nset = new NotesSystem();
  readNotes("notes_sample.txt");
  f_notes = 1;
  size(500, 500);
}

void draw(){
  background(255);
  if(f_notes == 1){
    nset.addActiveID();
    nset.run();
  }
}

void readNotes(String fileName){ // テキストファイルを読み込んでノーツデータの格納をする
  String lines[] = loadStrings(fileName), prms[]; // ファイル全体と各行の文字列
  int i, time, btType, btnum1 = 0, btnum2 = 0, hold = 0;
  nset = new NotesSystem();
  
  for(i = 0; i < lines.length; i++){ // 各行の読み込み
    prms = split(lines[i], ','); // カンマで分割
    time = Integer.parseInt(prms[0]); // 1つめ：時間
    btType = Integer.parseInt(prms[1]); // 2つめ：タイプ(1押しか同時押しか)
    if(btType == 1){
      btnum1 = Integer.parseInt(prms[2]); // 3つめ：ボタンID
      hold = Integer.parseInt(prms[3]); // 4つめ：ホールド時間
      nset.addNotesSet(time, btType, btnum1, hold);
    }else if(btType == 2){
      btnum1 = Integer.parseInt(prms[2]);
      btnum2 = Integer.parseInt(prms[3]); // 同時押しの場合はホールド時間の前にIDがくる
      hold = Integer.parseInt(prms[4]);
      nset.addNotesSet(time, btType, btnum1, hold);
      nset.addNotesSet(time, btType, btnum2, hold);
    }
  }
}