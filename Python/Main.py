import scipy
import copy
import time
import cv2
import sys,os
import numpy as np
import matplotlib.pyplot as plt
from imageio import imread
from Utilities import *

ok_sdk_loc = "C:\\Program Files\\Opal Kelly\\FrontPanelUSB\\API\\Python\\x64"
ok_dll_loc = "C:\\Program Files\\Opal Kelly\\FrontPanelUSB\\API\\lib\\x64"

sys.path.append(ok_sdk_loc)   # add the path of the OK library
os.add_dll_directory(ok_dll_loc)

import ok     # OpalKelly library

dev = ok.okCFrontPanel()  # define a device for FrontPanel communication
SerialStatus=dev.OpenBySerial("")      # open USB communication with the OK board
# We will NOT load the bit file because it will be loaded using JTAG interface from Vivado

# Check if FrontPanel is initialized correctly and if the bit file is loaded.
# Otherwise terminate the program
print("----------------------------------------------------")
if SerialStatus == 0:
    print ("FrontPanel host interface was successfully initialized.")
else:    
    print ("FrontPanel host interface not detected. The error code number is:" + str(int(SerialStatus)))
    print("Exiting the program.")
    sys.exit ()

codec_instance = codec(dev)

    # Step 1: Send the image
image_name = "kitten.png"  # Replace with the path to your grayscale image
original_image = codec_instance.send_image(image_name)
if original_image is None:
    print("Image transmission failed.")
    
input("press enter to continue")    

# Step 2: Start the encoding and decoding process on the FPGA
encoded_data = codec_instance.start_process()
if len(encoded_data) == 0:
    print("No data received from the FPGA.")
print(encoded_data)
# Step 3: Parse the encoded data into 4x4 blocks
raw_data = np.frombuffer(encoded_data,dtype=np.uint8,count=len(encoded_data))
#raw_data = np.append(raw_data, np.zeros(256*256-4096, dtype=np.uint8))
raw_data = raw_data.reshape(256,256)
data_matrix = codec_instance.data_parsar_MB(encoded_data)

# Step 4: Reconstruct the image from the decoded data
decoded_image = codec_instance.reconstruction(data_matrix)

# Step 5: Display the original and decoded images side by side
plt.figure(figsize=(10, 5))

# Display original image
plt.subplot(1, 2, 1)
plt.title("Original Image")
plt.imshow(original_image, cmap='gray')
plt.axis('off')

# Display decoded image
plt.subplot(1, 2, 2)
plt.title("Decoded Image")
plt.imshow(decoded_image, cmap='gray')
plt.axis('off')



# Show the plots
plt.tight_layout()
plt.show()
reconstructed_image_name = "row_image.png"

cv2.imwrite(reconstructed_image_name, decoded_image)
