import socket

UDP_IP = "127.0.0.1"
UDP_PORT = 9999

sock = socket.socket(socket.AF_INET, # Internet
                     socket.SOCK_DGRAM) # UDP
sock.bind((UDP_IP, UDP_PORT))
 
while True:
    data, addr = sock.recvfrom(2048) # buffer size is 1024 bytes
    print len(data),"received message:", data