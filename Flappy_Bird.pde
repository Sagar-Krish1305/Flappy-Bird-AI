import java.util.Stack;
import java.util.HashSet;
import java.util.*;
Bird b;
Pipe p;
PImage topPipe, bottomPipe;

Bird bestBird;


float SPEEDRATE = 1;
ArrayList<Pipe> pipes;
ArrayList<Bird> birds;
ArrayList<Bird> lastGenBirds;
int MAX_BIRDS = 150;




void setup(){
  size(700,700);
  b = new Bird();
  p = new Pipe();
  pipes = new ArrayList<>();
  birds = new ArrayList<>();
  
  randomBird = loadImage("random.png");
  hybridBird = loadImage("bird.png");
  greatBird = loadImage("best.png");
  mutatedBird = loadImage("mutated.png");
  
  topPipe = loadImage("top.png");
  bottomPipe = loadImage("bottom.png");
  
  lastGenBirds = new ArrayList<>();
  pipes.add(new Pipe());
  for(int i = 0 ; i < MAX_BIRDS ; i++){
    birds.add(new Bird());
  }
}
void pipeAdder(){
   pipes.add(new Pipe());
   if(pipes.get(0).x + pipeWidth/2 < -offsetPixels)
     pipes.remove(0);
}
int MaxScore = 1;
int genNumber = 0;
float counter = 1;

Bird bestOfAGeneration = null;

void draw(){
  
  background(0);
  SPEEDRATE = map(mouseX, 0, width, 1, 3);
  textSize(20);
  text("Current Generation Remaining: " + birds.size(), width/2,50);
  text("Current Generation Number: " + genNumber, width/2,75);
  text("Max Score: " + MaxScore, width/2, 100);
  //pipeVelocity = map(mouseX, 0, width, 15,35);
  //if(MaxFitnessBird!=null){
  //  println("Max Fitness Bird");
  //  MaxFitnessBird.brain.details();
  //}
  
  
  for(Bird b : birds){
    b.show();
    b.gravity();
    if(b.score >= MaxScore){
      MaxScore = b.score;
      bestBird = b;
    }
  }
  
  
  
  
  Stack<Bird> collided = new Stack<>();
  
  
  for(Pipe pipe : pipes){
    pipe.showPipe();
    pipe.move();
    for(Bird b : birds){
      
      b.jump(pipe);
      if(b.collide(pipe)){
          collided.push(b);
         lastGenBirds.add(b);
      }
     
    }
   
    while(!collided.isEmpty()){
      birds.remove(collided.pop());
    }
  }
  
  
  
  generationMaker();
  
  if(counter>75){
    pipeAdder();
    counter=0;
  }
  
  counter+=SPEEDRATE;
  
}

Bird poolSelection(){
 
  float minFitness = Float.MAX_VALUE;
  for(int i = 0 ; i < lastGenBirds.size() ; i++){
    if(minFitness > lastGenBirds.get(i).fitness){
      minFitness = lastGenBirds.get(i).fitness;
    }
  }
  
 float k = random(minFitness,1);
    int index = 0;
    while(index < lastGenBirds.size() && k > 0){
      k -= lastGenBirds.get(index).fitness;
      index++;
    }
    index--;
   
  
  
  return new Bird(lastGenBirds.get(index));
}

void mousePressed(){
  bestBird.brain.mutate(0.1);
  birds.add(new Bird(bestBird));
}

void keyPressed(){
  if(key == ' '){
    birds.add(new Bird());
  }
}
void normalizeFitness(){
  
  int sum = 0;
  for(Bird b : lastGenBirds){
    sum += b.score;
  }
  for(Bird b : lastGenBirds){
    b.fitness =  1.0*b.score/sum;
  }
  
}
int runner = 0;
void generationMaker(){
  
  if(birds.size() == 0){
    if(pipes.get(0).x + pipeWidth <= width/8){
      genNumber++;
      runner++;
      if(runner%5==0){
      normalizeFitness();
      
      for(int i = 0 ; i < 9*MAX_BIRDS/19 -6 ; i++){
        Bird b = crossOverBird(bestBird, poolSelection());
        b.image = hybridBird;
        birds.add(b);
      }
      
      Bird b = new Bird(bestBird);
      b.image = greatBird;
      birds.add(b);
      
      
      // Add Some Red Mutated birds;
      
      for(int i = 0 ; i < 5 ; i++){
        Bird mutated = new Bird(bestBird);
        if(random(1) <= 0.01)
          mutated.brain.mutate(0.000001);
        mutated.image = mutatedBird;
        birds.add(mutated);
      }
      
      for(int i = 0 ; i < MAX_BIRDS/10 ; i++){
        
        birds.add(new Bird());
      }
     
      
      }else{
        for(Bird b : lastGenBirds){
          Bird g = new Bird(b);
          birds.add(g);
        }
      }
      
      lastGenBirds.clear();
      
      
    }
  }
}
