
float pipeWidth = 60;
float pipeVelocity = 7;
float spaceWidth = 150;
// the y Coordinate of the Pipes are Predefined ==> height/2;

class Pipe{
  float x = pipeWidth/2 + width, y = height/2;
  float spaceStart, spaceEnd;
  
  Pipe(){
    spaceStart = random(50,height/2);
    spaceEnd = spaceStart + spaceWidth;
  }
  
  void showPipe(){
     stroke(255);
     fill(255);
     //rect(x - pipeWidth/2,0, pipeWidth, spaceStart);
     imageMode(CORNER);
     image(topPipe,x - pipeWidth/2,0, pipeWidth, spaceStart);
     image(bottomPipe,x - pipeWidth/2,spaceEnd , pipeWidth, height-spaceEnd);
     
  }
  
  void move(){
    if(x + pipeWidth/2 >= -offsetPixels){
      x -= pipeVelocity*SPEEDRATE;
    }
    
  }
}
