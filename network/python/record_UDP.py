import socket

UDP_IP = "127.0.0.1"
UDP_PORT = 9020

import time


sock = socket.socket(socket.AF_INET, # Internet
                     socket.SOCK_DGRAM) # UDP
sock.bind((UDP_IP, UDP_PORT))

milis_old = 0

outfilename = "captured/from-"+str(time.ctime()).replace(":","-")+".cap"
print outfilename
outfile = open(outfilename,'w')

while True:
    data, addr = sock.recvfrom(UDP_PORT) # buffer size is 1024 bytes
    
    milis = int(round(time.time() * 1000))
    diff = 0
    if milis_old != 0:
        diff = milis - milis_old
    milis_old = milis
    print len(data),"received message:", diff, data
    outfile.write(str(diff)+"|"+data+"\n")
    