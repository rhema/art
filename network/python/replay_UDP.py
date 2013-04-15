import time
from os import listdir
from os.path import isfile, join
import socket
import struct

mypath = 'captured/'

onlyfiles = [ f for f in listdir(mypath) if isfile(join(mypath,f)) ]

index = 0
picked = 0
print "Pick a file to run"
for i in range(0,len(onlyfiles)):
    print i,": ",onlyfiles[i]

picked = input()
print "Pick an output port (9020)"
port = input()
print "Pick an output ip (127.0.0.1)"
ip = raw_input()

UDP_IP_TO = ip
UDP_PORT_TO = port
socksend = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)


data = open(mypath+onlyfiles[picked]).readlines()
data_index = 0
while True:
    sleep,senddata = data[data_index%len(data)].strip().split("|")
    #socksend.sendto(str(tot), (UDP_IP_TO, UDP_PORT_TO))
    data_index += 1
    time.sleep(float(sleep)/1000.0)
    #print senddata
    socksend.sendto(senddata, (UDP_IP_TO, UDP_PORT_TO))