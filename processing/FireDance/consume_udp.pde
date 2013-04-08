import java.io.*;
import java.net.*;
import java.util.*;


DatagramSocket socket = null;
/*
void setup() {
  size(640, 480);
  smooth();
  
    
   thread("feedMeData");

}*/


void wiiDataThread()
{
  InetAddress address = null;
  try
  {
   socket = new DatagramSocket(wiiPort, InetAddress.getByName("0.0.0.0"));
    }
   catch (Exception se)
  {
    print("fail 1");
  }
  while(true)
  {
    
    if(socket == null)
       continue;
    //print("Listening...");
    
      byte[] buf = new byte[4*62*100];
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
      String received = new String(packet.getData(), 0, packet.getLength());
      String[] numbers = received.split(" ");
//      print(numbers[0]);
      float f = Float.parseFloat(numbers[0]);
      //print(f);
      float smooth = .6;
      accel = accel*smooth+f*(1.0-smooth);
      gotWiiData();
      //print(numbers[0]+"  "+" x:"+numbers[2]+ " y:" + numbers[3] + " z:" + numbers[4]+ "\n");
          
  
    
    
  }
}
