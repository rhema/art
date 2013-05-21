s = "/wii/1/accel/"

import socket
import struct
import math
UDP_IP = "127.0.0.1"
UDP_PORT = 9000

#So tilt is actually sent via OSC, and I need to send the XYZs.
#I think I can do this by differentiaing from /wii/1/accel/xyz/1   and /wii/1/accel .
#I'll just keep a global store of all data and send updates on any update or on a /wii/1/accel . 
#

sock = socket.socket(socket.AF_INET, # Internet
                     socket.SOCK_DGRAM) # UDP
sock.bind((UDP_IP, UDP_PORT))

UDP_IP_TO = "127.0.0.1"
#UDP_IP_TO = "10.201.104.132"
UDP_IP_TO = raw_input("What IP should I send to? (use 127.0.0.1) :")
UDP_PORT_TO = 9010

#UDP_TO_ARRAY = [{'ip':}]

socksend = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)

numero = 0
numero_poll = 1
somesome = 0
t_string = '/wii/1/accel/xyz'
a_string = '/wii/1/accel/xyz/'
#3e:fe:e0:cf:3f:09:4b:35:3e:d3:0a:4d
print "Running..."
tot,x,y,z,ix,iy,iz = 0,0,0,0,0,0,0
while True:
    numero+=1
    data, addr = sock.recvfrom(80)# buffer size is 1024 bytes
    print "dera"
    print data.encode("hex")
    print data  
    use_a = False
    if a_string in data:
        #print "a_string"
        use_a = True
    elif t_string in data:
        pass
        #print "t_string"
    
    if use_a == False:
        all = data[-16:]
        xb = all[0:4]
        yb = all[4:8]
        zb = all[8:12]
        wb = all[12:16]
        wb = struct.unpack('!f', wb)
        #print ':'.join(x.encode('hex') for x in xb),':'.join(x.encode('hex') for x in yb),':'.join(x.encode('hex') for x in zb)
        x,y,z = struct.unpack('!f', xb),struct.unpack('!f', yb),struct.unpack('!f', zb)
        x,y,z,wb = x[0],y[0],z[0],wb[0]
        #print x,y,z
        #tot = math.sqrt( (x-.5)*(x-.5) + (y-.5)*(y-.5) + (z-.5)*(z-.5) )
        tot = wb
    else:
        ind = data[17]#0 to 2 is x, y ,z
        #print ind,"DIS IND!!!",type(ind)
        all = data[-12:]
        xb = all[8:12]
        v = struct.unpack('!f', xb)[0]
        #print v
        if ind == '0':
            ix = v
            print "set ix"
        if ind == '1':
            iy = v
        if ind == '2':
            iz = v
        
    #print tot
    send_string = str(tot)+" "+str(x)+" "+str(y)+" "+str(z)#+" "+str(ix)+" "+str(iy)+" "+str(iz)
    #print send_string
    socksend.sendto(send_string, (UDP_IP_TO, UDP_PORT_TO))
    #print struct.unpack('!i', yb)
    #print struct.unpack('!I', yb)