//Processing sonification via OSC midi messages using OSCulator as a bridge
import java.io.*;
import java.net.*;
import java.nio.ByteBuffer;
import java.lang.Math;

String send_osc_to_address = "127.0.0.1";
int send_osc_to_port = 8001;
float wee_level = 0;
float midi_note = 0;
float midi_velocity = 0;
boolean midi_on = false;

float midi_speed = 1;

 
 String bytArrayToHex(byte[] a) {
   StringBuilder sb = new StringBuilder();
   for(byte b: a)
      sb.append(String.format("%02x", b&0xff));
   return sb.toString();
}
 
 


 
 //If midi message, first two params should be ints that are 0-127
 byte[] oscMidiMessage(String threeLetterId, float pitch,float velocity, boolean on)
 {
   byte[] ret = null;
   ByteBuffer buffer = ByteBuffer.allocate(32);//bytes.length);
   
   buffer.put(("/"+threeLetterId+"/1/note\0,ffi\0\0\0\0").getBytes());
   buffer.putFloat((float)pitch);
   buffer.putFloat((float)velocity);
   int ison = 1;
   if(on) ison = 0;
   buffer.putInt(ison);
   ret = buffer.array();

   println(bytArrayToHex(ret));
   return ret;
 }
 //
 void midiPush()
 {
   DatagramSocket clientSocket = null;
   InetAddress address = null; 
   try{
    clientSocket = new DatagramSocket();
    address = InetAddress.getByName(send_osc_to_address);
   }
   catch(Exception e)
   {
     println("cant make host!");
   }
   
   

   int k = 0;
   while(true)
   {
     byte[] sendData = new byte[1024];
     DatagramPacket sendPacket = null;
     try
     {
       float midi_note_sticky = midi_note;
       float midi_note_velocity = midi_velocity;
       sendData = oscMidiMessage("bbd",midi_note,midi_velocity,midi_on);// sentence.getBytes();
       sendPacket = new DatagramPacket(sendData, sendData.length, address, send_osc_to_port);
       clientSocket.send(sendPacket);
       
       
       sendData = oscMidiMessage("wee",wee_level,0.0,false);// sentence.getBytes();
       sendPacket = new DatagramPacket(sendData, sendData.length, address, send_osc_to_port);
       clientSocket.send(sendPacket);       
       Thread.sleep((long)(midi_speed*200+20));
       
       sendData = oscMidiMessage("bbd",midi_note_sticky,midi_note_velocity,false);// sentence.getBytes();
       sendPacket = new DatagramPacket(sendData, sendData.length, address, send_osc_to_port);
       clientSocket.send(sendPacket);
       
       Thread.sleep((long)(midi_speed*200+20));
       //Thread.sleep(5);
     }
     catch(Exception e)
     {
       println("No sleep for you!");
     }
     
     
   
    // println(k);
     k+=1;
   }
 }
