PImage srcImg;
int r1, g1, b1, r2, g2, b2;
int typeFlag;

void setup(){
  srcImg = loadImage("画像のファイルパス");
  surface.setSize(srcImg.width, srcImg.height);
}

void draw(){
  image(srcImg, 0, 0);
}

void mousePressed(){
  color c;
  int r, g, b;
  c = srcImg.pixels[mouseX + mouseY * width ];
  r = (c >> 16) & 0xFF;
  g = (c >> 8) & 0xFF;
  b = c & 0xFF;
  if(typeFlag == 0){
    r1 = r2 = r;
    g1 = g2 = g;
    b1 = b2 = b;
    typeFlag = 1;
    println(r1 + "<" + r2 + ", " + g1 + "<" + g2 + ", " + b1 + "<" + b2);
  }else if(typeFlag == 1){
    r1 = min(r1, r);
    g1 = min(g1, g);
    b1 = min(b1, b);
    r2 = max(r2, r);
    g2 = max(g2, g);
    b2 = max(b2, b);
    println(r1 + "<" + r2 + ", " + g1 + "<" + g2 + ", " + b1 + "<" + b2 + ": " + typeFlag);
  }
}

void keyPressed(){
  if(key == '1' || key == '2') typeFlag = Integer.parseInt("" + key);
}