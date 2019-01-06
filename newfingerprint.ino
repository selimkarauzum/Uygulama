#include <Adafruit_Fingerprint.h>
#include <SoftwareSerial.h>
uint8_t id;
int getFingerprintEnroll();
SoftwareSerial mySerial(10, 11);
Adafruit_Fingerprint finger = Adafruit_Fingerprint(&mySerial);
void setup()  
{
  Serial.begin(9600);
  finger.begin(57600);
}
uint8_t readnumber(void) {
  uint8_t num = 0;
  while (Serial.available()==0);
  num = Serial.parseInt();
  return num;
}
void loop()
{
  Serial.println("Ready to enroll a print! Please type the ID ...");
  id = readnumber();
  Serial.print("Enrolling the ID #");
  Serial.println(id);
  
  while (!  getFingerprintEnroll() );
}
int getFingerprintEnroll() {
  int p = -1;
  Serial.print("Waiting for a valid finger to roll it up as an ID"); Serial.println(id);
  while (p != FINGERPRINT_OK) {
    p = finger.getImage();
    switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image taken");
      break;
    case FINGERPRINT_NOFINGER:
      Serial.println(".");
      break;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      break;
    case FINGERPRINT_IMAGEFAIL:
      Serial.println("Image error");
      break;
    default:
      Serial.println("unknown error");
      break;
    }
  }
  p = finger.image2Tz(1);
  switch (p) {
    case FINGERPRINT_OK:
      Serial.println("The image is converted");
      break;
    case FINGERPRINT_IMAGEMESS:
      Serial.println("Very messy image");
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      return p;
    case FINGERPRINT_FEATUREFAIL:
      Serial.println("Can not find fingerprint features");
      return p;
    case FINGERPRINT_INVALIDIMAGE:
      Serial.println("Can not find fingerprint features");
      return p;
    default:
      Serial.println("unknown error");
      return p;
  }
  Serial.println("Please remove your finger");
  delay(2000);
  p = 0;
  while (p != FINGERPRINT_NOFINGER) {
    p = finger.getImage();
  }
  Serial.print("ID "); Serial.println(id);
  p = -1;
  Serial.println("Place the same finger again"); //finger idsi benzeri varsa  
  while (p != FINGERPRINT_OK) {
    p = finger.getImage();
    switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image taken");
      break;
    case FINGERPRINT_NOFINGER:
      Serial.print(".");
      break;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      break;
    case FINGERPRINT_IMAGEFAIL:
      Serial.println("Image error");
      break;
    default:
      Serial.println("unknown error");
      break;
    }
  }
  p = finger.image2Tz(2); //finger print parmak izi degeri 
  switch (p) {
    case FINGERPRINT_OK:
      Serial.println("The image is converted");
      break;
    case FINGERPRINT_IMAGEMESS:
      Serial.println("Very messy image");
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      return p;
    case FINGERPRINT_FEATUREFAIL:
      Serial.println("Can not find fingerprint features");
      return p;
    case FINGERPRINT_INVALIDIMAGE:
      Serial.println("Can not find fingerprint features");
      return p;
    default:
      Serial.println("unknown error");
      return p;
  }
  
  // OK converted!
  Serial.print("Creating a template for#");  Serial.println(id);
  
  p = finger.createModel();
  if (p == FINGERPRINT_OK) {
    Serial.println("Matched fingerprints!");
  } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
    Serial.println("Communication error");
    return p;
  } else if (p == FINGERPRINT_ENROLLMISMATCH) {
    Serial.println("Footprints are different");
    return p;
  } else {
    Serial.println("unknown error");
    return p;
  }   
  
  Serial.print("ID "); Serial.println(id);
  p = finger.storeModel(id);
  if (p == FINGERPRINT_OK) {
    Serial.println("Record!");
  } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
    Serial.println("Communication error");
    return p;
  } else if (p == FINGERPRINT_BADLOCATION) {
    return p;
  } else if (p == FINGERPRINT_FLASHERR) {
    return p;
  } else {
    Serial.println("unknown error");
    return p;
  }   
}

