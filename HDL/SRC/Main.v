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
        wire[31:0] FIFO_tx_din;
        wire FIFO_tx_BT;
        wire FIFO_tx_block_full;

        
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
        .FIFO_tx_BT(FIFO_tx_BT),
        .FIFO_tx_block_full(FIFO_tx_block_full),
        
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
    wire frame_complete;
    wire[14:0] inq_addr;
    wire inqury_update;
    Memory_Interface Memory_Interface(
        .clk(clk),
        
        .PC_rx_async(PC_rx_async),
        
        .FIFO_rx_empty(FIFO_rx_empty),
        .FIFO_rx_enable(FIFO_rx_enable),
        .FIFO_rx_dout(FIFO_rx_dout),
        .FIFO_rx_BT(FIFO_rx_BT),
        .FIFO_rx_ready(FIFO_rx_ready),
        .FIFO_rx_Block_rdy(FIFO_rx_Block_rdy),
        
        .MB_flat(MB_flat),
        .MB_ready(MB_ready),
        .data_ready(data_ready),
        .frame_complete(frame_complete),
        .inq_addr(inq_addr),
        .inqury_update(inqury_update),
        
        .debug_status_memory(PC_tx_async[7:3])
    );
     
     
    wire[1:0] mode;
    wire[127:0] residual_flat;
    wire residual_ready;
    wire DCT_busy;
    wire[5:0] debug_cur_horizontal;
    wire[5:0] debug_cur_vertical;
    
    Intra_Top Intra_prediction_unit(
        .clk(clk),
        
        .MB_flat(MB_flat),
        .MB_ready(MB_ready),
        .data_ready(data_ready),
        .Process_start(PC_rx_async[0]),
        .inq_addr(inq_addr),
        .inq_update(inqury_update),
        .frame_complete(frame_complete),
        
        .mode(mode),
        .residual_flat(residual_flat),
        .residual_ready(residual_ready),
        .DCT_busy(DCT_busy),
        .mode_select(PC_rx_async[2:1]),
        
        .debug_status_intra(PC_tx_async[2:0]),
        .debug_cur_vertical(debug_cur_vertical),
        .debug_cur_horizontal(debug_cur_horizontal)
    );    
     
    
    wire MB_ready_out;
    wire quantize_ready;
    wire[127:0] quantize_data;
    wire[7:0] entropy_data;
    wire entropy_ready;
    
    
    assign MB_ready_out = MB_ready & inqury_update & data_ready;
    
    Output_Top Output_parsar(
        .clk(clk),
        .mode_select(PC_rx_async[4:3]),
        
        .residual_flat(residual_flat),
        .residual_ready(residual_ready),
        
        .quantized_flat(quantize_data),
        .quantized_ready(quantize_ready),
        
        .MB_flat(MB_flat),
        .MB_ready(MB_ready_out),               
        
        .frame_complete(frame_complete),
        .Parsar_busy(DCT_busy),
        
        .FIFO_tx_din(FIFO_tx_din),
        .FIFO_tx_enable(FIFO_tx_enable),
        .FIFO_tx_block_full(FIFO_tx_block_full)
        );
        

    
    coretransform coretransform(
        .clk(clk),
        
        .data_ready(residual_ready),
        .data_matrix(residual_flat),
        
        .quantize_ready(quantize_ready),
        .quantize_data(quantize_data)
        
        
        );
        
    cavlc entropy_encoding(
        .clk(clk),
        .enable(1'b1),
        
        .valid(quantize_ready),
        .block_in(quantize_data),
        
        .data_out(entropy_data),
        .out_valid(entropy_ready));    
        
        
    ila_0 ila(
        .clk(clk),
        .probe0(PC_tx_async[7:0]),
        .probe1({inqury_update,MB_ready,residual_ready}),
        .probe2({frame_complete,FIFO_tx_enable,FIFO_tx_block_full,FIFO_tx_full,FIFO_tx_empty}),
        .probe3(FIFO_tx_din),
        .probe4(inq_addr),
        .probe5(PC_rx_async[4:0]),
        .probe6({debug_cur_horizontal,debug_cur_vertical})
        );    
    
    
    
    
    
    
endmodule
