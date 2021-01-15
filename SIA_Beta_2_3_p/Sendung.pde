void sendSerial()
{
  senden ="";
  // Serielle Ausgabe
  String sState = String.valueOf(state); //konvertiert den State(int) in einen String
  
  //überträgt ob ein Becher eingefahren werden soll
  String sCup = "";
  if (insertCup==1) {
    sCup="1";}
  else {
    sCup ="0";}
  
  //es folgen die Prozente
  String sA = ""; 
  String sB = "";
  String sC = "";
  String sD = "";
  
    int pA = int(floor(prozentA));
    int pB = int(floor(prozentB));
    int pC = int(floor(prozentC));
    int pD = int(floor(prozentD));
    if (pA<100){
      sA= "0";
    };
    if (pA<10){
      sA = sA + "0";
    };
    sA = sA + String.valueOf(pA);
    if (pB<100){
      sB= "0";
    };
    if (pB<10){
      sB = sB + "0";
    };
    sB = sB + String.valueOf(pB);
    if (pC<100){
      sC= "0";
    };
    if (pC<10){
      sC = sC + "0";
    };
    sC = sC + String.valueOf(pC);
    if (pD<100){
      sD= "0";
    };
    if (pD<10){
      sD = sD + "0";
    };
    sD = sD + String.valueOf(pD);

  senden ="*" + sState + "," + sCup + "," + sA + "," + sB + "," + sC + "," + sD + "#\n";
  port.write(senden); //sendet die Daten Seriell an den Arduino
  print(senden); //für debug, kein Einfluss auf Arduino
}
