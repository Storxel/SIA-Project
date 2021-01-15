void stateSelect() //Zustand in dem Ausgewählt wird
{
  background(150, 0 , 150); // background color of window (r, g, b) or (0 to 255)
  toggelExit=0;
  priceList();
  selectContent();
  drawElements();
  knopfDruck();
  cp5.draw();
};

void stateGetCup() //Zustand, der den Becher in die Maschine fährt
{
  if (toggelGetCup==0) {
    timeMilli = ZonedDateTime.now().toInstant().toEpochMilli();
    toggelGetCup=1;
  }
  drawGetCup();
};

void statePay() //Zustand in dem Bezahlt wird
{
  toggelGetCup=0;
  preisCalc();
  drawPay();
};

void stateFill() //Zustand in dem der Becher gefüllt wird
{
  drawFill();
};

void stateExit() //Zustand in dem die Maschine Resetet wird 
//und für den ersten Zustand vorbereitet wird
{
   
  if (toggelExit==0) {
    timeMilli = ZonedDateTime.now().toInstant().toEpochMilli();
    toggelExit=1;
  }
  drawExit();
  Abbruch();
};

void statePricelist() //Zustand in dem die Preisliste angezeigt wird 
//(kein Echter Zustand, Arduino merkt davon nichts)
{
  drawPricelist();
};

void stateError() //Zustand wenn ein Fehler auftritt
{
  drawError();
};
