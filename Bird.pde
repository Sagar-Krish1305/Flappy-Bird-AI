float birdRad = 25;
float jumpRate = 12;
float offsetPixels = 5;
float gravity = 0.8;
//for the bird the x is already defined --> let x = width/8;;

PImage randomBird, hybridBird, greatBird, mutatedBird;

class Bird{
  
  PImage image;
  float x = width/8,y;
  int SEED;
  float fitness = 0;
  int score = 0;
  float velocity = 7;
  /*
      Total inputs required by the bird
      1. startSpace (1)
      2. endSpace (2)
      3. itsOwn x, y (3,4)
      6. pipe's x and y (5,6)
      7. velocity of pipe (7);
  */
  NeuralNetwork brain;
  Bird(){
    image = randomBird;
    y = random(height);
    SEED = (int)random(500);
    brain = new NeuralNetwork( 7 , 18 , 2 , 0.2 , SEED);
    
  }
  Bird(Bird b){
    image = randomBird;
    y = random(height);
    brain = b.brain;
    
  }
  
  void show(){
    stroke(255);
    strokeWeight(1);
    //int fill = (int)map(score ,0 , MaxScore, 0, 255);
    //fill();
    imageMode(CENTER);
    image(image,x,y,2*birdRad,2*birdRad);
    
  }
  
 
  
  void jump(Pipe p){
    if(y - birdRad - offsetPixels >= 0){
        double[] inputs = {p.x,p.y,pipeVelocity,p.spaceStart,p.spaceEnd,x,y};
        Matrix input = make1DtoMatrix(inputs);
        Matrix output = brain.getOutput(input.matrix);
        if(output.matrix[0][0] >= output.matrix[1][0]){
          y -= jumpRate*SPEEDRATE;
         
        }
        //println(output.matrix[0][0]);
    }
  }
  
  void gravity(){
    velocity = map(y, 0,height, 2, 7);
    if(y + birdRad + offsetPixels <= height ){
      y += velocity*SPEEDRATE;
    }
  }
  
  Boolean collide(Pipe p){
    if(x + birdRad + offsetPixels>= p.x-pipeWidth/2 && x - birdRad - offsetPixels<= p.x+pipeWidth/2){
      if(y <= p.spaceStart || y >= p.spaceEnd){
        return true;
      }
      
    }
    score++;
    return false;
  }
  
  
  int score(){
    return score;
  }
  
}
