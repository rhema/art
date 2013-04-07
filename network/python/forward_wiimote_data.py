s = "/wii/1/accel/"

import socket
import struct
import math
UDP_IP = "127.0.0.1"
UDP_PORT = 9000



sock = socket.socket(socket.AF_INET, # Internet
                     socket.SOCK_DGRAM) # UDP
sock.bind((UDP_IP, UDP_PORT))

UDP_IP_TO = "127.0.0.1"
UDP_PORT_TO = 9010
socksend = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)

numero = 0
numero_poll = 1
somesome = 0

#3e:fe:e0:cf:3f:09:4b:35:3e:d3:0a:4d
print "here"
while True:
    numero+=1
    data, addr = sock.recvfrom(80)# buffer size is 1024 bytes
    #print ':'.join(x.encode('hex') for x in data)#,data
    #print len(data)
    all = data[-12:]
    xb = all[0:4]
    yb = all[4:8]
    zb = all[8:12]
    ###print ':'.join(x.encode('hex') for x in xb),':'.join(x.encode('hex') for x in yb),':'.join(x.encode('hex') for x in zb)
    #hex = data.split('/wii/1/accel/pry/3')[1].split(',')[1][-4:]
    #hstring = ':'.join(x.encode('hex') for x in hex)
    "there"
    if numero%numero_poll == 0:
        print "inhere"
        x,y,z = struct.unpack('!f', xb),struct.unpack('!f', yb),struct.unpack('!f', zb)
        x,y,z = x[0],y[0],z[0]
        #print x,y,z
        tot = math.sqrt( (x-.5)*(x-.5) + (y-.5)*(y-.5) + (z-.5)*(z-.5) )
        print tot
        socksend.sendto(str(tot), (UDP_IP_TO, UDP_PORT_TO))
        #print struct.unpack('!i', yb)
        #print struct.unpack('!I', yb)