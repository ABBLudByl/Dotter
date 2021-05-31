Population test;
PVector goal  = new PVector(400, 10);


void setup() {
  size(800, 800); // storlek på fönstret
  frameRate(100); // större värde här gör att prickarna rör sig snabbare
  test = new Population(1000); // skapa en ny population med 1000 prickar
  test.createFile(); // skapar en fil (Population rad 172)
}


void draw() { 
  background(255); // gör bakgrunden vit

  // ritar ut ett mål
  fill(255, 0, 0); // gör målet rött
  ellipse(goal.x, goal.y, 10, 10); // målets position + storlek

  // ritar ut hinder
  fill(0, 0, 255); // hinder blir blå

  rect(0, 200, 380, 10); // en rektangel där pos.x = 0, pos.y = 200, längd.x = 380 och längd.y = 10
  rect(800, 200, -380, 10); // se ovan
  rect(740, 500, -680, 10);
  rect(370, 140, 60, 10);


  if (test.allDotsDead()) { // om all prickar är döda
    // själva genetiska algorithmen
    test.calculateFitness(); // Population rad 42
    test.naturalSelection(); // Population rad 66
    test.mutateDemBabies(); // Population rad 123
  } else {
    // om någon av prickarna lever så updatera och visa dem, händer tills alla är döda

    test.update(); // fortsätter att updatera tills alla är döda
    test.show();
  }
}
