#include <SPI.h>
#include <RFID.h>
#include <Adafruit_Fingerprint.h>
#include <SoftwareSerial.h>

#define SDA_DIO 9
#define RESET_DIO 8

int getFingerprintIDez();
SoftwareSerial mySerial(10, 11);
RFID RC522(SDA_DIO, RESET_DIO); 
int reader=0;
Adafruit_Fingerprint finger = Adafruit_Fingerprint(&mySerial);

void setup()
{ 
  pinMode(13, OUTPUT);
  Serial.begin(9600);
  SPI.begin(); 
  finger.begin(57600);
  if (finger.verifyPassword()) {
  } else {
  }
  RC522.init();
}

void loop()
{
  byte i;
    delay(50);            //don't ned to run this at full speed.
    uint8_t p = finger.getImage();
  if (RC522.isCard())
  {
    digitalWrite(13, HIGH);
    delay(1000);
    RC522.readCardSerial();

    for(i = 0; i <= 2; i++) // iki adet deger alacagımız için 2 dendi 
    {
      Serial.print(RC522.serNum[i],DEC);
    }
    Serial.print(",");
    Serial.print(getFingerprintIDez());
    Serial.println();  
  }
  digitalWrite(13, LOW);
 
}

int getFingerprintIDez() {
  uint8_t p = finger.getImage();

  
  
  if (p != FINGERPRINT_OK)  return 404;

  p = finger.image2Tz();
  
  if (p != FINGERPRINT_OK)  return 404;

  p = finger.fingerFastSearch();
  
  if (p != FINGERPRINT_OK)  return  404;
  

  return finger.fingerID; 
}

uint8_t getFingerprintID() {
  uint8_t p = finger.getImage();
  switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image taken");
      break;
    case FINGERPRINT_NOFINGER:
      Serial.println("No finger detected");
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      return p;
    case FINGERPRINT_IMAGEFAIL:
      Serial.println("Imaging error");
      return p;
    default:
      Serial.println("Unknown error");
      return p;
  }

  // OK success!

  p = finger.image2Tz();
  switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image converted");
      break;
    case FINGERPRINT_IMAGEMESS:
      Serial.println("Image too messy");
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      return p;
    case FINGERPRINT_FEATUREFAIL:
      Serial.println("Could not find fingerprint features");
      return p;
    case FINGERPRINT_INVALIDIMAGE:
      Serial.println("Could not find fingerprint features");
      return p;
    default:
      Serial.println("Unknown error");
      return p;
  }
  
  // OK converted!
  p = finger.fingerFastSearch();
  if (p == FINGERPRINT_OK) {
    Serial.println("Found a print match!");
  } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
    Serial.println("Communication error");
    return p;
  } else if (p == FINGERPRINT_NOTFOUND) {
    Serial.println("Did not find a match");
    return p;
  } else {
    Serial.println("Unknown error");
    return p;
  }   
  
  // found a match!
  Serial.print("Found ID #"); Serial.print(finger.fingerID); 
  Serial.print(" with confidence of "); Serial.println(finger.confidence); 
}

