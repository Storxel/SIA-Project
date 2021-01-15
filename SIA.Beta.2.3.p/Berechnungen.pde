void prozentCalc() //Berechnet die Prozente der einzelnen Getränke
{
  //durch einen "+" Knopfdruck wird plus[i] um 1 erhöht
  //die Addierung aller plus[i] liefert wie oft alle "+" gedrückt wurden
  //nun kann man ein Prozent durch die Division von plus[i]/zusammen errechnen
  //floor() sorgt dafür, dass alle Prozente zusammen gerechnet kleiner gleich 100% sind
  float zusammen = 0;
  zusammen = plus[0] + plus[1] + plus[2] + plus[3];
  if (zusammen != 0) {
  prozentA = (plus[0] / zusammen)*100;
  prozentA = (float)floor(prozentA * 10) / 10;
  prozentB = (plus[1] / zusammen)*100;
  prozentB = (float)floor(prozentB * 10) / 10;
  prozentC = (plus[2] / zusammen)*100;
  prozentC = (float)floor(prozentC * 10) / 10;
  prozentD = (plus[3] / zusammen)*100;
  prozentD = (float)floor(prozentD * 10) / 10;
  } else if (zusammen == 0) {
  prozentA = 0;
  prozentB = 0;
  prozentC = 0;
  prozentD = 0;
  }
}

void inhaltCalc() //berechnet die länge der Prozent-Anzeige-Segmente
{
  //länge 550
  inhaltA = round(550*(prozentA/100));
  inhaltB = round(550*(prozentB/100));
  inhaltC = round(550*(prozentC/100));
  inhaltD = round(550*(prozentD/100));
}

void preisCalc() //stellt den String des zu zahlenden Preises zusammen
{
  if (schonBezahlt>0.00) {
    //float f = schonBezahlt/100;
    bezahltAnzeige = String.valueOf(schonBezahlt);
  String r = bezahltAnzeige.substring(0,bezahltAnzeige.indexOf('.'));
  if (r.length()==1) {
    bezahltAnzeige = "0,"+"0"+r.substring(0,1);
  } else if (r.length()==2) {
    bezahltAnzeige = "0" + "," + r.substring(0,1) + r.substring(1,2);
  } else if (r.length()==3) {
    bezahltAnzeige = r.substring(0,1)+","+r.substring(1,2)+r.substring(2,3);
  }
  } else {
    bezahltAnzeige = "0,00";
  }
}
