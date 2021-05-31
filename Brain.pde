class Brain {
  PVector[] directions;// en serie med vektorer som får pricken till målet (förhoppningsvis)
  int step = 0;// en variabel som bestämmer ur många vektorändringar en prick får ta


  Brain(int size) { // skapar och sätter in vektorer i directions
    directions = new PVector[size];
    randomize();
  }

  //--------------------------------------------------------------------------------------------------------------------------------
  
  // sätter alla vektorer i directions till en random vektor med längden 1
  void randomize() {
    for (int i = 0; i< directions.length; i++) {
      float randomAngle = random(2*PI);
      directions[i] = PVector.fromAngle(randomAngle);
    }
  }

  //-------------------------------------------------------------------------------------------------------------------------------------
  
  // retunerar en perfekt klon av brain objektet
  Brain clone() {
    Brain clone = new Brain(directions.length);
    for (int i = 0; i < directions.length; i++) {
      clone.directions[i] = directions[i].copy();
    }

    return clone;
  }

  //----------------------------------------------------------------------------------------------------------------------------------------

  // muterar hjärnan genom att sätta några directions till random vektorer
  void mutate() {
    float mutationRate = 0.01; // chansen att en vektor i directions ändras
    for (int i =0; i< directions.length; i++) {
      float rand = random(1);
      
      if (rand < mutationRate) {
        // sätter denna direction till en random direktion.
        float randomAngle = random(2*PI);
        directions[i] = PVector.fromAngle(randomAngle);
      }
    }
  }
}
