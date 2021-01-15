void serialEvent(Serial wirdNichtBenutzt) 
{
  try
  {
   String inData = port.readStringUntil('\n'); //liest ankommende Daten bis zum '\n'
   inData = trim(inData);                 // schneidet white space ab (carriage return)
   println(inData);
   if (inData.charAt(0) == '#' && inData.charAt(inData.length()-1) == '*'){          // Prüft nach führendem '#' und '*' am Ende
     inData = inData.substring(1);        // schneidet das '#' ab
     inData = inData.substring(0,inData.length()-1);        // schneidet das '*' ab
    
     int[] data = int(split(inData, ","));
      //print(data[1]);
      //data[0] ist state am Ardu-ino
      if (data[0] ==10 && insertCup==1) {
        state=10;
      } else if (data[0] == 60) {
        state=60;
      } else if (data[0]==40) {
          state=40;}
        else if (data[0] == 90) {
        state=90;}
        
      if (data[1]==1) {
        state=50;
        insertCup=0;
      }
      
      if (data[2]==1) { //reset
        insertCup=0;
      }
      
      
      
      schonBezahlt = (data[3]);
    }
        
     sendSerial();
    
  }
  catch(Exception e)
  {
  }
}
