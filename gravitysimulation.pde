int totalObjects = 80;

float velocity = 1.5;                       // initial velocity
float[]xcoord = new float[totalObjects];
float[]ycoord = new float[totalObjects];
float[]xvel = new float[totalObjects];
float[]yvel = new float[totalObjects];
float[]xacc = new float[totalObjects];
float[]yacc = new float[totalObjects];
float[]mass = new float[totalObjects];
float diffx;
float diffy;
float dist;
float G = 0.3;
float force;
float xforce;
float yforce;
int inside;
int index;


void setup(){
   size(600,600);
   // creat all my objects
   for(int i = 0; i < totalObjects; i++){
     xcoord[i] = random(width);
     ycoord[i] = random(height);
     xvel[i] = random(-velocity, velocity);
     yvel[i] = random(-velocity, velocity);
     mass[i] = random(1, 20);
     
   }
}

void draw(){
  // calculate the forces
  calculateForce();
  // update coordinates
  updatePositions();
  // zoom check
  zoomCheck();
  // draw objects
  drawObjects();
}

void drawObjects(){
  background(0);
  fill(255);
  for(int a = 0; a < totalObjects; a++){
    if(mass[a]!=0){
      ellipse(xcoord[a], ycoord[a], 2*sqrt(mass[a]), 2*sqrt(mass[a]));
      
    }
  }
}

void calculateForce(){
 
  for(int a = 0; a < totalObjects; a++){
    xacc[a]=0;
    yacc[a]=0;
    
    for(int b = 0; b < totalObjects; b++){
      if(a!=b && mass[a]!=0){
         diffx = xcoord[b]-xcoord[a];          // xB + xA = x_Diff
         diffy = ycoord[b]-ycoord[a];          // yB + yA = y_Diff
         dist = sqrt(sq(diffx)+sq(diffy));     // Phytagoras
         
         force = (G*mass[a]*mass[b])/sq(dist); // 
         xforce = force * diffx / dist;
         yforce = force * diffy / dist;
         xacc[a] = xacc[a] + (xforce/mass[a]);
         yacc[a] = yacc[a] + (yforce/mass[a]);
      }
    }
    xvel[a] = xvel[a] + xacc[a];
    yvel[a] = yvel[a] + yacc[a];
  }
}

void updatePositions(){
  for(int a = 0; a < totalObjects; a++){
    xcoord[a] = xcoord[a] + xvel[a];
    ycoord[a] = ycoord[a] + yvel[a];
  }
}

void collision(){
  for(int a = 0; a < totalObjects; a++){
    for(int b = 0; b < totalObjects; b++){
      if(a!=b && mass[a]!=0 && mass[b]!=0){
         diffx = xcoord[b] - xcoord[a];
         diffy = ycoord[b] - ycoord[a];
         dist = sqrt(sq(diffx) + sq(diffy));
         if(dist<=sqrt(mass[a]) + sqrt(mass[b])){
           xvel[a] = ((mass[a] * xvel[a]) + (mass[b] * xvel[b])) / (mass[a] + mass[b]); 
           yvel[a] = ((mass[a] * yvel[a]) + (mass[b] * yvel[b])) / (mass[a] + mass[b]);  
           mass[a] = mass[a] + mass[b];
           xcoord[a] = ((mass[a] * xcoord[a] + (mass[b] * xcoord[b])) / (mass[a] + mass[b]));
           ycoord[a] = ((mass[a] * ycoord[a] + (mass[b] * ycoord[b])) / (mass[a] + mass[b]));  
         }  
      }
    }
  }
}

void zoomCheck(){
    // check for re-centering
    inside = -1;
    index = 0;
    
    //find largest mass
    for(int a = 0; a < totalObjects; a++){
      if(mass[a] >= mass[index]){
        index = a; 
      }
    }
    
    // check if it is in the screen
    if (xcoord[index] >=0 && xcoord[index] <= width && ycoord[index] >= 0 && ycoord[index] <= height){
      inside = 1; 
    }
    if(inside == -1){
      //recent largest mass
      diffx = (width/2) - xcoord[index];
      diffy = (height/2) - ycoord[index];
      for(int a = 0; a < totalObjects; a++){
        xcoord[a] = xcoord[a] + diffx;
        ycoord[a] = ycoord[a] + diffy;
      }
      //zoom
      for(int a = 0; a < totalObjects; a++){
        if(a != index){
          diffx = xcoord[index] - xcoord[a];
          diffy = ycoord[index] - ycoord[a];
          xcoord[a] = xcoord[a] + (diffx/2);
          ycoord[a] = ycoord[a] + (diffy/2);
          xvel[a] = (xvel[a] / 2);
          yvel[a] = (yvel[a] / 2);
          mass[a] = mass[a] / 2;
          
      }
      }
    }
}