import socket
import time
import struct

UDP_IP_TO = "127.0.0.1"
UDP_PORT_TO = 8001
socksend = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)

num = 0
while True:
    print "sending..."
    time.sleep(.02)
    num+=1
    senddata = "/bbd/1/note"+struct.pack('c','\0')+",ffi"+struct.pack('c','\0')+struct.pack('c','\0')+struct.pack('c','\0')+struct.pack('c','\0')+struct.pack('!f',num%127)+struct.pack('!f',40)+struct.pack('i',num%2)
    print senddata
    print senddata.encode("hex")
    socksend.sendto(senddata, (UDP_IP_TO, UDP_PORT_TO))