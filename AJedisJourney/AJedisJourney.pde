/********* VARIABLES *********/

// We control which screen is active by settings / updating
// gameScreen variable. We display the correct screen according
// to the value of this variable.
//
// 0: Initial Screen
// 1: Story Screen
// 2: Game Screen
// 3: Game-over Screen
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import processing.sound.*;

Box2DProcessing box2d;

int gameScreen = 0;
PImage bg;
PImage maze;
PImage bomb;
PImage alarm;
PImage lose;
PImage win;
SoundFile file;
PFont myFont;
int touch;
int finish = 0;


Boundary wall;
Reactor flag;

ArrayList<Boundary> boundaries;
ArrayList<Particle> particles;
ArrayList<Reactor> reactors;



/********* SETUP BLOCK *********/

void setup() {
  size(800, 600);
  bg = loadImage("PORTADA.jpg");
  file = new SoundFile(this, "Throne Room Theme mono.mp3");
  file.play();
  file.stop();
  file.loop();
  
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.listenForCollisions();
  
  boundaries = new ArrayList<Boundary>();
  particles = new ArrayList<Particle>();
  reactors = new ArrayList<Reactor>();
  
  //para que la bomba no salga de la ventana//
  boundaries.add(new Boundary(width/2,height-5,width,10,0));
  boundaries.add(new Boundary(width/2,5,width,10,0));
  boundaries.add(new Boundary(width-5,height/2,10,height,0));
  boundaries.add(new Boundary(5,height/2,10,height,0));
  
  //laberinto///
  ///PRIMER NIVEL///
  pushMatrix();
  translate(0,-20);
  boundaries.add(new Boundary(400,70,300,10,0));
  boundaries.add(new Boundary(615,200,300,10,5.2));
  boundaries.add(new Boundary(615,455,300,10,4.2));
  boundaries.add(new Boundary(400,570,300,30,0));
  boundaries.add(new Boundary(190,455,300,20,2.1));
  boundaries.add(new Boundary(140,265,150,10,1.1));
  //NIVEL INTERIOR//
  boundaries.add(new Boundary(400,150,210,10,0));
  boundaries.add(new Boundary(545,235,200,10,5.2));
  boundaries.add(new Boundary(545,400,200,10,4.2));
  boundaries.add(new Boundary(365,485,130,10,0));
  boundaries.add(new Boundary(255,400,200,10,2.1));
  boundaries.add(new Boundary(250,235,200,10,1.1));
  //NIVEL INTERIOR 2//
  boundaries.add(new Boundary(400,230,100,10,0));
  boundaries.add(new Boundary(470,270,100,10,5.2));
  boundaries.add(new Boundary(470,345,100,10,4.2));
  boundaries.add(new Boundary(400,385,100,10,0));
  boundaries.add(new Boundary(330,345,100,10,2.1));
  boundaries.add(new Boundary(315,290,30,10,1.1));
  
  reactors.add(new Reactor (400,300,40,40)); 
  popMatrix();
  flag = new Reactor(400,200,40,40);
  flag.display();
  
  
}


/********* DRAW BLOCK *********/

void draw() {
  // Display the contents of the current screen
  if (gameScreen == 0) {
    initScreen();
  } else if (gameScreen == 1) {
    storyScreen();
  } else if (gameScreen == 2) {
    gameScreen();
  }
  else if (gameScreen == 3){
    gameOverScreen();
  }else if (gameScreen ==4){
    victory();
  }
  
}


/********* SCREEN CONTENTS *********/

void initScreen() {
  // codes of initial screen
  image (bg,0,0);
  myFont = createFont("pixelmix_bold.ttf", 10);
  textFont(myFont);
  textAlign(CENTER);
  text("Click to start", 155, 450);
}
  void storyScreen(){
  background(0,20);
  fill(0,10);
  rect(0,0,width,height);
  fill(255);
  noStroke();
  ellipse(random(width),random(height),4,4);
  
  pushMatrix();
  translate(0,0);
  myFont = createFont("pixelmix_bold.ttf", 15);
  textFont(myFont);
  textAlign(CENTER,CENTER);
  fill(255,255,0);
  text("Rebel spies managed to steal \n secret plans to the Empire's ultimate weapon,\n the DEATH STAR, an armored space station\n with enough power to destroy an entire planet.",400,200);
  text("In it, they discovered a weakness in the main reactor. \n To get to it you have to go through \n a complicated labyrinth without touching the walls \n so that the alarms are not activated.", 400, 300);
  text("Since you are the only Jedi of the company, \n You must use the force to place a bomb in the reactor \n and end once and for all with the evil dominion of the Galaxy.", 400, 400);
  text("PRESS ANY KEY TO CONTINUE", width/2, 500);
  popMatrix();
  
    if (keyPressed) {
    gameScreen = 2;
    file.stop();
    file = new SoundFile(this, "Imperial march mono.mp3");
    file.play();
    file.stop();
    file.loop();
    }
  
}
void gameScreen() {
  // codes of game screen
    maze = loadImage("LABERINTO.jpg");
    image (maze,0,0);
    myFont = createFont("pixelmix_bold.ttf", 10);
    textFont(myFont);
    textAlign(CENTER,CENTER);
    fill(255,255,0);
    text("Press any key \n to create a Bomb", 80,160); 
    bomba();
    for (Boundary wall: boundaries) {
    wall.display();
    }
    for (Reactor flag: reactors) {
    flag.display();
    }
    
    if (touch>=3) {
     gameScreen=3;
     file.stop();
     file = new SoundFile(this, "Stop right there trooper_R.mp3");
     file.play();
  }
  
    if (finish>=1) {
     gameScreen=4;
     file.stop();
     file = new SoundFile(this, "Victory celebration.mp3");
     file.play();
     file.stop();
     file.loop();
  }
}
void gameOverScreen() {
  // codes for game over screen
   
   image(lose,0,0);
   myFont = createFont("pixelmix_bold.ttf", 15);
   textFont(myFont);
   textAlign(CENTER,CENTER);
   fill(255,255,0);
   text("CLICK TO RESTART", 380,130); 
}

void victory(){
  win = loadImage("GANA.jpg"); 
  image(win,0,0);
   myFont = createFont("pixelmix_bold.ttf", 15);
   textFont(myFont);
   textAlign(CENTER,CENTER);
   fill(255,255,0);
   text("CLICK TO RESTART", 380,80); 
}


/********* INPUTS *********/

public void mousePressed() {
  // if we are on the initial screen when clicked, start the game
  if (gameScreen==0) {
    startGame();
  }
  
  if (gameScreen==3){
  restart();
  }
  
  if (gameScreen ==4){
  restart();
  }
}



/********* OTHER FUNCTIONS *********/

// This method sets the necessary variables to start the game  
void startGame() {
  gameScreen=1;
}

void songs(){

  if (gameScreen == 2){
    file.stop();
    file = new SoundFile(this, "Imperial march.mp3");
    file.loop();  
    file.stop();
  }
  if (gameScreen==3){
  file.stop();
  file.play();
  }

}

void efectosound(){
  file = new SoundFile(this,"ALARM.mp3");
}



void cambioimagen(){
 alarm = loadImage("ALARMA.jpg");
 lose = loadImage("PERDIO.jpg");
  win = loadImage("GANA.jpg");
}

void bomba(){
      if (mousePressed) {
      for (Particle b: particles) {
       b.attract(mouseX,mouseY);
      }
    }
    
    box2d.step();

      for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.display();

      if (p.done()) {
        particles.remove(i);
      }
    }  
}

void keyPressed(){
  float sz = 10;
      particles.add(new Particle(random(200), 70, sz));
}

// Collision event functions!
void beginContact(Contact cp) {
  // Get both fixtures
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
  
   if (o1.getClass() == Particle.class && o2.getClass() == Particle.class) {
       Particle p1 = (Particle) o1;
       p1.delete();
       Particle p2 = (Particle) o2;
       p2.delete();
    }

  if (o1.getClass() == Boundary.class) {
    Particle p2 = (Particle) o2;
    p2.change();
    efectosound();{
    file.play();}
    cambioimagen();{
    image (alarm,0,0);
    touch=touch+1;
    if(touch>=3){
    p2.delete();
    }
    }
  }
    
    if (o2.getClass() == Boundary.class){
    Particle p = (Particle) o1;
    p.change();
    efectosound();{
    file.play();}
    cambioimagen();{
    image (alarm,0,0);
    touch=touch+1;
    if(touch>=3){
    p.delete();
    }
    }
    }

   if (o1.getClass() == Reactor.class) {
      Particle p = (Particle) o2;
      p.delete();
      finish=finish+1;
   }
   
   if (o2.getClass() == Reactor.class) {
      Particle p = (Particle) o1;
      p.delete();
      finish=finish+1;

     }
    }


// Objects stop touching each other
void endContact(Contact cp) {
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
  if (o1.getClass() == Boundary.class && o2.getClass() == Particle.class) {
  Particle p2 = (Particle) o2;
  p2.change2();
 }
}
