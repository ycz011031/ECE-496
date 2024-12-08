`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/01 12:36:15
// Design Name: 
// Module Name: Output_Top
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


module Output_Top(
    input wire clk,
    input wire[1:0] mode_select,
    
    input wire[127:0] residual_flat,
    input wire residual_ready,
    
    input wire[127:0] quantized_flat,
    input wire quantized_ready,
    
    input wire [31:0] MB_flat,
    input wire MB_ready,
    
    input wire [7:0] entropy_data,
    input wire entropy_ready,
    
    input wire frame_complete,
    output wire Parsar_busy,
    
    output wire[31:0] FIFO_tx_din,
    output wire FIFO_tx_enable,
    input wire FIFO_tx_block_full   
    );
    
    wire [31:0] FIFO_tx_din_res;
    wire [31:0] FIFO_tx_din_qnt;
    wire [31:0] FIFO_tx_din_etp;
    wire FIFO_tx_enable_res;
    wire FIFO_tx_enable_qnt;
    wire FIFO_tx_enable_etp;
    wire busy_res;
    wire busy_qnt;
    wire busy_etp;
    
    
    Output_Parsar Residual_parsar(
        .clk(clk),
        
        .data_flat(residual_flat),
        .data_ready(residual_ready),
        .data_idle(frame_complete),
        .Parsar_busy(busy_res),
        
        .FIFO_tx_din(FIFO_tx_din_res),
        .FIFO_tx_enable(FIFO_tx_enable_res),
        .FIFO_tx_block_full(FIFO_tx_block_full));
        
    Output_Parsar Quantized_parsar(
        .clk(clk),
        
        .data_flat(quantized_flat),
        .data_ready(quantized_ready),
        .data_idle(frame_complete),
        .Parsar_busy(busy_qnt),
        
        .FIFO_tx_din(FIFO_tx_din_qnt),
        .FIFO_tx_enable(FIFO_tx_enable_qnt),
        .FIFO_tx_block_full(FIFO_tx_block_full));
        
    entropy_parser Entropy_Parsar(
        .clk(clk),
        
        .data_cavlc(entropy_data),
        .data_valid_cavlc(entropy_ready),
        .dump_all(frame_complete),
        
        .FIFO_tx_din(FIFO_tx_din_etp),
        .FIFO_tx_enable(FIFO_tx_enable_etp),
        .busy(busy_etp));
        
        
    assign FIFO_tx_din = (mode_select == 2'b00) ? MB_flat :
                         (mode_select == 2'b01) ? FIFO_tx_din_res :
                         (mode_select == 2'b10) ? FIFO_tx_din_qnt : 
                         (mode_select == 2'b11) ? FIFO_tx_din_etp :32'b0;

    assign FIFO_tx_enable = (mode_select == 2'b00) ? MB_ready :
                            (mode_select == 2'b01) ? FIFO_tx_enable_res :
                            (mode_select == 2'b10) ? FIFO_tx_enable_qnt :
                            (mode_select == 2'b11) ? FIFO_tx_enable_etp : 1'b0;

    assign Parsar_busy = (mode_select == 2'b00) ? 1'b0 :
                         (mode_select == 2'b01) ? busy_res :
                         (mode_select == 2'b10) ? busy_qnt :
                         (mode_select == 2'b11) ? busy_etp : 1'b0;               
        
    
    
    
    
    
endmodule
