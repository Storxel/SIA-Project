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
 * Autor: Tobias Martin
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


import controlP5.*; //import ControlP5 library
import processing.serial.*;
import java.time.ZonedDateTime;

long timeMilli;

int zufallszahl= (int)(Math.random() * 14) + 1;;

long zufallsZeit;

Serial port;

//erstellt ControlP5 objekt
ControlP5 cp5; 

//erstellt Schrift objekte
PFont font25,font30,font35,font40,font45,font50,font55,font60,font65,font70,font75;

//Strings mit den Getränke Namen
String trinkenA = "Trinken A"; //"Trinken A";
String trinkenB = "Trinken B"; //"Trinken B";
String trinkenC = "Trinken C"; //"Trinken C";
String trinkenD = "Trinken D"; //"Trinken D";

//Speicher des aktuellen States
int state = 10;

String senden ="";

int insertCup=0;

int toggelExit=0;
int toggelGetCup=0;

int inhaltA =0;
int inhaltB =0;
int inhaltC =0;
int inhaltD =0;

float prozentA = 0;
float prozentB = 0;
float prozentC = 0;
float prozentD = 0;

//für das Becherbild
PImage imgBecher;

int bezahlen = 0;

int[] plus = {0,0,0,0};
int[] kannPlus = {0,0,0,0};

float preis = 0.00;
String kosten = "0,00";
int nixBestellt = 0;
int bestellungAngekommen = 0;

float[] preise = {5.5,3.6,2.8,4};

float schonBezahlt = 0.00;
String bezahltAnzeige ="0,00";


void setup(){ //enspricht dem Arduino void setup() 

  size(800, 450);    //größe des Fensters, (breite, höhe)
  
  zufallsZeit = ZonedDateTime.now().toInstant().toEpochMilli(); //speichert die aktuellen ms

  //printArray(Serial.list());   //zeigt alle verfügbaren Ports an, Debug
  
  
  // lädt das Becher Bild
  imgBecher = loadImage("data/becher_groß.png");
  
  port = new Serial(this, "COM12", 9600); //PC
  //port = new Serial(this, "/dev/ttyACM0", 9600);  //RaspPi
  
  port.bufferUntil('\n');
  
  //erzeugt ein cp5 Objekt für die Buttons
  cp5 = new ControlP5(this);
  
  // eigne Schriftart in vers. größen für die Anzeige
  font25 = createFont("Quicksand Medium", 25);
  font30 = createFont("Quicksand Medium", 30);
  font35 = createFont("Quicksand Medium", 35);
  font40 = createFont("Quicksand Medium", 40);
  font45 = createFont("Quicksand Medium", 45);
  font50 = createFont("Quicksand Medium", 50);
  font55 = createFont("Quicksand Medium", 55);
  font60 = createFont("Quicksand Medium", 60);
  font65 = createFont("Quicksand Medium", 65);
  font70 = createFont("Quicksand Medium", 70);
  font75 = createFont("Quicksand Medium", 75);
  
  
  //erzeugt Buttons
  cp5.addButton("Abbruch")     //"XXX" ist der Name des Button
    .setPosition(10, 10)  // x, y Koordinaten der linken oberen Ecke des Buttons
    .setSize(150, 60)      //(breite, höhe)
    .setFont(font25)       // schriftart und -größe
  ;
  cp5.addButton("Bezahlen")
    .setPosition(640, 380)
    .setSize(150, 60)
    .setFont(font25)
  ;
  cp5.addButton("Preisliste")
    .setPosition(10, 380) 
    .setSize(180, 60)
    .setFont(font25)
  ;
  cp5.setAutoDraw(false); //die Buttons werden nicht automatisch im Fenster plaziert
  
}

void draw(){  //entspricht dem Arduino void loop()
  stateMaschine();
}

void stateMaschine() { // schaltet zwischen den Zustände

  switch (state) {
    //Erklärung der einzelnen Zustände in ihrer function
    case 10: if (nixBestellt==1) //besonderheit: wenn nichts ausgewählt ist
              {
                drawNoSelection();
                break;
              }
            stateSelect();
            break;
    case 20: stateGetCup();
            break;
    //state 21 ist hier in state 20 integriert
    case 40: statePay();
            break;
    case 50: stateFill();
            break;
    case 60: stateExit();
            break;
    //state 61 ist hier in state 60 integriert
    case 80: statePricelist();
            break;
    case 90: stateError();
            break;
    default: stateError(); //bei einem Unerwarteten Wert springt der Fehler State ein
            break;
  };
};
