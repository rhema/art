import socket#missing
import time
import random
import load_data

UDP_IP = "127.0.0.1"#this machine
UDP_PORT = 5005
MESSAGE = "Hello, World!"
 
print "UDP target IP:", UDP_IP
print "UDP target port:", UDP_PORT
print "message:", MESSAGE
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

raw = load_data.get_raw_array()
bin = load_data.get_bin_array()

frames = bin#raw
print "lengths...",len(frames[0]);
while True:
    for frame in frames:
        time.sleep(1.0/30.0)
        MESSAGE = frame
        sock.sendto(MESSAGE, (UDP_IP, UDP_PORT))