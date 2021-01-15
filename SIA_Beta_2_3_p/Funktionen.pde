void selectContent() 
{
  //Anzeige für die Veränderung der Zusammenmischung
  textFont(font25);
  fill(255, 255, 255);
  if (kannPlus[0] == 0) {
    text(prozentA + "%", 60, 270);
  } 
  
  fill(236, 252, 3);
  if (kannPlus[1] == 0) {
    text(prozentB + "%", 220, 270);
  } 
  
  fill(3, 252, 20); 
  if (kannPlus[2] == 0) {
    text(prozentC + "%", 380, 270);
  } 
  
  fill(3, 252, 244); 
  if (kannPlus[3] == 0) {
    text(prozentD + "%", 530, 270);
  } 
  
  fill(0);
  if (kannPlus[0] == 0) {rect(50,165,80,50);}
  if (kannPlus[1] == 0) {rect(210,165,80,50);}
  if (kannPlus[2] == 0) {rect(370,165,80,50);}
  if (kannPlus[3] == 0) {rect(520,165,80,50);}
    
  if (kannPlus[0] == 0) {rect(50,280,80,50);}
  if (kannPlus[1] == 0) {rect(210,280,80,50);}
  if (kannPlus[2] == 0) {rect(370,280,80,50);}
  if (kannPlus[3] == 0) {rect(520,280,80,50);}
  
  textFont(font45);
  if (kannPlus[0] == 0) {
    fill(255, 255, 255);
    text("+", 77, 205);
    text("-", 82, 318);
  }
  if (kannPlus[1] == 0) {
  fill(236, 252, 3); 
  text("+", 238, 205);
  text("-", 242, 318);
  }
  if (kannPlus[2] == 0) {
    fill(3, 252, 20); 
    text("+", 397, 205);
    text("-", 402, 318);
  }
  if (kannPlus[3] == 0) {
    fill(3, 252, 244);
    text("+", 548, 205);
    text("-", 552, 318);
  }
};

void knopfDruck() 
{
  prozentCalc();
  inhaltCalc();
}

void Bezahlen() //wird durch den Knopfdruck auf "Bezahlen" aufgerufen
{
  preisCalc();
  if ((prozentA==0) &&(prozentB==0) &&(prozentC==0) &&(prozentD==0)) {
    nixBestellt =1;
    return; 
  }
  nixBestellt = 0;
  bezahlen = 1;
  state=20;
}

void Preisliste() //wird durch den Knopfdruck auf "Preisliste" aufgerufen
{
  state = 80;
}
