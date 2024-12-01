`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/28 03:25:38
// Design Name: 
// Module Name: Output_Parsar
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


module Output_Parsar(
    input wire clk,
    
    input wire[127:0] data_flat,   // Input 128-bit flattened data
    input wire data_ready,        // Asserted when data is ready for parsing
    input wire data_idle,         // Indicates the parsing can be idle
    output reg Parsar_busy,       // Asserted when parsing is ongoing
    
    output reg[31:0] FIFO_tx_din, // 32-bit data to send to FIFO
    output reg FIFO_tx_enable,     // Write enable for FIFO
    input wire FIFO_tx_block_full
);

      // State encoding
    localparam IDLE         = 2'b00;
    localparam PARSE         = 2'b01;
    localparam ZERO_PADDING = 2'b10;

    // State register
    reg [1:0] state;

    // Byte tracking
    reg [9:0] transmitted_bytes; // Tracks number of bytes transmitted within a 1024-byte frame
    reg [1:0] data_index;        // Tracks which 32-bit chunk of `data_flat` to send next

    // State machine
    always @(posedge clk) begin
        case (state)
            // IDLE State: Wait for data_ready signal
            IDLE: begin
                Parsar_busy <= 1'b0|FIFO_tx_block_full;
                FIFO_tx_enable <= 1'b0;
                transmitted_bytes <= 10'd0;
                data_index <= 2'd0;

                if (data_ready) begin
                    Parsar_busy <= 1'b1;
                    state <= PARSE;
                end
            end

            // PARSE State: Send 32-bit chunks of `data_flat` to FIFO
            PARSE: begin
                Parsar_busy <= 1'b1;

                // Send the next 32-bit chunk
                FIFO_tx_enable <= 1'b1;
                case (data_index)
                    2'd0: FIFO_tx_din <= data_flat[31:0];
                    2'd1: FIFO_tx_din <= data_flat[63:32];
                    2'd2: FIFO_tx_din <= data_flat[95:64];
                    2'd3: FIFO_tx_din <= data_flat[127:96];
                endcase

                // Increment data index and byte counter
                data_index <= data_index + 1;
                transmitted_bytes <= transmitted_bytes + 4;

                // Check if we have sent all chunks of `data_flat`
                if (data_index == 2'd3) begin
                    FIFO_tx_enable <= 1'b0; // Stop writing after all chunks sent

                    if (data_idle) begin
                        // If it's the last part of the transmission, check if zero padding is needed
                        if ((transmitted_bytes + 4) % 1024 == 0) begin
                            state <= IDLE; // No zero padding needed
                        end else begin
                            state <= ZERO_PADDING; // Move to zero padding
                        end
                    end else begin
                        // Wait for next data_ready signal
                        state <= IDLE;
                    end
                end
            end

            // ZERO_PADDING State: Send zeroes to pad to a multiple of 1024 bytes
            ZERO_PADDING: begin
                Parsar_busy <= 1'b1;
                FIFO_tx_enable <= 1'b1;
                FIFO_tx_din <= 32'd0; // Send zero padding

                // Increment byte counter
                transmitted_bytes <= transmitted_bytes + 4;

                // Check if padding is complete
                if (transmitted_bytes % 1024 == 0) begin
                    FIFO_tx_enable <= 1'b0;
                    state <= IDLE; // Return to IDLE state
                end
            end
        endcase
    end

    // Initialize registers
    initial begin
        state = IDLE;
        Parsar_busy = 1'b0;
        FIFO_tx_enable = 1'b0;
        FIFO_tx_din = 32'd0;
        transmitted_bytes = 10'd0;
        data_index = 2'd0;
    end

endmodule