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
        else :
            print("Image Transmitted")
        return image
    
    def start_process(self):
        self.dev.SetWireInValue(0x00, 1)
        self.dev.UpdateWireIns()
        print(time.time())
        while (True):
            self.dev.UpdateWireOuts()
            status = self.dev.GetWireOutValue(0x20)
            print(time.time())
            if status != 0 :
                break
        self.dev.SetWireInValue(0x00,0)
        self.dev.UpdateWireIns()
        self.dev.UpdateWireOuts()
        print(self.dev.GetWireOutValue(0x20))
        print(time.time())
        data = bytearray()
        while (True):
            buf = bytearray(1024)
            self.dev.ReadFromBlockPipeOut(0xa0, 1024, buf)
            data += buf
            self.dev.UpdateWireOuts()
            status = self.dev.GetWireOutValue(0x20)
            print(status)
            print(time.time())
            if status == 0 :
                break
        return data
    
    def start_process_test(self):
        self.dev.SetWireInValue(0x00, 5)
        self.dev.UpdateWireIns()
        #self.dev.SetWireInValue(0x00, 0)
        #self.dev.UpdateWireIns()
        print(time.time())
        data = bytearray(65536)
        self.dev.ReadFromBlockPipeOut(0xa0, 1024, data)
        print(time.time())
        return data

    def data_parsar_raw(self,data):
        data_array = np.frombuffer(data,dtype=np.uint8,count=len(data))
        data_matrix=[]
        for i in range(16384):
            data_matrix.append(np.array(data_array[i*4:i*4+4]).reshape(2,2))            
        return data_matrix

    def data_parsar_MB (self,data):
        data_array = np.frombuffer(data,dtype=np.uint8,count=len(data))
        #data_array = np.append(data_array, np.zeros(256*256-1024, dtype=np.uint8))
        print(data_array.shape)
        data_matrix = []
        for i in range(4096):
            data_matrix.append(np.array(data_array[i*16:i*16+16]).reshape(4,4))            
        return data_matrix
    
    def data_parser_EC(self, data):
        data_array = np.frombuffer(data, dtype=np.uint8, count=len(data))
        output_array = []  # Array to store arrays of data
        data_pointer = 0   # Pointer to track position in the data array
        while data_pointer < len(data_array) - 1:
            # Read the 16-bit indicator (2 bytes)
            if data_pointer + 1 >= len(data_array):
                break
            indicator_bits = (data_array[data_pointer] << 8) | data_array[data_pointer + 1]
            data_pointer += 2
            temp_array = []  # Temporary array to store results of this segment
            # Iterate through the 16 bits of the indicator
            for i in range(16):
                if data_pointer >= len(data_array):
                    break
                if indicator_bits & (1 << (15 - i)):  # Check if the bit is 1
                    temp_array.append(data_array[data_pointer])  # Add next data value
                    data_pointer += 1
                else:
                    temp_array.append(0)  # Append a zero (uint8)
            # Append the temp_array to the output array
            output_array.append(temp_array)
        return output_array

    def reconstruction(self, data_matrix):
        # Initialize an empty 256x256 image
        reconstructed_image = np.zeros((256, 256), dtype=np.uint8)

        # Iterate over 4x4 subblocks (4096 total blocks in a 256x256 image)
        for block_idx in range(4096):
            # Compute block row and column index (subblock positions)
            row_block = block_idx // 64  # Each row of blocks has 64 subblocks (256/4)
            col_block = block_idx % 64  # Subblock column position within the row

            # Get the starting position for the current subblock in the reconstructed image
            start_row = row_block * 4
            start_col = col_block * 4

            # Get the residual block (4x4)
            residual_block = data_matrix[block_idx]<< 1

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
            reconstructed_block = modeDC_4x4(residual_block, H, V)

            # Place the reconstructed block into the reconstructed image
            reconstructed_image[start_row:start_row + 4, start_col:start_col + 4] = reconstructed_block

        # Clip the reconstructed image values to the valid range [0, 255]
        reconstructed_image = np.clip(reconstructed_image, 0, 255).astype(np.uint8)

        return reconstructed_image
    
    def reconstruction_test(self,data_matrix):
        reconstructed_image = np.zeros((256, 256), dtype=np.uint8)
        for block_idx in range(4096):
            row_block = block_idx // 64
            col_block = block_idx % 64
            start_row = row_block*4
            start_col = col_block*4
            block = data_matrix[block_idx]
            reconstructed_image[start_row:start_row+4,start_col:start_col+4] = block
        reconstructed_image = np.clip(reconstructed_image,0,255).astype(np.uint8)
        return reconstructed_image
    
    def Inverse_CoreTransform(self, input_data):

    # Initialize the quantization matrix for H.264 (4x4 example)
        quant_matrix = np.array([
            [16, 11, 10, 16],
            [12, 12, 14, 19],
            [14, 13, 16, 24],
            [14, 17, 22, 29]
        ], dtype=np.int32)

        # Example IDCT approximation matrix for 4x4 (simplified H.264 style)
        idct_matrix = np.array([
            [1, 1, 1, 1],
            [2, 1, -1, -2],
            [1, -1, -1, 1],
            [1, -2, 2, -1]
        ], dtype=np.int32)

        # Process each block (4x4 blocks packed as input_data)
        processed_data = []

        for block_idx in range(len(input_data)):
            # Extract the 4x4 coefficient block
            coeff_block = np.array(input_data[block_idx]).reshape((4, 4))

            # Perform inverse quantization directly
            inv_quantized_block = coeff_block * quant_matrix

            # Perform the integer approximation of the IDCT directly
            idct_block = np.clip(
                np.round(idct_matrix @ inv_quantized_block @ idct_matrix.T) >> 4,
                -2048, 2047
            ).astype(np.int32)

            # Append the processed block
            processed_data.append(idct_block)

        return processed_data
    
    



def modeDC_4x4(residual, H, V,):
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
   

def modeVertical_4x4(residual, V):
    """
    4x4 block's Mode 0 (Vertical) prediction mode
    Args:
        residual: the residual block (4x4 matrix)
        V: the vertical predictor values (a 1D array of 4 values)
    Returns:
        the reconstructed 4x4 block after vertical prediction
    """
    size = residual.shape

    # Check if vertical (V) predictors are available
    V_Available = False if np.sum(V < 0) > 0 else True

    # Generate the predicted block
    predicted = np.zeros(size, int)
    if V_Available:
        # Copy vertical predictor values down each column
        predicted[:] = V.reshape(1, -1)
    else:
        # If no vertical predictor is available, use the default value of 128
        predicted[:] = 128

    # Reconstruct the block by adding residuals to the prediction
    reconstructed = residual + predicted

    return reconstructed

def modeHorizontal_4x4(residual, H):
    """
    4x4 block's Mode 1 (Horizontal) prediction mode
    Args:
        residual: the residual block (4x4 matrix)
        H: the horizontal predictor values (a 1D array of 4 values)
    Returns:
        the reconstructed 4x4 block after horizontal prediction
    """
    size = residual.shape

    # Check if horizontal (H) predictors are available
    H_Available = False if np.sum(H < 0) > 0 else True

    # Generate the predicted block
    predicted = np.zeros(size, int)
    if H_Available:
        # Copy horizontal predictor values across each row
        predicted[:] = H.reshape(-1, 1)
    else:
        # If no horizontal predictor is available, use the default value of 128
        predicted[:] = 128

    # Reconstruct the block by adding residuals to the prediction
    reconstructed = residual + predicted

    return reconstructed