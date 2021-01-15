  void Abbruch() //wird durch den Knopfdruck auf "Abbruch" aufgerufen
{
  //resetet alle Variablen
  inhaltA =0;
  inhaltB =0;
  inhaltC =0;
  inhaltD =0;

  prozentA = 0;
  prozentB = 0;
  prozentC = 0;
  prozentD = 0;

  preis = 0.00;
  kosten = "0,00";
  
  bezahlen = 0;
  
  
  for (int i=0; i<plus.length; i++) {
    plus[i] =0;
  }
}
