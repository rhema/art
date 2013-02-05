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
    byte[] buf = new byte[256];
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
    String received = new String(packet.getData(), 0, packet.getLength());
    System.out.println("data: " + received);     
  }
}

void draw() {
  background(100,100,100);
}

 

class QuoteClient {
     void blerp(String[] args) throws IOException {
        if (args.length != 1) {
             System.out.println("Usage: java QuoteClient <hostname>");
             return;
        }
            // get a datagram socket
        DatagramSocket socket = new DatagramSocket();
 
            // send request
        byte[] buf = new byte[256];
        InetAddress address = InetAddress.getByName(args[0]);
        DatagramPacket packet = new DatagramPacket(buf, buf.length, address, 4445);
        socket.send(packet);
    }
}
