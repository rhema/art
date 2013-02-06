import uuid , binascii


text_kind = open("../../data/DirectIndirectRawData.txt")
bin_kind = open("../../data/kinect_indirect_slower.bin")



def get_raw_array():
    ret = []
    for line in text_kind.readlines():
        print line.strip()
        ret += [line.strip()]
    return ret

def get_bin_array():
    bytes_per_frame = 62*4
    ret = []
    while True:
        bytes = bin_kind.read(bytes_per_frame)
        if len(bytes) < bytes_per_frame:
            break
        u = binascii.hexlify(bytes)
        print("Hex %s" % u)
        ret+=[bytes]
    return ret