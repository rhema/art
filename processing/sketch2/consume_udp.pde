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


void feedMeData()
{
  InetAddress address = null;
  try
  {
   socket = new DatagramSocket(incomingPort, InetAddress.getByName("0.0.0.0"));
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
    if(!useBinary)
    {
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
      //print(numbers[0]+"  "+" x:"+numbers[2]+ " y:" + numbers[3] + " z:" + numbers[4]+ "\n");
          
      root_position.x = parseFloat(numbers[2]);
      root_position.y = parseFloat(numbers[3]);
      root_position.z = parseFloat(numbers[4]);
      
      //print("nums:"+numbers.length);
    
      int pi = 0;
      for(int i = 2; i<21*3;i+=3)//set all positions
      {
  //      print(pi);
  //      print(all_positions.size()+"<-length ");
        try{
  //        print ("parsing1 " + numbers[i]);
  //        print ("parsing2 " + numbers[i+1]);
  //        print ("parsing3 " + numbers[i+2]);
        all_positions.get(pi).x = parseFloat(numbers[i]);
        all_positions.get(pi).y = parseFloat(numbers[i+1]);
        all_positions.get(pi).z = parseFloat(numbers[i+2]);
        pi+=1;
        }
        catch(Exception e)
        {
          print("something broke...");
        }
      }
    }
    else//binary
    {
      byte[] buf = new byte[4*62];//4 bytes 62 numbers?,//248 bytes per frame..checks out 
      int[] n = new int[62];
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
      byte[] bytes = packet.getData();//prolly should make a byte list... bleh
      
      
      StringBuilder sb = new StringBuilder();
      for (byte b : bytes) {
          sb.append(String.format("%02X ", b));
      }
      //System.out.println(sb.toString());
      
      //print("vals  ");
      for(int i=0;i<62; i+=1)
      {
        int value = ((bytes[i*4+3] & 0xFF) << 24) | ((bytes[i*4+2] & 0xFF) << 16) | ((bytes[i*4+1] & 0xFF) << 8) | (bytes[i*4+0] & 0xFF);
          if(i >= 0)
          {
             //print("  ");
             //print(value);
          }
          n[i] = value;
      }
      root_position.x = .001*n[2];
      root_position.y = .001*n[3];
      root_position.z = .001*n[4];
      int pi=0;
      for(int i = 2; i<20*3;i+=3)//set all positions
      {
        all_positions.get(pi).x = .001*n[i];
        all_positions.get(pi).y = .001*n[i+1];
        all_positions.get(pi).z = .001*n[i+2];
        pi+=1;
      }
      
      //set all positions..
      
    }
    dancerPositionAlteredEvent();
  }
}
