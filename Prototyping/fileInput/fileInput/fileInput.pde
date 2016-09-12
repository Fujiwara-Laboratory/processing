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

// ノーツ用のクラス
// データ全体の管理と各ノーツのクラスから構成される

class NotesSystem{
  ArrayList<Note> notesSet; // 読み込んだノーツの一式
  ArrayList<Integer> activeID; // 動かしているノーツの一覧
  int iSrh, cNts;

  NotesSystem(){
    // ノーツセットの初期化
    notesSet = new ArrayList<Note>();
    activeID = new ArrayList<Integer>();
    iSrh = 0;
    cNts = 0;
  }

  void addNotesSet(int time, int type, int button, int hold){
    notesSet.add(new Note(time, type, button, hold)); // ノーツの追加
  }
  
  void addActiveID(){
    // 前探索しないように登録が終わったところからループ
    for(int i = iSrh; i < notesSet.size(); i++){
      // ノーツ一式のフレームを見て一致する物があればアクティブリストへ追加
      if(notesSet.get(i).getTime() == cNts){
        activeID.add(i);
        iSrh = i;
      }else if(notesSet.get(i).getTime() > cNts){
        break;
      }
    }
  }

  void run(){
    for(int i = 0; i < activeID.size(); i++){
      notesSet.get(activeID.get(i)).run(); // アクティブなものだけ動かす
      if(notesSet.get(activeID.get(i)).isDead()) activeID.remove(activeID.get(i));
    }
    cNts++;
  }
}


// 個々のノーツの管理
class Note{
  int tm, tp, bt, hd; // スコアファイルからの入力
  int hdTm, cHd; // ホールドの秒数とカウンタ
  int f_state; // ノーツの状態
  int mvTm, cMv; // ノーツ移動の秒数とカウンタ
  float x, y, sx, sy, ex, ey, dx, dy; // ノーツの座標関連の変数
  
  Note(int time, int type, int button, int hold){
    tm = (time * 3) / 50; // ミリ秒からフレームカウントへ変換
    tp = type;
    bt = button;
    hd = hold;
    cHd = 0;
    f_state = 0;
    cMv = 0;
    hdTm = 20 * hd; // ホールド時間と難易度は適宜調整する
    mvTm = 60; // ノーツ移動時間と難易度は適宜調整する
    
    // 初期位置と終了位置はアプリケーションにあわせて適宜変更する
    sx = 50;
    sy = (button) * 75;
    ex = 450;
    ey = (button) * 75;
    
    // 位置の変数や変化量はそのまま使えばよい
    x = sx;
    y = sy;
    dx = (ex - sx) / mvTm;
    dy = (ey - sy) / mvTm;
  }
  
  int getTime(){ return tm; } // フレームカウント用のゲッター
  
  void run(){
    // 表示の仕方は適宜変更する
    //println(tm, tp, bt, hd, x, y, cMv);
    noFill();
    strokeWeight(3);
    if(f_state == 0) stroke(0, 0, 0);
    else stroke(255, 0, 0);
    ellipse(x, y, 50, 50);
    
    // 情報の更新 (以降はそのまま使える)
    if(f_state == 0){
      x += dx;
      y += dy;
      cMv++;
    }else if(f_state == 1){
      cHd++;
    }
    
    // 更新された情報を元に状態の分岐
    if(cMv == mvTm) f_state = 1;
  }
  
  boolean isDead(){
    if(cHd == hdTm) return true;
    else return false;
  }
}