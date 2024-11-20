`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/06 02:28:25
// Design Name: 
// Module Name: Main
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


module Main(
    output [7:0] led,
    input sys_clkn,
    input sys_clkp,
    
    input  [4:0] okUH,
    output [2:0] okHU,
    inout  [31:0] okUHU,
    inout  okAA
    );

// Clock buffer
    wire clk;

    IBUFGDS osc_clk(
        .O(clk),
        .I(sys_clkp),
        .IB(sys_clkn)
    );
       
    
 
// USB Driver 

        wire[31:0] PC_rx_async;
        wire[31:0] PC_tx_async;
        
        wire FIFO_tx_full;
        wire FIFO_tx_empty;
        wire FIFO_tx_enable;
        wire[7:0] FIFO_tx_din;
        wire FIFO_tx_ack;
        wire FIFO_tx_BT;
        wire FIFO_tx_ready;
        
        wire FIFO_rx_full;
        wire FIFO_rx_empty;
        wire FIFO_rx_enable;
        wire[7:0] FIFO_rx_dout;
        wire FIFO_rx_valid;
        wire FIFO_rx_BT;
        wire FIFO_rx_ready;
        wire FIFO_rx_Block_rdy;       
        
        
    USB_Driver USB_Driver(
        .clk(clk),
        
        .okUH(okUH),
        .okHU(okHU),
        .okUHU(okUHU),
        .okAA(okAA),
        
        .PC_rx_async(PC_rx_async),
        .PC_tx_async(PC_tx_async),
        
        .FIFO_tx_full(FIFO_tx_full),
        .FIFO_tx_empty(FIFO_tx_empty),
        .FIFO_tx_enable(FIFO_tx_enable),
        .FIFO_tx_din(FIFO_tx_din),
        .FIFO_tx_ack(FIFO_tx_ack),
        .FIFO_tx_BT(FIFO_tx_BT),
        .FIFO_tx_ready(FIFO_tx_ready),
        
        .FIFO_rx_full(FIFO_rx_full),
        .FIFO_rx_empty(FIFO_rx_empty),
        .FIFO_rx_enable(FIFO_rx_enable),
        .FIFO_rx_dout(FIFO_rx_dout),
        .FIFO_rx_valid(FIFO_rx_valid),
        .FIFO_rx_BT(FIFO_rx_BT),
        .FIFO_rx_ready(FIFO_rx_ready),
        .FIFO_rx_Block_rdy(FIFO_rx_Block_rdy)
    );
        
    
    
    wire[31:0] MB_flat;
    wire MB_ready;
    wire data_ready;
    wire[14:0] inq_addr;
    wire inqury_update;
    Memory_Interface Memory_Interface(
        .clk(clk),
        
        .PC_rx_async(PC_rx_async),
        .PC_tx_async(PC_tx_async),
    
        .FIFO_tx_enable(FIFO_tx_enable),
        .FIFO_tx_din(FIFO_tx_din),
        .FIFO_tx_BT(FIFO_tx_BT),
        .FIFO_tx_ready(FIFO_tx_ready),
        
        .FIFO_rx_empty(FIFO_rx_empty),
        .FIFO_rx_enable(FIFO_rx_enable),
        .FIFO_rx_dout(FIFO_rx_dout),
        .FIFO_rx_BT(FIFO_rx_BT),
        .FIFO_rx_ready(FIFO_rx_ready),
        .FIFO_rx_Block_rdy(FIFO_rx_Block_rdy),
        
        .MB_flat(MB_flat),
        .MB_ready(MB_ready),
        .data_ready(data_ready),
        .inq_addr(inq_addr),
        .inqury_update(inqury_updata)
    );
     
     
    wire[1:0] mode;
    wire[31:0] residual_flat;
    wire residual_ready;
    wire DCT_clear;
    
    Intra_Top Intra_prediction_unit(
        .clk(clk),
        
        .MB_flat(MB_flat),
        .MB_ready(MB_ready),
        .data_ready(data_ready),
        .inq_addr(inq_addr),
        .inq_update(inqury_update),
        
        .mode(mode),
        .residual_flat(residual_flat),
        .residual_ready(residual_flat),
        .DCT_clear(DCT_clear)
    );    
     
    
    
    
    
    
    
    
    
    
endmodule
