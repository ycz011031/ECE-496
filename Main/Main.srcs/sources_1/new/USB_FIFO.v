`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/05 21:01:26
// Design Name: 
// Module Name: USB_FIFO
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


module USB_Driver(
    input wire clk,
    input wire rst,
    
    //USB API PORTS
    input  wire[4:0] okUH,
    output wire[2:0] okHU,
    inout  wire[31:0] okUHU,
    inout  wire okAA,
    
    //Async signals
    input  wire[31:0] PC_rx_async,
    output wire[31:0] PC_tx_async,
    
    //FIFO interface
    // tx signals
    output wire FIFO_tx_full,
    output wire FIFO_tx_empty,
    input  wire FIFO_tx_enable,
    input  wire[7:0] FIFO_tx_din,
    output wire FIFO_tx_ack,
    output wire FIFO_tx_BT,
    input  wire FIFO_tx_ready,
    
    output wire FIFO_rx_full,
    output wire FIFO_rx_empty,
    input  wire FIFO_rx_enable,
    output wire[7:0] FIFO_rx_dout,
    output wire FIFO_rx_valid,
    output wire FIFO_rx_BT,
    input  wire FIFO_rx_ready    
    );
    
    wire okClk;            //These are FrontPanel wires needed to IO communication    
    wire [112:0]    okHE;  //These are FrontPanel wires needed to IO communication    
    wire [64:0]     okEH;  //These are FrontPanel wires needed to IO communication     
    //This is the OK host that allows data to be sent or recived    
    okHost hostIF (
        .okUH(okUH),
        .okHU(okHU),
        .okUHU(okUHU),
        .okClk(okClk),
        .okAA(okAA),
        .okHE(okHE),
        .okEH(okEH)
    );
    
    localparam  endPt_count = 2;
    wire [endPt_count*65-1:0] okEHx;  
    okWireOR # (.N(endPt_count)) wireOR (okEH, okEHx);  
    
    
    
    okWireIn wire_00 (   .okHE(okHE), 
                        .ep_addr(8'h00), 
                        .ep_dataout(PC_rx_async));
    
    
    okWireOut wire_20 (  .okHE(okHE), 
                        .okEH(okEHx[ 0*65 +: 65 ]),
                        .ep_addr(8'h20), 
                        .ep_datain(PC_tx_async));
    
    
    wire[31:0] PC_rx_sync;
    wire[31:0] PC_tx_sync;
    wire PC_rx_sync_wr;
    wire PC_tx_sync_rd;

        
    okBTPipeOut Pipe_a0 (
        .okHE(okHE), 
        .okEH(okEHx[ 1*65 +: 65 ]),
        .ep_addr(8'ha0), 
        .ep_datain(PC_tx_sync), 
        .ep_read(PC_tx_sync_rd),
        .ep_blockstrobe(FIFO_tx_BT), 
        .ep_ready(FIFO_tx_ready)
    ); 
    
    okBTPipeIn Pipe_80 (
        .okHE(okHE), 
        .okEH(okEH),
        .ep_addr(8'h80), 
        .ep_dataout(PC_rx_sync), 
        .ep_write(PC_rx_sync_wr),
        .ep_blockstrobe(FIFO_rx_BT), 
        .ep_ready(FIFO_rx_ready));
        

    
    fifo_generator_0  PC_tx_FIFO(
        .wr_clk(clk),
        .rd_clk(okClk),
        .din(FIFO_tx_din),
        .wr_en(FIFO_tx_enable),
        .rd_en(PC_tx_sync_rd),
        .dout(PC_tx_sync),
        .full(FIFO_tx_full),
        .empty(FIFO_tx_empty),
        .wr_ack(FIFO_tx_ack)
    );
    
    fifo_generator_1 PC_rx_FIFO(
        .wr_clk(okClk),
        .rd_clk(clk),
        .din(PC_rx_sync),
        .wr_en(PC_rx_sync_wr),
        .rd_en(FIFO_rx_enable),
        .dout(FIFO_data_out),
        .full(FIFO_rx_full),
        .empty(FIFO_rx_empty),
        .valid(FIFO_rx_valid)
    );   
    
     
    
endmodule
