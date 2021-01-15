# SIA-Project
The project idea for the SIA was to build a beverage vending machine that dispenses shots (drinks with a small filling quantity, mostly alcoholic). The customer 
customer selects on a display which of the four predefined types of beverage 
his drink should consist of. He confirms his selection on the display by 
the message "Pay". The customer is then asked to pick up a prepared 
cup, to which an RFID chip is attached on the underside. The 
The cup is placed on a shelf and recognized by the RFID reader. The 
coins must now be inserted through a coin slot. 
Simultaneously with each inserted coin, the price is updated on the display. 
is updated. Once the price has been paid, the cup is filled.  


 * Brief Description:
 This project lets customers assemble drinks as they wish and dispenses them after payment.

 * Last Update: June 29, 2020
 * Version: see filename
    * a is indicator for Arduino code
    * p is indicator for Processing Code
    
# Informatics
Informatics is composed of the following three software parts: 
* Human Machine Interface 
* Processing of sensors and control of actuators 
* "SIA" Library 

In order to provide the consumer with the best possible experience, we have chosen to use  a Human Machine Interface with a touch display. Since the project will be based on an Arduino, but an appealing HMI with the Arduino with the Arduino is more difficult to implement, the HMI was written in Java and loaded onto a Raspberry Pi 3b+ with the use of the program Processing. The Arduino Sketch and the "SIA" library was written in c++. 

[Arduino Code](https://github.com/storxel/SIA-Project/blob/main/SIA.Beta.2.3.a.ino)

[Code of the Human Machine Interface](https://github.com/storxel/SIA-Project/tree/main/SIA.Beta.2.3.p)

[SIA Library](https://github.com/storxel/SIA-Library)
