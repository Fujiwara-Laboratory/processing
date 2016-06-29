// kinect用ライブラリ
import kinect4WinSDK.*;

// RGBDカメラ用変数
Kinect kinect;
ArrayList <SkeletonData> bodies;

int maxPointsNUM = 200; // 線を描く(ストックしておく)フレーム数
int maxHandsNUM = 8; // 対応可能な手の本数
int maxBdyNUM = maxHandsNUM / 2; // 対応可能な人数(手の本数の半分)
int id[] = new int[maxHandsNUM]; // 手ID
PVector p[][] = new PVector[maxHandsNUM][maxPointsNUM]; // 検出された点
int pCount[] = new int[maxHandsNUM]; // 点のフレーム番号(基本的には pCount[i] % maxPointsNUM で使う)
color[] userClr = new color[]{color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), color(255, 255, 0)};

void setup(){
  size(640, 480);

  // RGBDカメラ関係の初期化
  kinect = new Kinect(this);
  
  bodies = new ArrayList<SkeletonData>();
  
  noFill();
  strokeWeight(3);
  
  for(int i = 0; i < maxHandsNUM; i++) id[i] = -1; // 手IDの初期化(1以上だけど念のためデータ無しは-1とする)
}

void draw(){
  int i, j, hID;
  float x, y;
  PVector pl = new PVector();
  PVector pcl = new PVector();
  
  // カラー画像の表示
  image(kinect.GetImage(),0,0);
  
  for(i = 0; i < maxHandsNUM; i++){
    if(id[i] != -1){ // IDが割り当てられている点を描画
      stroke(userClr[i]);
      
      // ストックした点の0番目から
      pl = p[i][0].copy();
      
      // 手のある要素までを線でつなぐ
      for(j = 1; j <= pCount[i] % maxPointsNUM ; j++){
        pcl = p[i][j].copy();
        line(pl.x, pl.y, pcl.x, pcl.y);
        pl = pcl.copy();
      }
      ellipse(pl.x, pl.y, 30, 30); // 手の位置には円を描画
      
      // 配列の長さ以上のフレームになった場合
      if(pCount[i] >= maxPointsNUM){
        // ストックした点の0番目から
        pl = p[i][0].copy();
        
        // 手の要素+1までを線でつなぐ (0 -> max-1 -> max-2 -> ... -> current+1)
        for(j = maxPointsNUM - 1; j > pCount[i] % maxPointsNUM; j--){
          pcl = p[i][j].copy();
          line(pl.x, pl.y, pcl.x, pcl.y);
          pl = pcl.copy();
        }
      }
    }
  }
  
  for(i = 0; i < bodies.size (); i++){
    // 右手
    hID = i * 2;
    if(bodies.get(i).skeletonPositionTrackingState[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED){
      x = bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].x * width;
      y = bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].y * height;
      
      if(id[hID] == -1){
        id[hID] = 1;
        pCount[hID] = 0;
        p[hID][pCount[hID] % maxPointsNUM] = new PVector(x, y, 0);
      }else{
        pCount[hID]++;
        p[hID][pCount[hID] % maxPointsNUM] = new PVector(x, y, 0);
      }
    }else{
      id[hID] = -1;
    }
    
    // 左手
    hID = i * 2 + 1;
    if(bodies.get(i).skeletonPositionTrackingState[Kinect.NUI_SKELETON_POSITION_HAND_LEFT] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED){
      x = bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_LEFT].x * width;
      y = bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_LEFT].y * height;
      
      if(id[hID] == -1){
        id[hID] = 1;
        pCount[hID] = 0;
        p[hID][pCount[hID] % maxPointsNUM] = new PVector(x, y, 0);
      }else{
        pCount[hID]++;
        p[hID][pCount[hID] % maxPointsNUM] = new PVector(x, y, 0);
      }
    }else{
      id[hID] = -1;
    }
  }
}


void appearEvent(SkeletonData _s){
  if(_s.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED){
    return;
  }
  synchronized(bodies){
    bodies.add(_s);
  }
}

void disappearEvent(SkeletonData _s){
  synchronized(bodies){
    for(int i = bodies.size() - 1; i >= 0; i--){
      if(_s.dwTrackingID == bodies.get(i).dwTrackingID){
        bodies.remove(i);
      }
    }
  }
}

void moveEvent(SkeletonData _b, SkeletonData _a){
  if(_a.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED){
    return;
  }
  synchronized(bodies){
    for(int i=bodies.size() - 1; i >= 0; i--){
      if(_b.dwTrackingID == bodies.get(i).dwTrackingID){
        bodies.get(i).copy(_a);
        break;
      }
    }
  }
}