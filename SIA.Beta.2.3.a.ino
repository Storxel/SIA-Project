/*
 * SIA Projekt "SHOT BOT"
 *
 * Kurzbeschreibung:
 * Dieses Projekt lässt Kunden Getränke nach ihrem Wunsch
 * zusammen stellen und gibt diese nach Bezahlung aus.
 * 
 * Weiterentwicklung (geplant, noch nicht umgesetzt):
 * - automatischer Abbruch nach x sec im Bechereinfahrvorgang
 * - manueller Abbruch im Bechereinfahrvorgang
 * - automatischer Abbruch nach x sec im Bezahlvorgang
 * - manueller Abbruch im Bezahlvorgang
 * - Lichteffekte und Musik während des Bestellvorgangs
 * 
 * Zukunftsvisionen (aktuell nicht umsetzbar):
 * - automatischer Reset der Rampe und des Curtain
 *
 * Autor: Storxel
 * Stand: 29. Juni 2020
 * Version: siehe Dateiname
 *          a ist Kennzeichen für Arduino Code
 *          p ist Kennzeichen für Processing Code
 *
 *
 * ####################################
 * #
 * # Hinweis zu den Kommentaren:
 * # function bezeichnet immer
 * # etwas nach dem folgenden Schema:
 * # void name() {}
 * # functions werden meist erst
 * # in ihrer Definition erklärt
 * #
 * ####################################
 */
 
  #include <SPI.h>
  #include <MFRC522.h>
  #include <Stepper.h>
  #include <Wire.h>
  #include <SIA.h>


  //Project Objekt sia wird erstellt
  // sia(Flußrate float, Bechergröße1 int, Bechergröße2 int, Bechergröße3 int)
  // Flußrate in ml/ms, Bechergröße in ml
  Project sia(0.0018,53,20,150);

  //inString hält das vom RaspPi gesendete Protokoll
  String inString = "";

  //Motor werden erzeugt
  int SPU = 2048; //gibt die Schritte einer Umdrehung an
  Stepper ramp(SPU, 3,5,4,6); //Motor für die Rampe
  Stepper curtain(SPU, 10,12,11,13); //Motor für das Intelligente Glas 
  //Intelligente Glas dient als Vorhang/Spritzschut/Verdeckung, d.h curtain

  //Relays werden erzeugt
  Relay pumpA(22); //Pumpe
  Relay pumpB(23); //Pumpe
  Relay pumpC(24); //Pumpe
  Relay pumpD(25); //Pumpe
  Relay curtainSwitch(26); //Intelligente Glas
  Relay relay6(27); //wird nicht genutzt
  Relay relay7(28); //wird nicht genutzt
  Relay relay8(29); //wird nicht genutzt

  //Lichtschranken werden erzeugt
  // Name besteht aus "barrier" + Münzengröße
  Barrier barrier2(3); //2ct
  Barrier barrier10(4); //10ct
  Barrier barrier20(1); //20ct
  Barrier barrier50(0); //50ct
  Barrier barrier200(2); //2€
  
  //Induktionsmesser wird erzeugt
  Button induktion(8);


  //Zeitspeicher
  unsigned long stepperMillis;

  //Einrichten des RFID-Leser:
  #define SS_PIN          53 //SDA an Pin 53
  #define RST_PIN         9 //RST an Pin 9

  MFRC522 mfrc522(SS_PIN, RST_PIN);  // MFRC522 (≙ RFID Leser) Instanz
  MFRC522::StatusCode status; //Speicher des RFID Status

  byte buffer[18];  //16+2 bytes data+CRC
  byte size = sizeof(buffer);

  uint8_t pageAddr = 0x06;  //Speicher der Seitenaddressen aus denen gelesen werden soll, 16 bytes (Seiten 6,7,8 und 9)
                            //Ultraligth mem = 16 Seiten. 4 bytes pro Seite

void setup()
{
  Serial.begin(9600); // Serielle Verbindung starten für Datenaustausch mit dem RaspPi
  SPI.begin(); // SPI-Verbindung aufbauen
  mfrc522.PCD_Init(); // Initialisierung des RFID-Empfängers

  //Einstellung der Motoren Geschwindigkeit
  ramp.setSpeed(10);
  curtain.setSpeed(10);
}

void loop()
{
  stateMaschine(); 
}

void stateMaschine() // schaltet zwischen den Zustände
{
  send();
  switch (sia.getState()) {
    //Erklärung der einzelnen Zustände in ihrer function
    case 10: stateSelect();break;
    case 20: stateGetCupOut();break;
    case 21: if (sia.getInsertCup()==1) { //Kunde hat am Display das Einstellen eines Bechers bestätigt
              stateGetCupIn();
            }; break;
    case 40: statePay(); break;
    case 50: stateFill();break;
    case 60: stateExitOut();break;
    case 61: if (sia.getInsertCup()==1) { //Zeit zum Becher entnehmen ist abgelaufen
              stateExitIn();
            }; break;
    case 90: stateError();break;
    default: stateError(); break; //bei einem Unerwarteten Wert springt der Fehler State ein
  }
}

//####### State Funktionen #########
void stateSelect() //Zustand während auf dem RaspPi ausgewählt wird
{
  send();
}

void stateGetCupOut() //Zustand, der den Becher in die Maschine fährt
{
  sia.isPaid=0;
  send();
  sia.setNoCup(0);
  curtainMovement(1); //-|
  rampMovement(1);    //-|->fährt die Rampe raus
  
  send();
  sia.setState(21);
}

void stateGetCupIn() //Zustand, der den Becher in die Maschine fährt
{
  send();
  sia.setNoCup(0);
  
  rampMovement(2);    //-|->fährt den Becher rein
  curtainMovement(2); //-|
  delay(500);
  stepperMillis = millis();
  do { //prüft für 0,5 sec ob ein Becher da ist
      if (RFID() == true) { 
      //ist ein Becher da, wird der Bezahlvorgang aktiviert
      sia.setState(40); 
      sia.setNoCup(0);
      }
    } while ((millis()-stepperMillis<500) && sia.getState()==21); 
  if (sia.getState()==21) {
      //es wurde kein Becher erkannt,
      //meldet dem RaspPi, dass kein Becher eingestellt wurde
      sia.setNoCup(1);
      sia.setState(20); 
      }
  send();
}

void statePay() //Zustand in dem Bezahlt wird
{
  Serial.print("Bechergröße:");
  Serial.println(sia.getCupSize());
  Serial.print("ProzentB:");
  Serial.println(sia.getPct('B'));
  send();
  //curtainSwitch.timeControll(100); //Schaltet das Intelligente Glas klar
  payment(sia.priceCalc()); ////start des Bezahlvorgangs mit dem zuzahlenden Preis
  send();
}

void stateFill() //Zustand in dem der Becher gefüllt wird
{
  sia.setPaid(0);
  sia.isPaid=0;
  fill(); //füllt den Becher
  sia.setState(60);
  send();
}

void stateExitOut() //Zustand in dem die Maschine Resetet wird 
//und für den ersten Zustand vorbereitet wird
{
  if (sia.getEndFill()==1) {
  //curtainSwitch.timeControll(100); //Schaltet das Intelligente Glas trüb
  curtainMovement(1); //-|
  rampMovement(1);    //-|->fährt den Becher raus
  curtainMovement(2); //-|
  }
  sia.setPaid(0);
  sia.setEndFill(0);
  bool b = RFID(); //Reset der Chip/Becher Daten im sia Objekt
  sia.setState(61);
}

void stateExitIn() //Zustand in dem die Maschine Resetet wird 
//und für den ersten Zustand vorbereitet wird
{
  curtainMovement(1); //-|
  rampMovement(2);    //-|->fährt den Becher rein
  curtainMovement(2); //-|
  sia.setState(10);
  sia.setNoCup(1);
  send();
}

void stateError() //Zustand wenn ein Fehler auftritt
{
  send();
}

//####### Funktionen für den Ablauf #########

bool RFID() {
    String input="";
  // Look for new cards
  if ( ! mfrc522.PICC_IsNewCardPresent())
    return false;

  // Select one of the cards
  if ( ! mfrc522.PICC_ReadCardSerial())
    return false;


  // Write data ***********************************************

  /*
  for (int i=0; i < 4; i++) {
    //data is writen in blocks of 4 bytes (4 bytes per page)
    status = (MFRC522::StatusCode) mfrc522.MIFARE_Ultralight_Write(pageAddr+i, &buffer[i*4], 4);
    if (status != MFRC522::STATUS_OK) {
      Serial.print(F("MIFARE_Read() failed: "));
      Serial.println(mfrc522.GetStatusCodeName(status));
      return;
    }
  }
  Serial.println(F("MIFARE_Ultralight_Write() OK "));
  Serial.println();



  */
  // Read data ***************************************************
  //Serial.println(F("Reading data ... "));
  //data in 4 block is readed at once.
  status = (MFRC522::StatusCode) mfrc522.MIFARE_Read(pageAddr, buffer, &size);
  if (status != MFRC522::STATUS_OK) {
    Serial.print(F("MIFARE_Read() failed: "));
    Serial.println(mfrc522.GetStatusCodeName(status));
    return false;
  }

  //Serial.print(F("Readed data: "));
  //Dump a byte array to Serial
  for (byte i = 0; i < 16; i++) {
    //Serial.write(buffer[i]);
    input += (char)buffer[i];
  }
  if (input.substring(0,1) == "K") {
    input="";
    sia.setCupSize(1);
    Serial.println("1 Buchstabe ist ein \"K\"");
  } else if (input.substring(0,1) == "M") {
    Serial.println("1 Buchstabe ist ein \"M\"");
    input="";
    sia.setCupSize(2);
  } else if (input.substring(0,1) == "G") {
    Serial.println("1 Buchstabe ist ein \"G\"");
    input="";
  } else if (input.substring(0,1) == "H") {
    Serial.println("1 Buchstabe ist ein \"H\"");
    sia.setCupSize(0);
  } else {
    input="";
    sia.setCupSize(0);
  }

  mfrc522.PICC_HaltA();
  return true;
}

void send() 
{           
  /*Sendet das Protokoll an den RaspPi
   * Protokoll: #Z,Z,ZZZ*
   *            || | |
   *            || | |
   *            || | |->Preis der gezahlt werden muss in ct
   *            || |->aktueller Status des Arduinos, 1-7
   *            ||->wurde Bezahlt, ja-1, nein-0
   *            |->Prüfzeichen
   *                
   */
   String paid="";
   if (sia.getState()==40) {
    float h = 100.00;
    int i = (sia.getPaid()*h); //1,22*100 == 122
    int z = (sia.getPrice()*h); //1,22*100 == 122
    int u = (z-i);
    if (u>0) {
      paid = String(u);
    } else {
      paid = "000";
    } 
   } else {
    paid = "000";
   }
   //sFull fügt das Protokoll zusammen:
  String sFull = "#" + String(sia.getState()) + "," + sia.numbToString(sia.isPaid)
                     + "," + String(sia.getNoCup()) + "," + paid + "*";                     
  Serial.println(sFull); //paid ist bereits ein String, wird daher erst jetzt angehängt
  
  receive();

}

void receive()  //Empfängt das Protokoll vom RaspPi
{               
  /*Empfängt das Protokoll vom RaspPi
   *  Protokoll: * Z,Z,ZZZ,ZZZ,ZZZ,ZZZ #
   *             | | | |   |   |   |   |
   *             | | | |   |   |   |   |->Prüfzeichen
   *             | | | |   |   |   |->Prozent D 0-100
   *             | | | |   |   |->Prozent C 0-100
   *             | | | |   |->Prozent B 0-100
   *             | | | |->Prozent A 0-100
   *             | | |->soll ein Becher eingefahren werden 0-2
   *             | |->aktueller des RaspPis 1-7
   *             |->Prüfzeichen
   */
  if (Serial.available() > 0) { //prüft ob Daten ankommen
  while(Serial.available()) {
  inString = Serial.readStringUntil('\n');// liest ankommende Daten als String ein
  //checkt die Prüfenzeichen
  if ((inString.substring(0,1) == "*") && (inString.substring(inString.length()-1,inString.length()) == "#")) {  
    //entfernt die Prüfenzeichen
    inString.remove(0,1);
    inString.remove(inString.length()-1,inString.length());

    for (int i=0; i<inString.length(); i++) {
      if (sia.getStringPart(inString, ',', i)==NULL) {
       break;
      } else if (sia.getStringPart(inString, ',', i)!=NULL) {
      int a = sia.getStringPart(inString, ',', i).toInt();
      switch(i) {
        case 0: // Sync der Zustände
          if ((a==20) && (sia.getState()==10)) {
            sia.setState(20);
          } else if ((a==50) && (sia.getEndFill() == 0)) {
            sia.setState(50);
          } else if (a==90) { 
            sia.setState(90);}
          break;
        case 1: 
          if (a==1) {
            sia.setInsertCup(1);
          } else {
            sia.setInsertCup(0);}
          break;
        case 2: 
          sia.setPct('A',a);
          break;
        case 3: 
          sia.setPct('B',a);
          break;
        case 4: 
          sia.setPct('C',a);
          break;
        case 5: 
          sia.setPct('D',a);
          break;
      }
     }
    }
   }
  }
 }
}

void payment(float p) //kümmert sich um den Bezahlvorgang
{
  send();
  do { //start des Bezahlvorgangs
   if (!induktion.isPressed()) { //prüfung ob ein Metallobjekt erkannt wurde
    //Serial.println("Münze eingeworfen");
    bool z = true;
    long n = millis();
    do { //Prüft ob eine Lichtschranke etwas erkannt hat
      if (barrier2.interrupt())
      {
        sia.addPaid(0.02);
        //Serial.println(p-sia.getPaid());
        z = false;
        send();
      }
      if (barrier10.interrupt())
      {
        sia.addPaid(0.1);
        //Serial.println(p-sia.getPaid());
        z = false;
        send();
      }
      if (barrier20.interrupt())
      {
        sia.addPaid(0.2);
        //Serial.println(p-sia.getPaid());
        z = false;
        send();
      }
      if (barrier50.interrupt())
      {
        sia.addPaid(0.5);
        //Serial.println(p-sia.getPaid());
        z = false;
        send();
      }
      if (barrier200.interrupt())
      {
        sia.addPaid(2.00);
        //Serial.println(p-sia.getPaid());
        z = false;
        send(); 
      } //Lichtschrankenprüfung bricht nach 2sec oder erkannten Objekt ab 
     } while (((millis()-n)<2500) && z);
    };
    //der Bezahlvorgang bricht nach erfolgreicher Zahlung oder 30sec ab
  } while((p-sia.getPaid()>0));
    sia.isPaid=1;
    sia.setState(50);
    sia.setPaid(0);
    send();
}

void fill() //füllt den Becher
{
  send();
  // 'A' entspricht prozentA usw.
  // pctTimeCalc(char p) berechnet die benögte Zeit zum befüllen und gibt diese zurück
  // timeControll(int t) macht ein Relay für t ms an
  pumpA.timeControll(sia.pctTimeCalc('A'));
  pumpB.timeControll(sia.pctTimeCalc('B'));
  pumpC.timeControll(sia.pctTimeCalc('C'));
  pumpD.timeControll(sia.pctTimeCalc('D'));
  sia.setEndFill(1);
}

void rampMovement(int z) //bewegt die Rampe
{
    switch (z) {
    case 1: ramp.step(+3500);break; //raus aus die Maschine
    case 2: ramp.step(-3500);break; //rein in der Maschine
    default: break;
    }
}

void curtainMovement(int z) //bewegt das Intelligente Glas
{
    switch (z) {
    case 1: curtain.step(+3300);break; //nach oben
    case 2: curtain.step(-3300);break; //nach unten
    default: break;
    }
}
