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
   socket = new DatagramSocket(5005, InetAddress.getByName("127.0.0.1"));
    }
   catch (Exception se)
  {
    print("fail 1");
  }
  while(true)
  {
    
    if(socket == null)
       continue;
    print("Listening...");
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
    // display response
    
    /* raw work....
    int[] n = new int[62];
    byte[] bytes = packet.getData();//prolly should make a byte list... bleh
    for(int i=0;i<62; i+=1)
    {
      int value = ((bytes[i*4+0] & 0xFF) << 24) | ((bytes[i*4+1] & 0xFF) << 16)
        | ((bytes[i*4+2] & 0xFF) << 8) | (bytes[i*4+3] & 0xFF);
        if(i == 0)
           print(value);
        
    }
    */
    String received = new String(packet.getData(), 0, packet.getLength());
    String[] numbers = received.split(" ");
    print(numbers[0]+"  "+" x:"+numbers[2]+ " y:" + numbers[3] + " z:" + numbers[4]+ "\n");
        
    root_position.x = parseFloat(numbers[2]);
    root_position.y = parseFloat(numbers[3]);
    root_position.z = parseFloat(numbers[3]);
    
    print("nums:"+numbers.length);
  
    int pi = 0;
    for(int i = 2; i<21*3;i+=3)//set all positions
    {
      print(pi);
      print(all_positions.size()+"<-length ");
      try{
        print ("parsing1 " + numbers[i]);
        print ("parsing2 " + numbers[i+1]);
        print ("parsing3 " + numbers[i+2]);
      all_positions.get(pi).x = parseFloat(numbers[i]);
      all_positions.get(pi).y = parseFloat(numbers[i+1]);
      all_positions.get(pi).z = parseFloat(numbers[i+2]);
      pi+=1;
      }
      catch(Exception e)
      {
        print("oh well");
      }
    }
    dancerPositionAlteredEvent();
  }
}
