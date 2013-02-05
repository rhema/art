import socket
import time
import random

UDP_IP = "127.0.0.1"#this machine
UDP_PORT = 5005
MESSAGE = "Hello, World!"
 
print "UDP target IP:", UDP_IP
print "UDP target port:", UDP_PORT
print "message:", MESSAGE
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

while True:
    time.sleep(.5)
    MESSAGE = str(random.random()*100)
    sock.sendto(MESSAGE, (UDP_IP, UDP_PORT))#many of these....