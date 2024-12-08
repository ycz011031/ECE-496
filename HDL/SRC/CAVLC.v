`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/07 19:03:59
// Design Name: 
// Module Name: CAVLC
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


module cavlc (
    input wire clk,
    input wire valid,
    
    input wire enable,
    input wire [127:0] block_in, // Flattened 16x8-bit quantized block
    
    output reg [7:0] data_out,  // Output data (byte-aligned)
    output reg out_valid,       // Indicates valid output data
    output reg stall            // Asserted when not idle
);

    // Internal states for FSM
    
    localparam IDLE = 3'b000;
    localparam SCAN = 3'b001;
    localparam ENCODE = 3'b010;
    localparam OUTPUT = 3'b011;
    localparam DONE = 3'b100;

    reg [2:0] state; // Current state

    // Internal signals and registers
    integer idx;               // Zigzag index
    reg [7:0] zigzag_order [15:0]; // Zigzag scan order
    reg [7:0] temp_encoded [31:0]; // Temporary storage for encoded bytes
    reg [4:0] encode_count;      // Count of encoded bytes
    reg [4:0] output_count;      // Output byte index
    reg [127:0] block_buffer;    // Buffer for input block
    reg processing;              // Indicates encoding is ongoing

    // Zigzag order for a 4x4 block (example)
    initial begin
        zigzag_order[0]  = 0;  zigzag_order[1]  = 1;  zigzag_order[2]  = 4;  zigzag_order[3]  = 8;
        zigzag_order[4]  = 5;  zigzag_order[5]  = 2;  zigzag_order[6]  = 3;  zigzag_order[7]  = 6;
        zigzag_order[8]  = 9;  zigzag_order[9]  = 12; zigzag_order[10] = 13; zigzag_order[11] = 10;
        zigzag_order[12] = 7;  zigzag_order[13] = 11; zigzag_order[14] = 14; zigzag_order[15] = 15;
    end

    // Combined State Transition and Output Logic
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                stall <= 0;
                out_valid <= 0;
                encode_count <= 0;
                output_count <= 0;
                idx <= 0;
                if (valid && enable) begin
                    block_buffer <= block_in;
                    state <= SCAN;
                end else begin
                    state <= IDLE;
                end
            end

            SCAN: begin
                // Zigzag scan (reorder coefficients)
                for (idx = 0; idx < 16; idx = idx + 1) begin
                    temp_encoded[idx] <= block_buffer[zigzag_order[idx]*8 +: 8];
                end

                state <= ENCODE;
            end

            ENCODE: begin
                // Simplified encoding process (e.g., run-length encoding)
                if (temp_encoded[idx] == 0) begin
                    // Count zeros (for illustration)
                    temp_encoded[encode_count] <= 8'h00; // Encode zero as 0x00
                end else begin
                    temp_encoded[encode_count] <= temp_encoded[idx]; // Pass through non-zero value
                end
                encode_count <= encode_count + 1;
                idx <= idx + 1;
                if (idx == 15) begin
                    state <= OUTPUT;
                end else begin
                    state <= ENCODE;
                end
            end

            OUTPUT: begin
                // Output encoded data
                data_out <= temp_encoded[output_count];
                out_valid <= 1;
                output_count <= output_count + 1;
                if (output_count == encode_count) begin
                    state <= DONE;
                end else begin
                    state <= OUTPUT;
                end
            end

            DONE: begin
                out_valid <= 0;
                stall <= 0;
                state <= IDLE;
            end

            default: begin
                state <= IDLE;
            end
        endcase
    end
endmodule