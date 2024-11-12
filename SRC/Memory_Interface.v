`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/06 03:31:57
// Design Name: 
// Module Name: Memory_Interface
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


module Memory_Interface(
    input wire clk,
    
    //Interfacing With USB Driver async signals
    input  wire[31:0] PC_rx_async,
    output wire[31:0] PC_tx_async,
    
    //Interfacing With USB Driver transmit
    output wire FIFO_tx_enable,
    output wire[7:0] FIFO_tx_din,
    input  wire FIFO_tx_BT,
    output reg FIFO_tx_ready,
    
    
    //Interfacing With USB Driver recieve
    output reg FIFO_rx_enable,
    input  wire[7:0] FIFO_rx_dout,
    input  wire FIFO_rx_BT,
    output reg  FIFO_rx_ready,
    input  wire FIFO_rx_empty,
    input  wire FIFO_rx_Block_rdy,
    
    //Interfacing With Computation Unit
    output reg[31:0] MB_flat,
    output reg MB_ready,
    output wire data_ready,
    input wire[14:0] inq_addr,
    input wire inqury_update
    
      
    );
   
    reg wea_1;
    reg [14:0] addra;
    reg [7:0]dina;   
    reg [14:0] addrb;
    wire[7:0] doutb_1;        
    dist_mem_gen_0 RAM_EE(
        .a(addra),
        .d(dina),
        .we(wea_1),
        .dpra(addrb),
        .dpo(doutb_1),
        .clk(clk));
    
    reg wea_2;
    wire [7:0] doutb_2;    
    dist_mem_gen_0 RAM_EO(
        .a(addra),
        .d(dina),
        .we(wea_2),
        .dpra(addrb),
        .dpo(doutb_2),
        .clk(clk));
   
    reg wea_3; 
    wire [7:0] doutb_3;  
    dist_mem_gen_0 RAM_OO(
        .a(addra),
        .d(dina),
        .we(wea_3),
        .dpra(addrb),
        .dpo(doutb_3),
        .clk(clk));
    
    reg wea_4;
    wire [7:0] doutb_4;    
    dist_mem_gen_0 RAM_OE(
        .a(addra),
        .d(dina),
        .we(wea_4),
        .dpra(addrb),
        .dpo(doutb_4),
        .clk(clk));            
    
    reg[9:0] horizontal_addr_wr;
    reg[9:0] vertical_addr_wr;
    reg[9:0] horizonatal_addr_rd;
    reg[9:0] vertical_addr_rd;
    
    reg[2:0] cur_state;
    localparam IDLE = 2'b00;
    localparam Hold = 2'b01;
    localparam Read = 2'b10;

    
    reg[15:0] resolution_row;
    reg[15:0] resolution_col;
    reg DRAM_write_complete;
    reg DRAM_read_complete;

    initial begin
        cur_state <= IDLE;
        resolution_row <= 16'd426;
        resolution_col <= 16'd240;
    end     
    
    //Distributed RAM write sequences
    always @(posedge clk) begin
        case (cur_state)
            IDLE: begin
                FIFO_rx_ready <= DRAM_read_complete;
                if (FIFO_rx_empty == 1'b0) begin
                    cur_state <= Hold;
                    horizontal_addr_wr <= 10'd0;
                    vertical_addr_wr   <= 10'd0;
                    DRAM_write_complete <= 1'b0;
                end else begin
                    cur_state <= IDLE;
                end    
            end
            Hold : begin
                FIFO_rx_ready <= 1'b0;
                if (FIFO_rx_Block_rdy == 1'b0) begin
                    cur_state <= Read;
                    horizontal_addr_wr <= 10'd0;
                    FIFO_rx_enable <= 1'b1;
                end   
                    
            end
            Read : begin
                FIFO_rx_ready <= 1'b1;
                if (horizontal_addr_wr == 16'd426) begin
                    FIFO_rx_enable <= 1'b0;
                    if (vertical_addr_wr == 10'd239) begin
                        cur_state <= IDLE;
                        DRAM_write_complete <= 1'b1;
                    end else begin
                        cur_state <= Hold;
                        vertical_addr_wr <= vertical_addr_wr + 1;
                        horizontal_addr_wr <= 10'd0;
                    end
                end    
                else begin
                    dina <= FIFO_rx_dout;
                    addra <= vertical_addr_wr[9:1] * 426 + horizontal_addr_wr[9:1];
                    wea_1 <= ~(vertical_addr_wr[0]|horizontal_addr_wr[0]);
                    wea_2 <= ~horizontal_addr_wr[0] & vertical_addr_wr[0];
                    wea_3 <= (vertical_addr_wr[0] & horizontal_addr_wr[0]);
                    wea_4 <= (~vertical_addr_wr[0] & horizontal_addr_wr[0]);
                    horizontal_addr_wr <= horizontal_addr_wr + 1;
                end         
            end
        endcase
    end
    
    assign data_ready = DRAM_write_complete;
    reg[1:0] stage;
    always @ (posedge clk) begin
        case (stage)
            2'd0 : begin
                if (inqury_update == 1'b1) begin
                    if (inq_addr == 15'd0) DRAM_read_complete <= 1'b0;
                    if (inq_addr == 15'd25560) DRAM_read_complete <= 1'b1;
                    stage <= 2'd1;
                    addrb <= inq_addr;
                    MB_ready <= 1'b0;
                end        
            end
            2'd1 : begin
                stage <= 2'd2;
            end
            2'd2 : begin
                stage <= 2'd0;
                MB_flat <= {doutb_2,doutb_3,doutb_4,doutb_1};
                MB_ready <= 1'b1;
            end
        endcase    
    end                       
        
    
    
endmodule
