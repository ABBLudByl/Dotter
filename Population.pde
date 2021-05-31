import java.io.FileWriter;   // Import the FileWriter class //<>//
import java.io.IOException;  // Import the IOException class to handle errors

class Population {
  Dot[] dots;
  
  Brain brain;

  float fitnessSum; // rad 92
  
  int gen = 1; // antal generationer den gått igenom

  int bestDot = 0; // index av bästa pricken i dots[]

  int minStep = 600; // antal steg en prick max får ta (rad 141) 

  Population(int size) {
    dots = new Dot[size];
    for (int i = 0; i< size; i++) {
      dots[i] = new Dot();
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------
  
  // visa alla prickar på skärmen
  void show() {
    for (int i = 1; i< dots.length; i++) {
      dots[i].show();
    }
    dots[0].show();
  }

  //-------------------------------------------------------------------------------------------------------------------------------
  
  // updatera alla prickar
  void update() {
    for (int i = 0; i< dots.length; i++) {
      if (dots[i].brain.step > minStep) { // om pricken har tagit mer steg än den bästa pricken tog att nå målet
        dots[i].dead = true; // då dör den
      } else {
        dots[i].update();
      }
    }
  }

  //-----------------------------------------------------------------------------------------------------------------------------------
  
  // räknar ut fitness för alla prickar
  void calculateFitness() {
    for (int i = 0; i< dots.length; i++) {
      dots[i].calculateFitness();
    }
  }


  //------------------------------------------------------------------------------------------------------------------------------------
  
  // returnerar true om alla prickar är döda eller nått målet
  boolean allDotsDead() {
    for (int i = 0; i< dots.length; i++) {
      if (!dots[i].dead && !dots[i].reachedGoal) { 
        return false;
      }
    }

    return true;
  }

  //-------------------------------------------------------------------------------------------------------------------------------------

  // skapar nästa generation av prickar
  void naturalSelection() {
    Dot[] newDots = new Dot[dots.length]; // nästa generation
    setBestDot(); // rad 133
    calculateFitnessSum(); // rad 98

    // vinnaren lever vidare
    newDots[0] = dots[bestDot].gimmeBaby();
    newDots[0].isBest = true;
    
    for (int i = 1; i< newDots.length; i++) {
      // välj en förälder baserat på fitness
      Dot parent = selectParent(); // rad 108

      // skapa en bäbis med de utvalda föräldrarna
      newDots[i] = parent.gimmeBaby();
    }

    dots = newDots.clone();
    gen ++;
  }


  //--------------------------------------------------------------------------------------------------------------------------------------
  
  // räknar ut summan av fitness
  void calculateFitnessSum() {
    fitnessSum = 0;
    for (int i = 0; i< dots.length; i++) {
      fitnessSum += dots[i].fitness;
    }
  }

  //-------------------------------------------------------------------------------------------------------------------------------------

  // väljer en prick från populationen utifrån en random fitness
  Dot selectParent() {
    float rand = random(fitnessSum); // väljer ett random nummer mellan 0 och fitnessSum

    float runningSum = 0;

    for (int i = 0; i< dots.length; i++) { // går igenom alla prickar och lägger fitness för den pricken till runningSum, om runningSum är större en rand, är den pricken vald
      runningSum+= dots[i].fitness;
      if (runningSum > rand) {
        return dots[i]; // eftersom prickar med högre fitness lägger till mer till runingSum har de en högre chans att bli valda
      }
    }
    
    return null;
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  
  // muterar hjärnorna på alla bäbisar
  void mutateDemBabies() {
    for (int i = 1; i< dots.length; i++) {
      dots[i].brain.mutate();
    }
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------
  
  // sätter pricken med högst fitness och gär den till bestDot
  void setBestDot() {
    float max = 0;
    int maxIndex = 0;
    for (int i = 0; i< dots.length; i++) {
      if (dots[i].fitness > max) {
        max = dots[i].fitness;
        maxIndex = i;
      }
    }

    bestDot = maxIndex;

    // om denna bestDot har nått målet, ändra minStep till antalet steg det tog för pricken att nå målet
    if (dots[bestDot].reachedGoal) {
      minStep = dots[bestDot].brain.step;
      println("step:", minStep); // printar värdet på minStep så man kan se hur det blir mindre efter varje ny generation
      if (minStep < 400) {
        String dir = "";
        String dir2 = "";
        for (int i = 0; i< dots[bestDot].brain.directions.length; i++) {
          dir = dir2;
          dir2 = dir + dots[bestDot].brain.directions[i].toString() +" "+minStep+ "\n";
        }
        write(dir);
      }
    }
  }
  
  //---------------------------------------------------------------------------------------------------------------------------------------------
  
  void write(String x) {
    try {
      FileWriter myWriter = new FileWriter("../BigBrain.txt");
      myWriter.write(x);
      myWriter.close();
      System.out.println("Successfully wrote to the file.");
    } catch (IOException e) {
      System.out.println("An error occurred.");
      e.printStackTrace();
    }
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------
  
  void createFile() {
    try {
      File myObj = new File("../BigBrain.txt");
      if (myObj.createNewFile()) {
        System.out.println("File created: " + myObj.getName());
      } else {
        System.out.println("File already exists.");
      }
    } catch (IOException e) {
      System.out.println("An error occurred.");
      e.printStackTrace();
    }
  }
}
