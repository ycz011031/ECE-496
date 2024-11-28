`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/28 17:13:14
// Design Name: 
// Module Name: Residual_Select
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


module Residual_Select(
    input wire clk,
    input wire stall,                  // Stall signal to pause the state machine in IDLE
    
    input wire [127:0] pred_block_0,   // Prediction block 0 (16 pixels, 8 bits each)
    input wire pred_block_0_ready,    // Ready signal for block 0
    input wire [127:0] pred_block_1,   // Prediction block 1 (16 pixels, 8 bits each)
    input wire pred_block_1_ready,    // Ready signal for block 1
    input wire [127:0] pred_block_2,   // Prediction block 2 (16 pixels, 8 bits each)
    input wire pred_block_2_ready,    // Ready signal for block 2
    
    input wire [1:0] mode_select,     // Mode select: 00, 01, 10 for manual, 11 for automatic
    
    output reg [127:0] residual_flat, // Selected prediction block
    output reg [1:0] residual_mode,
    output reg residual_ready,           // Indicates the output is valid
    output reg select_busy

    );
    // State encoding
    localparam IDLE          = 2'b00;
    localparam COMPUTE_SUMS  = 2'b01;
    localparam SELECT_MIN    = 2'b10;

    // State register
    reg [1:0] state;

    // Registers for intermediate calculations
    reg [7:0] pred_0_pixels[15:0];
    reg [7:0] pred_1_pixels[15:0];
    reg [7:0] pred_2_pixels[15:0];
    reg [10:0] sum_0; // Sum of block 0
    reg [10:0] sum_1; // Sum of block 1
    reg [10:0] sum_2; // Sum of block 2
    reg [127:0] block_0;
    reg [127:0] block_1;
    reg [127:0] block_2;

    integer i;

    // Initial state
    initial begin
        state = IDLE;
        residual_ready = 0;
        select_busy = 0;
        sum_0 = 0;
        sum_1 = 0;
        sum_2 = 0;
    end

    // State machine
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                case (mode_select)
                    2'b00 : begin
                        residual_flat  <= pred_block_0;
                        residual_ready <= pred_block_0_ready;
                        select_busy    <= stall;
                        residual_mode  <= 2'b00;
                    end
                    2'b01 : begin
                        residual_flat  <= pred_block_1;
                        residual_ready <= pred_block_1_ready;
                        select_busy    <= stall;
                        residual_mode  <= 2'b01;
                    end
                    2'b10 : begin
                        residual_flat  <= pred_block_2;
                        residual_ready <= pred_block_2_ready;
                        select_busy    <= stall;
                        residual_mode  <= 2'b10;
                    end
                    2'b11 : begin
                        if (stall) begin
                            state <= IDLE;
                        end else if (pred_block_0_ready && pred_block_1_ready && pred_block_2_ready) begin
                            select_busy <= 1;    
                            // Sample blocks
                            block_0 <= pred_block_0;
                            block_1 <= pred_block_1;
                            block_2 <= pred_block_2;
    
                            // Unflatten prediction blocks into arrays for sum calculation
                            for (i = 0; i < 16; i = i + 1) begin
                                pred_0_pixels[i] <= pred_block_0[i * 8 +: 8];
                                pred_1_pixels[i] <= pred_block_1[i * 8 +: 8];
                                pred_2_pixels[i] <= pred_block_2[i * 8 +: 8];
                            end
    
                            if (mode_select == 2'b11) begin
                                state <= COMPUTE_SUMS; // Automatic mode
                            end else begin
                                state <= SELECT_MIN; // Skip to manual selection
                            end
                        end
                    end        
                endcase
            end          

            COMPUTE_SUMS: begin
                // Calculate sums for each block
                sum_0 = 0;
                sum_1 = 0;
                sum_2 = 0;

                for (i = 0; i < 16; i = i + 1) begin
                    sum_0 = sum_0 + pred_0_pixels[i];
                    sum_1 = sum_1 + pred_1_pixels[i];
                    sum_2 = sum_2 + pred_2_pixels[i];
                end

                state <= SELECT_MIN; // Move to selection
            end

            SELECT_MIN: begin
                case (mode_select)
                    2'b00: residual_flat <= block_0; // Manual selection: Block 0
                    2'b01: residual_flat <= block_1; // Manual selection: Block 1
                    2'b10: residual_flat <= block_2; // Manual selection: Block 2
                    2'b11: begin
                        // Automatic selection: Find the block with the minimum sum
                        if (sum_0 <= sum_1 && sum_0 <= sum_2) begin
                            residual_flat <= block_0;
                        end else if (sum_1 <= sum_0 && sum_1 <= sum_2) begin
                            residual_flat <= block_1;
                        end else begin
                            residual_flat <= block_2;
                        end
                    end
                endcase

                residual_ready <= 1'b1; // Indicate the output is valid
                select_busy <= 0;           // Processing complete
                state <= IDLE;       // Return to IDLE state
            end

            default: state <= IDLE;
        endcase
    end
endmodule
    
   
