class HZ_diagram { //<>//
  int width;
  int height;
  int posX;
  int posY;
  int largeM =2;
  int smallm;
  int largeN=2;
  int smalln;
  float time = 0;
  float ptime=0;
  float draw_period = 3;
  float len_halfperiod = this.height/draw_period; 
  float bottomscale=250;
  float bowing_pos;//0~1
  
  float graphtemp=0;
  boolean isslip=false;

  HZ_Child[] clockwise_wave;
  HZ_Child[] c_clockwise_wave;

  HZ_diagram() {
    this.width=800;
    this.height = 600;
    len_halfperiod = this.height/draw_period;
    posX=0;
    posY=0;
  }
  HZ_diagram(int _posX, int _posY, int _width, int _height) {
    this.width=_width;
    this.height = _height;
    len_halfperiod = this.height/draw_period;
    posX=_posX;
    posY=_posY;
  }
  void setTime(float t) {
    this.time = t;
  }
  void init(float pos, int m, int n) {
    this.bowing_pos = pos;
    this.smallm=m;
    this.smalln=n;
  }
  void setBottomscale(float s){
    this.bottomscale = s;
  }
  void setup() {
    clockwise_wave = new HZ_Child[smallm];
    c_clockwise_wave = new HZ_Child[smalln];
    float hueindex = 255/(smallm+smalln);
    colorMode(HSB);
    for (int i=0; i<clockwise_wave.length; i++) {
      clockwise_wave[i]= new HZ_Child();
      clockwise_wave[i].is_clockwise = true;
      clockwise_wave[i].phase = bowing_pos+i*bowing_pos*2;
      clockwise_wave[i].barcolor = color(hueindex*i, 200, 200);
      clockwise_wave[i].barcolor2 = color(hueindex*i, 100, 200);
    }
    for (int i=0; i<c_clockwise_wave.length; i++) {
      c_clockwise_wave[i]= new HZ_Child();
      c_clockwise_wave[i].is_clockwise = false;
      c_clockwise_wave[i].phase = bowing_pos+i*bowing_pos*2;
      c_clockwise_wave[i].barcolor = color(hueindex*(i+smallm), 200, 230);
      c_clockwise_wave[i].barcolor2 = color(hueindex*(i+smallm), 40, 230);
    }
  }

  void drawMainDiagram() {
    pushMatrix();
    translate(posX, posY);
    colorMode(HSB);
    noStroke();
    fill(0, 0, 255);
    rect(0, 0, this.width+2, this.height+1);
    noFill();
    for (int i=0; i<clockwise_wave.length; i++) {
      stroke(clockwise_wave[i].barcolor);
      float lo_phase = clockwise_wave[i].phase%2;
      boolean drawing = true;
      float startx, starty, endx, endy;
      if (lo_phase<1) {
        startx = this.width*lo_phase;
        endx = this.width;
        endy = len_halfperiod*(1-lo_phase);
      } else {
        startx = this.width*(2-lo_phase);
        endx = 0;
        endy = len_halfperiod*(2-lo_phase);
      }
      starty= 0;    
      while (drawing) {
        line(startx, starty, endx, endy);
        startx = endx;
        starty = endy;
        endx = (startx==0 ? this.width : 0);
        endy += len_halfperiod; 
        if (endy>this.height) {
          endx =(lo_phase>1? this.width*(1-(2-lo_phase)):this.width*(1-lo_phase));
          endy = this.height;
          line(startx, starty, endx, endy);
          drawing=false;
        }
      }
    }
    for (int i=0; i<c_clockwise_wave.length; i++) {
      stroke(c_clockwise_wave[i].barcolor);
      float lo_phase = c_clockwise_wave[i].phase%2;
      boolean drawing = true;
      float startx, starty, endx, endy;
      if (lo_phase<1) {
        startx = this.width*lo_phase;
        endx = 0;
        endy = len_halfperiod*lo_phase;
      } else {
        startx = this.width*(2-lo_phase);
        endx = this.width;
        endy = len_halfperiod*(1-(2-lo_phase));
      }
      starty= 0;    
      while (drawing) {
        dashLine(startx, starty, endx, endy, 100);
        startx = endx;
        starty = endy;
        endx = (startx==0 ? this.width : 0);
        endy += len_halfperiod; 
        if (endy>this.height) {
          endx =(lo_phase>1? this.width*(1-(2-lo_phase)):this.width*(1-lo_phase));
          endy = this.height;
          dashLine(startx, starty, endx, endy, 100);
          drawing=false;
        }
      }
    }
    if(isslip){
    stroke(255, 255, 255);
    }else{
    stroke(0, 0, 0);
    }
    line(0, this.height*time/(draw_period), this.width, this.height*time/(draw_period));
    stroke(0, 0, 60);
    line(this.width*bowing_pos, 0, this.width*bowing_pos, this.height);
    popMatrix();
  }
  void drawUpperDiagram() {
    pushMatrix();
    translate(posX, posY-100);

    fill(0, 0, 255);
    noStroke();
    rect(-2, -20, this.width+4, 120);
    textAlign(CENTER);
    textSize(14);
    fill(0, 0, 0);
    text("bow", this.width*bowing_pos, 90);

    noFill(); 
    stroke(0, 0, 0);
    line(0, 50, this.width, 50);

    for (int i=0; i<clockwise_wave.length; i++) {


      float lo_phase= (clockwise_wave[i].phase+time)%2;
      float x;
      if (lo_phase<1) {
        x=this.width*lo_phase;
        stroke(clockwise_wave[i].barcolor);
        strokeWeight(2);
        line(x, 50, x, 50-50/clockwise_wave.length);
      } else {     
        x=this.width*(2-lo_phase);
        stroke(clockwise_wave[i].barcolor);
        strokeWeight(2);
        line(x, 50, x, 50+50/clockwise_wave.length);
      }
    }
    for (int i=0; i<c_clockwise_wave.length; i++) {
      float lo_phase= (2+c_clockwise_wave[i].phase-(time%2))%2;
      float x;
      if (lo_phase<1) {
        x=this.width*lo_phase;

        stroke(c_clockwise_wave[i].barcolor);
        strokeWeight(2);
        line(x, 50, x, 50-50/c_clockwise_wave.length);
      } else {     
        x=this.width*(2-lo_phase);
        stroke(c_clockwise_wave[i].barcolor);
        strokeWeight(2);
        line(x, 50, x, 50+50/c_clockwise_wave.length);
      }
    }

    popMatrix();
  }
  void drawLeftDiagram() {
    textAlign(CENTER);
    pushMatrix();
    translate(posX-100, posY);
    noStroke();
    fill(0, 0, 255);
    rect(0, -20, 100, this.height);
    textSize(14); 
    fill(0, 0, 0);
    text("v(t)", 50, -10);
    text("t=0", 70, 7);
    text("t=T", 70, 7+this.height*2/draw_period);
    noFill(); 

    stroke(0, 0, 0);
    line(50, 0, 50, this.height);
    for (int i=0; i<clockwise_wave.length; i++) {
      stroke(clockwise_wave[i].barcolor);
      float lo_phase= clockwise_wave[i].phase%2;
      float len, posy;
      len = 50/smallm;
      posy = len_halfperiod*(2-lo_phase);
      boolean isdraw =true;
      while (isdraw) {
        if (posy>0) {
          line(50, posy, 50+len, posy);
        }
        posy+=len_halfperiod*2;
        if (posy>this.height) {
          isdraw = false;
        }
      }
    }
    for (int i=0; i<c_clockwise_wave.length; i++) {
      stroke(c_clockwise_wave[i].barcolor);
      float lo_phase= c_clockwise_wave[i].phase%2;
      float len, posy;
      len = -50/smallm;
      posy = len_halfperiod*(lo_phase);
      boolean isdraw =true;
      while (isdraw) {
        if (posy>0) {
          line(50, posy, 50+len, posy);
        }
        posy+=len_halfperiod*2;
        if (posy>this.height) {
          isdraw = false;
        }
      }
    }
    popMatrix();
  }
  
  void drawBottomDiagram(float shade,float graphscale) {
    
    float num_points = 400;
    float tempx=0, tempy=0;
    pushMatrix();
    
    translate(posX, posY+this.height);
    noStroke();
    fill(0, 0, 0, 2);
    rect(0, -10, this.width, 110);
    blendMode(ADD);
    noFill();
    stroke(0, 0, 100, shade);
    strokeWeight(1);
    beginShape();
    vertex(0, 60);
    for (int n = 0; n<num_points; n++) {
      tempx = float(this.width*(n+1))/num_points;
      tempy=0;

      for (int i =0; i<clockwise_wave.length; i++) {
        float p1 = (clockwise_wave[i].phase+time)%2;
        tempy+=computeOresen(graphscale, float(n+1)/num_points, p1)/clockwise_wave.length;
      }
      for (int i =0; i<c_clockwise_wave.length; i++) {
        float p2 = (32+c_clockwise_wave[i].phase-time)%2;
        tempy+=computeOresen(graphscale, float(n+1)/num_points, p2)/c_clockwise_wave.length;
      }
      vertex(tempx, 60+tempy);
    }
    endShape();
    tempy=0;

    for (int i =0; i<clockwise_wave.length; i++) {
      float p = (clockwise_wave[i].phase+time)%2;
      tempy+=computeOresen(graphscale, bowing_pos, p)/clockwise_wave.length;
    }
    for (int i =0; i<c_clockwise_wave.length; i++) {
      float p =(32+c_clockwise_wave[i].phase-time)%2;
      tempy+=computeOresen(graphscale, bowing_pos, p)/c_clockwise_wave.length;
    }
    if((tempy-graphtemp)<=0 ^ (time-ptime)>0){//slip
      isslip=false;
    }else{
      isslip=true;
    }
    noStroke();
    if(isslip){
    fill(0,255,255,255);
    }else{
    fill(127,255,255,255);
    }
    blendMode(BLEND);
    ellipse(this.width*bowing_pos, 60+tempy,6,6);
    popMatrix();
    

    graphtemp = tempy;
    strokeWeight(2);
  }
  float computeOresen(float global_height, float x, float phase) { //x:0~1
    float topy;
    if (phase<1) {
      topy = -global_height*(0.25-pow((phase-0.5), 2));
      if (x<phase) {
        return topy*  x  / phase;
      } else {
        return topy*(1-x)/(1-phase);
      }
    } else {
      float lophase = phase-1;
      float lx = 1-x;
      topy = global_height*(0.25-pow((lophase-0.5), 2));
      if (lx<lophase) {
        return topy*  lx  / lophase;
      } else {
        return topy*(1-lx)/(1-lophase);
      }
    }
  }
  // vertical length is 1.5T;
  void draw() {
    drawBottomDiagram(250,bottomscale); //do first to calculate isslip 
    drawMainDiagram();
    drawUpperDiagram();
    drawLeftDiagram();
    
    ptime = time;
  }
}
class HZ_Child { //just struct of individual Helmholzian wave.
  boolean is_clockwise;
  float phase; //0~2
  color barcolor;
  color barcolor2;
}