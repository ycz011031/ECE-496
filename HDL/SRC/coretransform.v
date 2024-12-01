`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/29 05:26:43
// Design Name: 
// Module Name: coretransform
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


module coretransform(
    input wire clk,
    
    input wire data_ready,
    input wire[127:0] data_matrix,
    
    output wire quantize_ready,
    output wire[127:0] quantize_data,
    
    output wire[1:0] debug_status_transform

    );
    
    wire [207:0] dct_out_flat;          // Output of DCT
    wire dct_valid;                     // DCT output valid signal
    wire [127:0] quant_out_flat;        // Final quantized output
    wire quant_valid;
    
    reg [127:0] quant_matrix; 
    
    dct4x4_h264 dct_module (
        .clk(clk),
        .reset(1'b0),
        .enable(data_ready),
        .matrix_in_flat(data_matrix),
        .matrix_out_flat(dct_out_flat),
        .valid(dct_valid)
    );
    
    quantize quant_module (
        .clk(clk),
        .reset(1'b0),
        .enable(dct_valid),
        .dct_in_flat(dct_out_flat),
        .quant_matrix_flat(quant_matrix),
        .quant_out_flat(quantize_data),
        .valid(quantize_ready)
    );
    
    
    assign debug_status_transform = {~dct_valid,~quantize_ready};
    
    
endmodule
