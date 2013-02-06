import java.io.*;
import java.net.*;
import java.util.*;
 
 

DatagramSocket socket = null;

void setup() {
  size(640, 480);
  smooth();
  InetAddress address = null;
  try
  {
   socket = new DatagramSocket(5005, InetAddress.getByName("127.0.0.1"));
    }
   catch (Exception se)
  {
    print("fail 1");
  }
    
   thread("feedMeData");

}

void feedMeData()
{
  while(true)
  {
    if(socket == null)
       continue;
    print("Listening...");
    byte[] buf = new byte[4*62];
    DatagramPacket packet = new DatagramPacket(buf, buf.length);
    try
    {
     socket.receive(packet);
    }
    catch (Exception e)
    {
      print("fail 2");
      e.printStackTrace();
    } 
    // display response
    int[] n = new int[62];
    byte[] bytes = packet.getData();//prolly should make a byte list... bleh
    for(int i=0;i<62; i+=1)
    {
      int value = ((bytes[i*4+0] & 0xFF) << 24) | ((bytes[i*4+1] & 0xFF) << 16)
        | ((bytes[i*4+2] & 0xFF) << 8) | (bytes[i*4+3] & 0xFF);
        if(i == 0)
           print(value);
        
    }
    //String received = new String(packet.getData(), 0, packet.getLength());
    
    //System.out.println("data: " + received);
        
  }
}

void draw() {
  background(100,100,100);
}

