class Dot {
  PVector pos;
  PVector vel;
  PVector acc;
  Brain brain;

  boolean dead = false; // true om denna prick är död
  boolean reachedGoal = false; // true om denna prick nuddade målet
  boolean isBest = false; // true om denna prick är den bästa från förra generationen

  float fitness = 0; // hur värdig en prick är att gå vidare till nästa generation

  Dot() {
    brain = new Brain(1000); // ny hjärna med 1000 instruktioner

    // prickarna börjar vid botten av skärmen med 0 hastighet och 0 acceleration
    pos = new PVector(width/2, height- 10);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
  }


  //-----------------------------------------------------------------------------------------------------------------
  // ritar ut pricken på skärmen
  void show() {
    //if this dot is the best dot from the previous generation then draw it as a big green dot
    
    if (isBest) { // om denna prick är den bästa från förra generationen
      fill(0, 255, 0); // gör den grön
      ellipse(pos.x, pos.y, 8, 8); // gör den dubbelt så stor
      
    } else { // alla andra prickar är mindre svarta prickar
      fill(0);
      ellipse(pos.x, pos.y, 4, 4);
    }
  }

  //-----------------------------------------------------------------------------------------------------------------------
  
  // flyttar på pricken enligt hjärnans directions
  void move() {

    if (brain.directions.length > brain.step) { // om det finns directions kvar,  sätter accelerationen som nästa PVector i directions listan
      acc = brain.directions[brain.step];
      brain.step++;
    } else { // om man är vid slutat av directions, dör pricken
      dead = true;
    }

    // sätt accelerationen och flytta pricken
    vel.add(acc);
    vel.limit(5); // inte för snabbt
    pos.add(vel);
  }

  //-------------------------------------------------------------------------------------------------------------------
  
  void update() { // händer varje frame
    if (!dead && !reachedGoal) { // om inte död eller inte nuddat målet
      move();
      if (pos.x< 2|| pos.y<2 || pos.x>width-2 || pos.y>height -2) { // om pricken slår i kanten, döda pricken
        dead = true;
        
      } else if (dist(pos.x, pos.y, goal.x, goal.y) < 5) { // om nått målet
        reachedGoal = true;
        
      } else if (pos.x< 380 && pos.y < 210 && pos.x > 0 && pos.y > 200) { // om slagit i hinder, döda pricken
        dead = true;
        
      } else if (pos.x< 800 && pos.y < 210 && pos.x > 420 && pos.y > 200) { // om slagit i hinder, döda pricken
        dead = true;
        
      } else if (pos.x < 740 && pos.y < 510 && pos.x > 60 && pos.y > 500) { // om slagit i hinder, döda pricken
        dead = true;
        
      } else if (pos.x < 430 && pos.y < 150 && pos.x > 370 && pos.y > 140) { // om slagit i hinder, döda pricken
        dead = true;
        
      }
    }
  }


  //--------------------------------------------------------------------------------------------------------------------------------------
  
  // räknar ut prickens fitness
  void calculateFitness() {
    if (reachedGoal) { // om pricken nådde målet är fitness baserat på antel steg det tog att nå målet
      fitness = 1.0/16.0 + 10000.0/(float)(brain.step * brain.step);
      
    } else { // om pricken inte nådde målet är fitness baserat på hur nära den är målet
      float distanceToGoal = dist(pos.x, pos.y, goal.x, goal.y);
      fitness = 1.0/(distanceToGoal * distanceToGoal);
    }
  }

  //---------------------------------------------------------------------------------------------------------------------------------------
  
  // klona den
  Dot gimmeBaby() {
    Dot baby = new Dot();
    baby.brain = brain.clone(); // babies har samma hjärna som deras föräldrar
    return baby;
  }
}
