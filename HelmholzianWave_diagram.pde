PFont font;
import processing.svg.PGraphicsSVG;

void dashLine(float startx,float starty,float endx,float endy,float div){
  PVector vec,vec2;
  vec = new PVector(endx-startx,endy-starty);
  vec2 = new PVector();
  vec2.set(vec);
  vec.setMag(1000/div); 
  float num = vec2.mag()/vec.mag();  
  float tempx=startx,tempy=starty;
  for(int i=0;i<num/2;i++){
    line(tempx,tempy,tempx+vec.x,tempy+vec.y);
    tempx =tempx+2*vec.x;
    tempy =tempy+2*vec.y;
  }
}
int global_posy = 100; 

HZ_diagram diagram = new HZ_diagram(100,global_posy,800,500);

void setup(){
  
  font = createFont("HelveticaNeue-Light-12.vlw",12);
  textFont(font);
  size(1000,720);
  float bpos = 4./9;
  //Seting=> BowingPosition:0~1,number of clockwise HZ wave,number of counterclockwise HZ wave.
  // Large M and N is 2(temporarily fixed in HZ_diagram Class.)
  
  diagram.init(bpos,7,2);
  diagram.setBottomscale(300);
  diagram.setup();
  background(255);
  noLoop();
}

void draw(){
  
  strokeWeight(2);
  diagram.draw();
  
}

void mousePressed(){
  loop();
}
void mouseDragged(){

  if(mouseY>global_posy&&mouseY<global_posy+500){
  float  t = float(mouseY);
  t= map(t,global_posy,diagram.height,0,2.5);
  diagram.setTime(t);
  }
}
void mouseReleased(){
  noLoop();
}
void keyPressed(){
if(key == 'r'){
  save("mydiagram.png");
  println("save was succeeded.");
}
}