
void setup(){  
  int v0, v1;
  v0 = 3;
  v1 = 5;
  int_plus(v0, v1);
  println(v0);
  
  PVector p0, p1;
  p0 = new PVector(2, 3);
  p1 = new PVector(6, 2);
  pv_plus(p0, p1);
  println(p0.x);
  
  int v2, v3;
  v2 = int_return();
  println(v2);
  
  v3 = int_plus_return(v0, v1);
  println(v3);
}
