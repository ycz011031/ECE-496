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
    
    def start_process(self):
        self.dev.SetWireInValue(0x00, 1)
        self.dev.UpdateWireIns()
        while (True):
            self.dev.UpdateWireOuts()
            status = self.dev.GetWireOutValue(0x20)
            if status != 0 :
                break
        self.dev.SetWireInValue(0x00,0)
        self.dev.UpdateWireIns()
        data = bytearray()
        while (True):
            buf = bytearray(1024)
            self.dev.ReadFromBlockPipeOut(0xa0, 1024, buf)
            data += buf
            self.dev.UpdateWireOuts()
            status = self.dev.GetWireOutValue(0x20)
            if status == 0 :
                break
        return data

    def data_parsar_1 (self,data):
        data_array = np.frombuffer(data,dtype=np.uint8,count=len(data))
        data_matrix = []
        for i in range(4096):
            data_matrix.append(np.array(data_array[i*16:i*16+16]).reshape(4,4))
        return data_matrix

    def reconstruction(self, data_matrix):
        # Initialize an empty 256x256 image
        reconstructed_image = np.zeros((256, 256), dtype=np.int32)

        # Iterate over 4x4 subblocks (4096 total blocks in a 256x256 image)
        for block_idx in range(4096):
            # Compute block row and column index (subblock positions)
            row_block = block_idx // 64  # Each row of blocks has 64 subblocks (256/4)
            col_block = block_idx % 64  # Subblock column position within the row

            # Get the starting position for the current subblock in the reconstructed image
            start_row = row_block * 4
            start_col = col_block * 4

            # Get the residual block (4x4)
            residual_block = data_matrix[block_idx]

            # Predict the block using mode2_4x4 (DC mode)
            if col_block == 0 and row_block == 0:  # Top-left block
                H = np.full(4, 127)  # No horizontal prediction available
                V = np.full(4, 127)  # No vertical prediction available
            elif row_block == 0:  # First row but not the first block
                H = np.full(4, 127)  # No horizontal prediction available
                V = reconstructed_image[start_row:start_row + 4, start_col - 1]
            elif col_block == 0:  # First column but not the first block
                H = reconstructed_image[start_row - 1, start_col:start_col + 4]
                V = np.full(4, 127)  # No vertical prediction available
            else:  # General case
                H = reconstructed_image[start_row - 1, start_col:start_col + 4]
                V = reconstructed_image[start_row:start_row + 4, start_col - 1]

            # Compute the predicted block using mode2_4x4
            reconstructed_block = mode2_4x4(residual_block, H, V)

            # Place the reconstructed block into the reconstructed image
            reconstructed_image[start_row:start_row + 4, start_col:start_col + 4] = reconstructed_block

        # Clip the reconstructed image values to the valid range [0, 255]
        reconstructed_image = np.clip(reconstructed_image, 0, 255).astype(np.uint8)

        return reconstructed_image



def mode2_4x4(residual, H, V,):
    """
    4x4 block's Mode 2 (DC) prediction mode
    Args:
        size: the prediction block's size, should be 4x4 here
        H: the horizontal predict value, -1 means not available
        V: the vertical predict value, -1 means not available
    Return:
        the prediction result
    """
    size = residual.shape
    # Check if horizontal (H) and vertical (V) predictors are available
    H_Available = False if np.sum(H < 0) > 0 else True
    V_Available = False if np.sum(V < 0) > 0 else True

    # Compute the mean value based on available predictors
    mean = 0
    if H_Available and V_Available:
        mean = ((np.sum(H) + np.sum(V)) + 8) >> 4
    elif H_Available and (not V_Available):
        mean = (np.sum(H) + 4) >> 3
    elif (not H_Available) and V_Available:
        mean = (np.sum(V) + 4) >> 3
    else:
        mean = 128

    # Generate a 4x4 block filled with the computed mean value
    predicted = np.zeros(size, int)
    predicted[:] = int(mean)
    reconstructed = residual + predicted

    return reconstructed
   

