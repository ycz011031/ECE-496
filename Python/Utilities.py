import scipy
import copy
import time
import cv2
import sys,os
import numpy as np
import matplotlib.pyplot as plt
from imageio import imread

ok_sdk_loc = "C:\\Program Files\\Opal Kelly\\FrontPanelUSB\\API\\Python\\x64"
ok_dll_loc = "C:\\Program Files\\Opal Kelly\\FrontPanelUSB\\API\\lib\\x64"

sys.path.append(ok_sdk_loc)   # add the path of the OK library
os.add_dll_directory(ok_dll_loc)

import ok     # OpalKelly library

class codec:

    def __init__(self,dev):
        self.dev = dev
    

    def send_image(self,image_name):
        image = cv2.imread(image_name,cv2.IMREAD_GRAYSCALE)
        height,width=image.shape
        if height < 256 or width < 256 :
            print ("Invalid Image resolution")
            return
        
        start_y = (height - 256)//2
        start_x = (width - 256)//2

        image = image[start_y:start_y + 256, start_x:start_x + 256]

        image_f = image.flatten()
        buf = bytearray(image_f)
        tx_code = self.dev.WriteToBlockPipeIn(0x80,256,buf)
        if tx_code < 0 :
            print("Transmission Filaed with error code",tx_code)
        return image



   

