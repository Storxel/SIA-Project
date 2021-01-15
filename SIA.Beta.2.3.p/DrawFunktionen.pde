void drawElements() //Anzeige des Auswahlmenüs
{
  //Darstellung der Prozentleiste
  fill(0, 0, 0); 
  rect(50, 90, 550, 50);
  fill(255, 255, 255);
  rect(50, 90, inhaltA, 50);
  fill(236, 252, 3); 
  rect(50 + inhaltA, 90, inhaltB, 50);
  fill(3, 252, 20); 
  rect(50 + inhaltA + inhaltB, 90, inhaltC, 50);
  fill(3, 252, 244); 
  rect(50 + inhaltA + inhaltB + inhaltC, 90, inhaltD, 50);
  
  //Anzeige des Bechers
  image(imgBecher, 600, 70);
  //Anzeige des Produktnamens
  textFont(font70);
  fill(255, 255, 255);
  text("SHOT BOT", 250, 65);
  
  //der folgende Code schreibt eine Zufällige Liedzeile auf das Display
  fill(255, 255, 255);
  if (ZonedDateTime.now().toInstant().toEpochMilli()-zufallsZeit>=10000) {
    int alteZufallszahl= zufallszahl;
    zufallszahl = (int)(Math.random() * 14) + 1;
    if (alteZufallszahl==zufallszahl) {
      zufallszahl = (int)(Math.random() * 14) + 1;
    }
    zufallsZeit = ZonedDateTime.now().toInstant().toEpochMilli();
  }
  textFont(font25);
  switch(zufallszahl) 
  {
    case 1: 
    text("                  I gotta feeling\nThat tonight's gonna be a good night", 195,390);
    break;
    case 2:
    text("Relax, take it easy", 300,415);
    break;
    case 3:
    text("Der Rhythmus,\nwo ich immer mit muss",270,390);
    break;
    case 4:
    text("I ran so far away", 300,415);
    break;
    case 5:
    text("Love don't come easy", 290,415);
    break;
    case 6:
    text("I just came to say hello",285,415);
    break;
    case 7:
    text("Who wants to live forever",270,415);
    break;
    case 8:
    text("Words are very unnecessary",250,415);
    break;
    case 9:
    text("Should I stay or should I go?",250,415);
    break;
    case 10:
    text("My mind starts spinning round",230,415);
    break;
    case 11:
    text("Ain't nothin' gonna break my stride",205,415);
    break;
    case 12:
    text("       Aber sonst gesund!\nAlles läuft so weit ganz rund", 245,390);
    break;
    case 13:
    text("Those were the best days of my life",205,415);
    break;
    case 14:
    text("Mich führt hier ein Licht durch das All",200,415);
    break;
  }
  
};

void priceList() //gehört zu state 1
{
  //anzeige der Preisliste
  fill(151,255,255);
  textFont(font25);
  text(trinkenA, 40, 245);
  text(trinkenB, 200, 245);
  text(trinkenC, 360, 245);
  text(trinkenD, 510, 245);
};

void drawNoSelection() //Zeigt, dass nichts ausgwählt wurde (im State 1)
{
  //Überlagerung des Hintergrundes
 fill(150,0,150);
 rect(0,0,1900, 1000);
 //Textanzeige im Kasten
 fill(3, 152, 252);
 rect(160, 25, 460,400);
 textFont(font60);
 fill(0);
 text("Sie haben nichts\n    ausgewählt!", 160, 150);
 //Visueller Bestätigungs-Knopf
 fill(255,20,147);
 rect(320, 310,150,100);
 fill(0);
 text("OK", 350, 380);
};

void drawGetCup() //Zeigt Hinweise an bis der Becher in der Maschine ist
{
  background(150, 0 , 150);
  fill(3, 152, 252);
  rect(160, 25, 460,400);
  long sec = floor((ZonedDateTime.now().toInstant().toEpochMilli() - timeMilli)/1000);
  long timer = 20-sec;
  if (timer >0) { 
    textFont(font60);
    fill(0);
    text("Bitte halten Sie\n  einen leeren\nBecher bereit!", 175, 135);
  } else {
    if (insertCup==0) {
      textFont(font60);
      fill(0);
      text("Bitte stellen Sie\nnun den Becher \nauf die Rampe!", 170, 100);
      fill(255,20,147);
      rect(270, 320,250,80);
      fill(0);
      text("Erledigt", 285, 380);
      
    } else if (insertCup ==1) {
      fill(3, 152, 252);
      rect(160, 25, 460,400);
      textFont(font60);
      fill(0);
      text("Ihr Becher wird\n  eingefahren.", 170, 200);
    }
  }
};

void drawPay() //Zeigt den noch zu zahlenden Preis an
{
  background(150, 0 , 150);
  fill(3, 152, 252);
  rect(160, 25, 460,400);
  textFont(font60);
  fill(0);
  text("Bitte werfen Sie:", 160, 120);
  fill(255,0,0);
  text(bezahltAnzeige+" €", 320, 210);
  fill(0);
  text("in 10ct bis 2€\n Münzen ein!", 210, 300);
};

void drawFill() //Anzeige während das Getränk zusammengestellt wird
{
  background(150, 0 , 150);
  fill(3, 152, 252);
  rect(160, 25, 460,400);
  textFont(font50);
  fill(0);
  text("   Ihr Getränk wird\n zusammen gestellt.\n   Bitte warten Sie!", 150, 145);
};


void drawExit() //Anzeige der Entnahme Aufforderung
{
  background(150, 0 , 150);
  fill(3, 152, 252);
  rect(160, 25, 460,400);
  long sec = floor((ZonedDateTime.now().toInstant().toEpochMilli() - timeMilli)/1000);
  long timer = 40-sec;
  if (timer <=6) {
    insertCup=1;
  }
  if (timer >25) {
    textFont(font60);
    fill(0);
    text("Ihr Becher wird\n  ausgefahren.", 170, 200);
  } else if (timer >15 && timer <=25) {
  textFont(font45);
  fill(0);
  text("Bitte entnehmen Sie \n  nun Ihren Becher \n   von der Rampe!", 175, 150);
  } else if (timer <=30 && timer >=0) {
  textFont(font45);
  fill(0);
  text("Bitte entnehmen Sie \n  nun Ihren Becher \n   von der Rampe!", 175, 150);
  textFont(font30);
  fill(0);
  text("Sie haben noch", 175, 370);
  
  fill(255,0,0);
  text(String.valueOf(timer),400,370);
  //println(ZonedDateTime.now().toInstant().toEpochMilli());
  textFont(font30);
  fill(0);
  text("Sekunden!", 440, 370);
  } else if (timer <0) {
  textFont(font45);
  fill(0);
  text("Sie können in kürze\n    neu Bestellen!", 190, 190);
  }
};

void drawPricelist() 
{
  background(150, 0 , 150);
  fill(151,255,255);
  textFont(font60);// ("text", x coordinate, y coordinat)
  text("Preis pro 100ml:", 185, 65);
  text("_____________", 130, 80);
  text(trinkenA + ": 5,50€", 170, 150);
  text(trinkenB + ": 3,60€", 170, 220);
  text(trinkenC + ": 2,80€", 170, 290);
  text(trinkenD + ": 4,00€", 170, 360);
  fill(255,20,147);
  rect(335, 375,120,70);
  fill(0);
  text("OK", 350, 430);
};

void drawError() //Anzeige einer Fehlermeldung
{
  background(150, 0 , 150);
  fill(3, 152, 252);
  rect(160, 25, 460,400);
  textFont(font55);
  fill(0);
  text("  Bitte rufen Sie\neinen Mitarbeiter!", 162, 190);
};
