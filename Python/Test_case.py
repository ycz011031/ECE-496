import cv2
import sys,os
import numpy as np
import matplotlib.pyplot as plt
from imageio import imread



def generate_bitstream(image):
    """
    Simulate the hardware bitstream generation process on the PC with 9-bit signed computation,
    right-shifted by 1 to fit into a byte. Unavailable neighbors default to 127.

    Args:
        image: The image used as input to the `send_image` function (2D NumPy array).

    Returns:
        A bytearray representing the simulated bitstream.
    """
    # Ensure the input is a 256x256 grayscale image
    if image.shape != (256, 256):
        raise ValueError("Input image must be a 256x256 grayscale image.")

    data = bytearray()

    # Iterate over 4x4 blocks (4096 blocks in a 256x256 image)
    for row_block in range(64):  # Each row has 64 blocks (256/4)
        for col_block in range(64):
            # Determine the block's starting position
            start_row = row_block * 4
            start_col = col_block * 4

            # Extract the 4x4 block from the image
            block = image[start_row:start_row + 4, start_col:start_col + 4]

            # Predict the block using Mode 2 (DC mode)
            if col_block == 0 and row_block == 0:  # Top-left block
                H = np.full(4, 127)  # No horizontal prediction available
                V = np.full(4, 127)  # No vertical prediction available
            elif row_block == 0:  # First row but not the first block
                H = np.full(4, 127)  # No horizontal prediction available
                V = image[start_row:start_row + 4, start_col - 1]
            elif col_block == 0:  # First column but not the first block
                H = image[start_row - 1, start_col:start_col + 4]
                V = np.full(4, 127)  # No vertical prediction available
            else:  # General case
                H = image[start_row - 1, start_col:start_col + 4]
                V = image[start_row:start_row + 4, start_col - 1]

            # Compute the predicted block using mode2_4x4
            predicted_block = mode2_4x4(block - block, H, V)

            # Calculate the residual block
            residual_block = block - predicted_block

            # Convert residual to 9-bit signed integers
            residual_9bit = np.clip(residual_block, -256, 255)

            # Right-shift by 1 to fit into an 8-bit signed range
            residual_8bit = (residual_9bit // 2).astype(np.int8)

            # Flatten and append the residual block to the data buffer
            data.extend(residual_8bit.flatten().astype(np.uint8))

    return data


def reconstruction(data_matrix):
    """
    Reconstruct a 256x256 image from a data matrix (list of 4096 4x4 blocks),
    accommodating 9-bit signed residuals stored with a right shift.

    Args:
        data_matrix: List of 4096 4x4 blocks, each a NumPy array (decoded from bitstream).

    Returns:
        A 256x256 reconstructed image as a NumPy array.
    """
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

        # Get the residual block (4x4) and reverse the right-shift operation
        residual_block = data_matrix[block_idx] << 1

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
        predicted_block = mode2_4x4(residual_block - residual_block, H, V)

        # Reconstruct the block by adding the residuals to the predicted block
        reconstructed_block = residual_block + predicted_block

        # Place the reconstructed block into the reconstructed image
        reconstructed_image[start_row:start_row + 4, start_col:start_col + 4] = reconstructed_block

    # Clip the reconstructed image values to the valid range [0, 255]
    reconstructed_image = np.clip(reconstructed_image, 0, 255).astype(np.uint8)

    return reconstructed_image


def data_parsar_1 (data):
    data_array = np.frombuffer(data,dtype=np.uint8,count=len(data))
    data_matrix = []
    for i in range(4096):
        data_matrix.append(np.array(data_array[i*16:i*16+16]).reshape(4,4))
    return data_matrix

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

def send_image(image_name):
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
    return image

def main():
    # Step 1: Load and preprocess the image
    image_name = "kitten.png"
    print("Loading and preprocessing the image...")
    image = send_image(image_name)
    if image is None:
        print("Failed to load the image. Exiting...")
        return
    
    # Step 2: Generate the bitstream from the image
    print("Generating bitstream from the image...")
    simulated_bitstream = generate_bitstream(image)
    
    # Step 3: Parse the bitstream into 4x4 blocks
    print("Parsing the bitstream into 4x4 blocks...")
    data_matrix = data_parsar_1(simulated_bitstream)
    
    # Step 4: Reconstruct the image from the bitstream
    print("Reconstructing the image from the bitstream...")
    reconstructed_image = reconstruction(data_matrix)
    
    # Step 5: Display the original and reconstructed images for comparison
    print("Displaying the original and reconstructed images...")
    plt.figure(figsize=(10, 5))
    plt.subplot(1, 2, 1)
    plt.title("Original Image")
    plt.imshow(image, cmap='gray')
    plt.axis('off')

    plt.subplot(1, 2, 2)
    plt.title("Reconstructed Image")
    plt.imshow(reconstructed_image, cmap='gray')
    plt.axis('off')

    plt.show()
    
    original_image_name = "original_image.png"
    cv2.imwrite(original_image_name, image)
    print(f"Original image saved as {original_image_name}")
    # Optional: Save the reconstructed image
    reconstructed_image_name = "reconstructed_image.png"
    cv2.imwrite(reconstructed_image_name, reconstructed_image)
    print(f"Reconstructed image saved as {reconstructed_image_name}")


if __name__ == "__main__":
    main()