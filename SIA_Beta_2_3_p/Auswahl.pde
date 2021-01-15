void mousePressed() //wird bei einem Mausdruck/Touch aufgerufen
{
  if (mouseButton == LEFT) {
    if (state==10) {
      //Änderung des Mischverhältnis
      // Mehr:
      if ((bezahlen== 0) && (bestellungAngekommen==0)) {
        if ((mouseY>165)&&(mouseY<215)){
          if (((mouseX>50)&&(mouseX<130)) && kannPlus[0] == 0) {
            plus[0] +=1;
          } else if (((mouseX>210)&&(mouseX<290)) && kannPlus[1] == 0) {
            plus[1] +=1;
          } else if (((mouseX>370)&&(mouseX<450)) && kannPlus[2] == 0) {
            plus[2] +=1;
          } else if (((mouseX>520)&&(mouseX<600)) && kannPlus[3] == 0) {
            plus[3] +=1;
          }
        
      } 
      //  weniger
        else if ((mouseY>280)&&(mouseY<330)){
          if (((mouseX>50)&&(mouseX<130)) && kannPlus[0] == 0) {
            if (plus[0] >0) plus[0] -=1;
          } else if (((mouseX>210)&&(mouseX<290)) && kannPlus[1] == 0) {
            if (plus[1] >0) plus[1] -=1;
          } else if (((mouseX>370)&&(mouseX<450)) && kannPlus[2] == 0) {
            if (plus[2] >0) plus[2] -=1;
          } else if (((mouseX>520)&&(mouseX<600)) && kannPlus[3] == 0) {
            if (plus[3] >0) plus[3] -=1;
          }        
        }
      }
      //rest des "nichts ausgewählt" Dialogs
      if ((mouseY>310)&&(mouseY<410)){
              if ((mouseX>320)&&(mouseX<470)) {
                nixBestellt = 0;
              }
            }
        knopfDruck();
    }
   else if (state==80) {
     //zurück von der Preisliste zur Auswahl
     if ((mouseY>375)&&(mouseY<445)){
          if ((mouseX>335)&&(mouseX<455)) {
            state=10;
          }
      }
    }
    else if (state==20 && insertCup==0) {
      //Bestätigung, dass ein Becher eingestellt wurde
     if ((mouseY>320)&&(mouseY<400)){
          if ((mouseX>270)&&(mouseX<520)) {
            insertCup=1;
            //sendSerial();
            //print("Success!");
          }
      }
    }
  }
}
