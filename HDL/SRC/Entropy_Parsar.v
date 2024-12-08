`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/07 19:23:02
// Design Name: 
// Module Name: Entropy_Parsar
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module entropy_parser (
    input wire clk,
    input wire [7:0] data_cavlc,        // Input data from CAVLC encoder (8 bits)
    input wire data_valid_cavlc,         // Indicates valid input data
    input wire dump_all,                 // Trigger to dump all data with padding
    output reg [31:0] FIFO_tx_din,       // Output data to FIFO (32 bits)
    output reg FIFO_tx_enable,           // Enable signal for FIFO
    output reg busy                      // Indicates if the module is busy processing data
);

    // Fixed Block Size (in bytes)
    localparam block_size = 16;  // Block size is fixed at 16 bytes

    // Internal registers and variables
    reg [7:0] buffer [0:19];              // 20-byte buffer to hold incoming 8-bit data
    reg [4:0] byte_count;                 // Counts number of bytes accumulated in the buffer
    reg [31:0] accumulated_data;          // Holds the concatenated data (32-bit)
    reg [9:0] data_counter;               // Counter for keeping track of total data processed
    reg [4:0] buffer_index;               // Index to manage data processing from the buffer
    
    // Initialize
    initial begin
        byte_count = 0;
        accumulated_data = 32'd0;
        data_counter = 0;
        FIFO_tx_enable = 0;
        busy = 0;  // Initially not busy
    end

    // Output Parsing Logic
    always @(posedge clk) begin
        // Store incoming 8-bit data into the buffer
        if (data_valid_cavlc) begin
            buffer[byte_count] <= data_cavlc;
            byte_count <= byte_count + 1;
            busy <= 1;  // Assert busy while buffering data
        end

        // Once 4 bytes have been buffered, start processing the data
        if (byte_count >= 4) begin
            // Concatenate data into 32-bit chunks once we have 4 bytes
            accumulated_data <= {buffer[3], buffer[2], buffer[1], buffer[0]};
            FIFO_tx_din <= accumulated_data;  // Send the 32-bit data to FIFO
            FIFO_tx_enable <= 1;  // Enable FIFO to accept the data
            byte_count <= byte_count - 4; // Reset buffer for next 32-bit chunk

            // Shift remaining bytes in the buffer
            for (buffer_index = 0; buffer_index < byte_count; buffer_index = buffer_index + 1) begin
                buffer[buffer_index] <= buffer[buffer_index + 4];
            end
            data_counter <= data_counter + 1;  // Increment data counter
        end

        // Handle the "dump all" signal to ensure zero-padding and block size alignment


        // Deassert busy when no data is being processed
        if (byte_count == 0 && !data_valid_cavlc && !dump_all && data_counter == 0) begin
            busy <= 0;  // Deassert busy when idle
        end
    end

endmodule