
import de.bezier.data.sql.*;
import processing.serial.*;
import java.math.BigInteger;
import javax.swing.*; 
import controlP5.*;
import javax.swing.JOptionPane; 
import cc.arduino.*;



MySQL dbconnection,dbconnection2,dbconnection3; // baglantılar 
String s=" ";
long ID;
int token;
 

ControlP5 cp5;

String[] a={"NULL","NULL"}; // serial porttan gelen veriyi tutacak. ilk null rfid num 
long fingernumara ;
int end = 10;    // the number 10 is ASCII for linefeed (end of serial.println), later we will look for this to break up individual messages
String serial,serial1;   // declare a new string called 'serial' . A string is a sequence of characters (data type know as "char")
Serial port ,port1; 
String curr,prev,Name;
PFont f; // fancy font tasarımı
SecondApplet sa;
TreeApplet ba;
PFrame pf;
PFrame2 pf2;
PImage img;
PImage bg ;
boolean validate = false; 
long cardID = 0;
long telephone = 0;
long identity = 0; 
String cardname = " ";
String address = " ";
String email = " ";
String BCity = " ";
String BDate = " ";
String RProvince = " ";
String VolumeNo = " ";
String FamilySerialNo = " ";
String RegisterNo = " ";
String gender = " "; 
String pImage = "";
String date = String.valueOf(day()) +"/"+ String.valueOf(month()) +"/"+ String.valueOf(year());
String termofUse = "1. Any votes registered outside the announced voting times, \n       which will be listed online, will not count."+
"\n2. This is not a competition and there will be no prize."+
"\n3. If, for any reason, the online voting system fails, \n       the vote may be suspended or a contingency plan may \n       be actioned.";

long telephone1 = 0, identity1 = 0,serialNo1=0,serialNo=0; // databaseden gelen card idsi
int isVoted=0,isVoted1=0;
String cardname1 ,address1 ,email1 ,BCity1, BDate1,RProvince1 ,VolumeNo1,FamilySerialNo1,RegisterNo1 ,gender1,pImage1,boxPlace,boxPlace1,boxNo,boxNo1,voteDate,voteDate1,FingerPrintNo,FingerPrintNo1;
String user     = "mustafa2_selim";
String pass     = "123456789";
String database = "mustafa2_selim";
String table    = "data2";
void setup()
{
    size(700,500);
    f=createFont("Arial",24,true);
  dbconnection = new MySQL( this, "cinedia.net", database, user, pass );
  dbconnection.connect();
  dbconnection2 = new MySQL( this, "cinedia.net", database, user, pass );
  dbconnection2.connect();
  
  
  
  port = new Serial(this, Serial.list()[0], 9600); 
  port.clear();  
  serial = port.readStringUntil(end); 
  serial = null; 
  
 
  
  //fancy look 
  background(255); 
  textFont(createFont("Arial ",45,true),45);        
  fill(0,0,0,160);
  text("Please Identify \n    Yourself",200,300);
  
  //terms text section start
  textFont(createFont("Arial Bold",24,true),24); 
  fill(0,0,0,160);
  text("Our Terms:",20,40);
  textFont(createFont("Arial",12,true),12); 
  text(termofUse, 20, 70);
  //terms text section end

  
  //date section start
  textFont(createFont("Arial Italic",14,true),14); 
  fill(0,0,0,160);
  text("Date: "+date,580,40);
  //text section end
  
   text("Version : 01.01",550,470);
  textFont(createFont("Arial",12,true),12); 
  
  pf = new PFrame(width, height);

  frame.setTitle("first window");
  pf.setTitle("Person Information");
  pf.setVisible(false);

  //sa.background(255,0,0,16);
  this.frame.setResizable(false);
  this.pf.setResizable(false);
  
}


void draw() 
{
  while (port.available() > 0)  // eger port kullanılabilirse
  { 
    serial = port.readStringUntil(end);
  }
    if (serial != null) 
    {   
      a = split(serial, ','); // finger numarası aldıgı yer  // serial porttan gelend datayı , ile ikiye ayırıp a diye tanımladığımız array e atıyoruz
      fingernumara =  Long.parseLong(a[1].trim());
      function(); // ana fonksiyon cağırılır
      
      if(validate){ // eğer kullanıcı giriş yaparsa
        textFont(f,25); 
        background(255);      
        text("You are being redirected to the voting system...",50,150);
        delay(1000);
        this.frame.setVisible(false);
      }
      else if(!validate){
        textFont(f,30); 
        background(255);      
        text("You are not allowed to view this page.\n    Please reidentify yourself.",50,150);

         
      }
      
    }

         
       
 
} 

void function()
{
          dbconnection3 = new MySQL( this, "cinedia.net", database, user, pass );
          dbconnection3.connect();
          dbconnection3.query( "SELECT * from data2 " );
      
        
        
        while (dbconnection3.next()) //database e baglandık. Databaseden gelen her satırı sana getiriyorum.
        {
           ID = dbconnection3.getInt("ID");
           identity1 = dbconnection3.getInt("identity");
           Name = dbconnection3.getString("Name");
           address1=dbconnection3.getString("Adress");
           email1=dbconnection3.getString("email");
           gender1=dbconnection3.getString("gender");
           BCity1=dbconnection3.getString("BCity");
           BDate1=dbconnection3.getString("BDate");
           RProvince1=dbconnection3.getString("RProvince");
           VolumeNo1=dbconnection3.getString("VolumeNo");
           FamilySerialNo1=dbconnection3.getString("FamilySerialNo");
           RegisterNo1=dbconnection3.getString("RegisterNo");
           FingerPrintNo1=dbconnection3.getString("FingerPrintNo");
           pImage1=dbconnection3.getString("pImage");
           
            if(a[0].equals(String.valueOf(ID))){ // eğer databasedeki ID ile benim karttan okuttuğum ID eşitse 
              cardID = ID;
              cardname = Name;
              identity=identity1;
              address=address1;
              email=email1;
              gender=gender1;
              BCity=BCity1;
              BDate=BDate1;
              RProvince=RProvince1;
              VolumeNo=VolumeNo1;
              FamilySerialNo=FamilySerialNo1;
              RegisterNo=RegisterNo1;
              FingerPrintNo=FingerPrintNo1;
              pImage = pImage1;
              validate = true; // kullanıcı girişi oldu.
          }              
        }
        
        println(cardID);
        delay(2000);
        dbconnection3.close();
  
}
void votingBox()
{

        dbconnection2.query( "SELECT * from votingbox " );
        //println("Getting all");
        
        
        while (dbconnection2.next()) //database e baglandık. Databaseden gelen her satırı sana getiriyorum.
        {
          long voterID = dbconnection2.getInt("id");
           boxPlace1 = dbconnection2.getString("boxPlace");
           boxNo1 = dbconnection2.getString("boxNo");
           serialNo1=dbconnection2.getInt("serialNo");
           voteDate1=dbconnection2.getString("voteDate");
           isVoted1=dbconnection2.getInt("isVoted");
           
           
            if(a[0].equals(String.valueOf(voterID))){ // eğer databasedeki ID ile benim karttan okuttuğum ID eşitse 
              boxPlace = boxPlace1;
              boxNo=boxNo1;
              serialNo=serialNo1;
              voteDate=voteDate1;
              isVoted=isVoted1;
              
          }              
        }
        
}
int partycnt;
String[][] party()
{
  
  String[][] partyProperties;
        dbconnection = new MySQL( this, "cinedia.net", database, user, pass );
        dbconnection.connect();
       dbconnection.query( "SELECT * from party " );
       partycnt = 0;
       while (dbconnection.next())
        {
          partycnt++;
        }
        partyProperties = new String[partycnt][4];
        dbconnection.query( "SELECT * from party " );
        int i = 0;
        while (dbconnection.next()) //database e baglandık. Databaseden gelen her satırı sana getiriyorum.
        {
           int j = 0;
           String tmp1 = dbconnection.getString("partyName");
           String tmp2 = dbconnection.getString("partyAgent");
           String tmp3 = dbconnection.getString("agentEmail");
           String tmp4 = dbconnection.getString("partyEmblem");
           
           partyProperties[i][j] = tmp1;
           partyProperties[i][j+1] = tmp2;  
           partyProperties[i][j+2] = tmp3;
           partyProperties[i][j+3] = tmp4;
           i++;             
        }

        return partyProperties;
        
}

public class PFrame extends JFrame {
  public PFrame(int width, int height) {
    setBounds(100, 100, 750, 490);
    sa = new SecondApplet();
    add(sa);
    sa.init();
    show();
  }
}

public class PFrame2 extends JFrame {
  public PFrame2(int width, int height) {
    setBounds(100, 100, 1200, 300);
    ba = new TreeApplet();
    add(ba);
    ba.init();
    show();
  }
}



boolean runn = true; // for running one time operation
int thirdRepaint = 0;

public class TreeApplet extends PApplet {
  public void setup() {
     javax.swing.JOptionPane.showMessageDialog ( null, "Please,Put your finger on the device.","Message", javax.swing.JOptionPane.INFORMATION_MESSAGE  );
      size(1200,300);
     smooth(); }
  boolean overRect(int x, int y, int width, int height)  {
      if (mouseX >= x && mouseX <= x+width && 
          mouseY >= y && mouseY <= y+height) {
        return true;
      } else {
        return false;
      }
    }
  boolean click  = true;
  void draw(){
    if(thirdRepaint < 2){
       
      String [][] tmp = party();
      int spaceBetween = 0;
      for(int i = 0;i < partycnt ;i++){
        PImage im = loadImage(tmp[i][3]);
        im.resize(150,150);
        image(im,15+spaceBetween,50);
        spaceBetween = spaceBetween +200;
      }
       spaceBetween = 0;
       textFont(createFont("Arial Bold",12,true),12); 
       fill(0,0,0,160);
       for(int i = 0;i < partycnt ;i++){
        text(tmp[i][1],25+spaceBetween,230);
        spaceBetween = spaceBetween +200;
       }
     
      thirdRepaint++;
    }

  }
  
   void mousePressed(){ // resimlerin aktarıldıgı kısım 

    int contactServerEntry = JOptionPane.showConfirmDialog(null, "Please enter to your fingerprint ", "Please select",JOptionPane.YES_NO_OPTION);        
   // int c = JOptionPane.showConfirmDialog(null,"Okey you have fingerprint"); 

          System.out.println("Finger id "+ a[1]);
          System.out.println("Database id:  "+ FingerPrintNo);
          int var = Integer.parseInt(a[1].trim());
          int var2 = Integer.parseInt(FingerPrintNo.toString().trim());
   if(overRect(15, 50, 165,200) && click){
     if(contactServerEntry==0){
          if(var == var2)
                {   
                  javax.swing.JOptionPane.showMessageDialog ( null, "Your vote has been added.","Message", javax.swing.JOptionPane.INFORMATION_MESSAGE  );
                  System.out.println("Added Votes");
                  dbconnection.query( "UPDATE votes SET CHP=CHP+1 where voteDate='28.08.2020' " );   
                  exit();
                }else  javax.swing.JOptionPane.showMessageDialog ( null, "Error,You put your fingers on the device again.","Message", javax.swing.JOptionPane.INFORMATION_MESSAGE  );
       
       }else if (contactServerEntry==1){
           exit();
         }
       }
     
     else if(overRect(215, 50, 365,200) && click){
        if(contactServerEntry==0){
          System.out.println("Finger id "+ a[1]);
          System.out.println("Database id:  "+ FingerPrintNo);
          if(var == var2)
          {   
            javax.swing.JOptionPane.showMessageDialog ( null, "Your vote has been added.","Message", javax.swing.JOptionPane.INFORMATION_MESSAGE  );
            System.out.println("Added Votes");
              dbconnection.query( "UPDATE votes SET AKP=AKP+1 where voteDate='28.08.2020' " );
            exit();
          }else  javax.swing.JOptionPane.showMessageDialog ( null, "Error,You put your fingers on the device again.","Message", javax.swing.JOptionPane.INFORMATION_MESSAGE  );
         }else if (contactServerEntry==1){
           exit();
         }
     }
     else if(overRect(215, 50, 365,200) && click){
       
       if(contactServerEntry==0){
          System.out.println("Finger id "+ a[1]);
          System.out.println("Database id:  "+ FingerPrintNo);
          if(var == var2)
          {   
            javax.swing.JOptionPane.showMessageDialog ( null, "Your vote has been added.","Message", javax.swing.JOptionPane.INFORMATION_MESSAGE  );
            System.out.println("Added Votes");
              dbconnection.query( "UPDATE votes SET MHP=MHP+1 where voteDate='28.08.2020' " );
            exit();
          }else  javax.swing.JOptionPane.showMessageDialog ( null, "Error,You put your fingers on the device again.","Message", javax.swing.JOptionPane.INFORMATION_MESSAGE  );
         }else if (contactServerEntry==1){
           exit();
         }
     }/*
     else if(overRect(615, 50, 765,200) && click){
        if(contactServerEntry==0){
          System.out.println("Finger id "+ a[1]);
          System.out.println("Database id:  "+ FingerPrintNo);
          int var = Integer.parseInt(String.valueOf(a[1].trim()));
          int var2 = Integer.parseInt(FingerPrintNo.toString());
          if(var == var2)
          {   
            javax.swing.JOptionPane.showMessageDialog ( null, "Your vote has been added.","Message", javax.swing.JOptionPane.INFORMATION_MESSAGE  );
            System.out.println("Added Votes");
              dbconnection.query( "UPDATE votes SET BBP=BBP+1 where voteDate='28.08.2020' " );
            exit();
          }else  javax.swing.JOptionPane.showMessageDialog ( null, "Error,You put your fingers on the device again.","Message", javax.swing.JOptionPane.INFORMATION_MESSAGE  );
         }else if (contactServerEntry==1){
           exit();
         }
     }
     else if(overRect(815, 50, 965,200) && click){
       dbconnection.query( "UPDATE votes SET SP=SP+1 where voteDate='28.08.2020' " );
      exit();
     }
     else if(overRect(1015, 50, 1165,200) && click){
       dbconnection.query( "UPDATE votes SET LDP=LDP+1 where voteDate='28.08.2020' " );
       exit();
     }*/
     
}
  
  void mouseReleased() {
  }
}
public class SecondApplet extends PApplet {
  
  public void setup() {
     size(700,500);
    cp5 = new ControlP5(this);
    cp5.addButton("CONFIRM")
    .setValue(1)
    .setPosition(520,325)
    .setSize(50, 25);
    noStroke();
  } 
  boolean isCloseOn = false;
  boolean flag2 = true;
  boolean isBGOK = false; // 
  int rectX = 520, rectY = 325, rectSize=30;
  void draw() {
    if(!isBGOK){
      background(19, 35, 47,160);
     //bg = loadImage("http://localhost/turk.jpg","jpg");
     //bg.resize(700,500);
     //image(bg,0,0);
     isBGOK = true;
   }
   update(mouseX,mouseY);
   if(isCloseOn && mousePressed && flag2){//uzerine gelindiğinde  tıklandığı anda kapat
     pf.setVisible(false);
     pf2 = new PFrame2(1200, 300);
    pf2.setTitle("Parties");
    pf2.setVisible(true);
    pf2.setResizable(false);
    flag2 = false;
   }votingBox();
    if(validate && runn ){// eğer kullanıcı giriş yapmışşsa ve run ete iznim varsa
    //delay(1000);
    
    
      pf.setVisible(true); // ikinci frame i görünür yaptık.
      runn = false; // bir kere çalıştırma flag i.
      fill(26,177,136,160);
      textFont(createFont("Arial Bold",24,true),24); 
      text("Confirm Your Credential " ,180,60);
      println("Card ID read: "+ cardID);
      textFont(createFont("Arial Bold",24,true),24); 
      text("Voting Information" ,180,300); 
      textFont(createFont("Arial Bold",16,true),16);  
 
      
      fill(255);
      text("Your Name: "  ,50,116);
      text("" +cardname,225,116);
      text("Your Identity Number: " ,50,132);text("" +identity,225,132);
      text("Your Address: " ,50,148);text("" +address,225,148);
      text("Your email: "  ,50,164);text("" +email,225,164);
      text("Your Gender: "  ,50,180);text("" +gender,225,180);
      text("Your Birth City: " ,50,196);text("" +BCity,225,196);
      text("Your Birth Date: " ,50,212);text("" +BDate,225,212);
      text("Register Province: " ,50,228);text("" +RProvince,225,228);
      text("Identitiy Volume No: "  ,50,244);text("" +VolumeNo,225,244);
      text("Family Serial No: " ,50,260);text("" +FamilySerialNo,225,260);
      text("Register No: " ,50,276);text("" +RegisterNo,225,276);
    
      
      text("Box Place : " ,50,326);text("" +boxPlace,160,326);
      text("Box No : " ,50,342);text("" +boxNo,160,342);
      text("Serial No  : " ,250,342);text("" +serialNo,360,342);
      text("Vote Date  : " ,50,358);text("" +voteDate ,160,358);     
      
      img = loadImage(pImage,"jpg");
      img.resize(125,125);
      image(img,520,100);
      delay(600); 
      println(validate);
      delay(200); 
    }
    

  }
  
    void update(int x, int y) {
      if ( overRect(rectX, rectY, rectSize+20, rectSize-5) ) {
        isCloseOn = true;
      }
    }
    
    boolean overRect(int x, int y, int width, int height)  {
      if (mouseX >= x && mouseX <= x+width && 
          mouseY >= y && mouseY <= y+height) {
        return true;
      } else {
        return false;
      }
    }
}











