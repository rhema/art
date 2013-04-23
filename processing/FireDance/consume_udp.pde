import java.io.*;
import java.net.*;
import java.util.*;


DatagramSocket socket = null;

DatagramSocket socket2 = null;

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
    println("getting socket");
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
    
      byte[] buf = new byte[100];
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
      float smooth = .7;
      accel = accel*smooth+f*(1.0-smooth);
      
      if(numbers.length > 3)
      {
        if(pAccel == null)
        {
          pAccel = new PVector(0,0,0);
          pAccelAverage = new PVector(.5,.5,.5);
        }
        f = Float.parseFloat(numbers[1]);
        pAccel.x = f;//pAccel.x*smooth+f*(1.0-smooth);
        
        f = Float.parseFloat(numbers[2]);
        pAccel.y = f;// pAccel.y*smooth+f*(1.0-smooth);
        
        f = Float.parseFloat(numbers[3]);
        pAccel.z = f;// pAccel.z*smooth+f*(1.0-smooth);
      }
      
      gotWiiData();
      //print(numbers[0]+"  "+" x:"+numbers[2]+ " y:" + numbers[3] + " z:" + numbers[4]+ "\n");
  }
}



void cameraSensorDataThread()
{
  InetAddress address = null;
  try
  {
   socket2 = new DatagramSocket(cameraSensorPort, InetAddress.getByName("0.0.0.0"));
    }
   catch (Exception se)
  {
    print("fail 1");
  }
  while(true)
  {
    
    if(socket2 == null)
       continue;
    //print("Listening...");
    
      byte[] buf = new byte[1000];
      DatagramPacket packet = new DatagramPacket(buf, buf.length);
      //println("can I has data?");
      try
      {
       socket2.receive(packet);
      }
      catch (Exception e)
      {
        print("fail 2");
        e.printStackTrace();
      } 
      //println("Did I has data?");
      String received = new String(packet.getData(), 0, packet.getLength());
      String[] numbers = received.split(" ");
      //println("First num!!"+numbers[0]);
      int ws = Integer.parseInt(numbers[0]);
      if(windowSize != ws)//Init or reset crowdSquares
      {
        windowSize = ws;
        crowdSquares = new Vector<Float>();
        for(int i=0; i<windowSize*windowSize; i++)
        {
          crowdSquares.add(new Float(0));
        }
      }
      
      //set all of the values...
      int index = 0;
      for(String num:numbers)
      {
        if(index == 0)
        {
          index+=1;
          continue;
        }
        float parsedFloat = Float.parseFloat(num);
        //CHECK FOR INFIN HERE...
        //Set min max et cetera
        if(parsedFloat < min_thresh)
          parsedFloat = 0;
        parsedFloat = sensor_scale*parsedFloat;
        crowdSquares.set(index-1, crowdSquares.get(index-1)*.5 +  parsedFloat*.5);
        index+=1;
        if(index == windowSize*windowSize)
          break;
      }
     
      gotCameraSensorData();     
      
      //float f = Float.parseFloat(numbers[0]);
      //float smooth = .6;
      //accel = accel*smooth+f*(1.0-smooth);
      //gotWiiData();
  }
}
