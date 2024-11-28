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
    output wire[1:0] led,
    
    //Interfacing With USB Driver async signals
    input  wire[31:0] PC_rx_async,
    output wire[31:0] PC_tx_async,
 
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
    input wire frame_complete,
    input wire[14:0] inq_addr,
    input wire inqury_update     
    );
   
    reg wea_1;
    reg wea_2;
    reg wea_3;
    reg wea_4;
    reg [13:0] addra;  
    reg [13:0] addrb;
    reg [7:0] dina;     
    wire[7:0] doutb_1;
    wire[7:0] doutb_2;     
    wire[7:0] doutb_3;
    wire[7:0] doutb_4;
               
    dist_mem_gen_0 RAM_1(
        .a(addra),
        .d(dina),
        .we(wea_1),
        .dpra(addrb),
        .dpo(doutb_1),
        .clk(clk));   
    
    dist_mem_gen_0 RAM_2(
        .a(addra),
        .d(dina),
        .we(wea_2),
        .dpra(addrb),
        .dpo(doutb_2),
        .clk(clk));

    dist_mem_gen_0 RAM_3(
        .a(addra),
        .d(dina),
        .we(wea_3),
        .dpra(addrb),
        .dpo(doutb_3),
        .clk(clk));
      
    dist_mem_gen_0 RAM_4(
        .a(addra),
        .d(dina),
        .we(wea_4),
        .dpra(addrb),
        .dpo(doutb_4),
        .clk(clk));
        

                    
    
    reg[7:0] horizontal_addr_wr;
    reg[7:0] vertical_addr_wr;    
    reg[2:0] cur_state_wr;
    localparam IDLE = 2'b00;
    localparam Hold = 2'b01;
    localparam Read = 2'b10;

    reg DRAM_write_complete;
    reg DRAM_read_complete;
    
    reg[1:0] cur_state_MB;

    initial begin
        DRAM_read_complete   <= 1'b1;
        DRAM_write_complete  <= 1'b0;
        
        horizontal_addr_wr   <= 8'd0;
        vertical_addr_wr     <= 8'd0;
        
        cur_state_wr         <= IDLE;
        cur_state_MB                <= 2'b00;
        
        wea_1 <= 1'b0;
        wea_2 <= 1'b0;
        wea_3 <= 1'b0;
        wea_4 <= 1'b0;
        addra <= 14'd0;
        addrb <= 14'd0;
        dina <= 8'd0;
        
        MB_ready <= 1'b0;
        MB_flat <= 32'd0;
        
        FIFO_rx_ready <=  1'b0;
        FIFO_rx_enable <= 1'b0;
        
        
    end     
    
    //Distributed RAM write sequences
    always @(posedge clk) begin
        case (cur_state_wr)
            IDLE: begin
                wea_1 <= 1'b0;
                wea_2 <= 1'b0;
                wea_3 <= 1'b0;
                wea_4 <= 1'b0;
                FIFO_rx_ready <= DRAM_read_complete;
                if (FIFO_rx_empty == 1'b0) begin
                    cur_state_wr           <= Hold;
                    horizontal_addr_wr     <= 8'd0;
                    vertical_addr_wr       <= 8'd0;
                    DRAM_write_complete <= 1'b0;
                end else begin
                    cur_state_wr <= IDLE;
                end    
            end
            Hold : begin
                wea_1 <= 1'b0;
                wea_2 <= 1'b0;
                wea_3 <= 1'b0;
                wea_4 <= 1'b0;                
                if (FIFO_rx_Block_rdy == 1'b0) begin
                    cur_state_wr        <= Read;
                    FIFO_rx_enable      <= 1'b1;
                    FIFO_rx_ready       <= 1'b0;
                end else begin
                    FIFO_rx_ready       <= 1'b1;
                end               
            end
            Read : begin
                dina  <= FIFO_rx_dout;
                addra <= {vertical_addr_wr[7:1],horizontal_addr_wr[7:1]};
                wea_1 <= ~horizontal_addr_wr[0] & ~vertical_addr_wr[0];
                wea_2 <=  horizontal_addr_wr[0] & ~vertical_addr_wr[0];
                wea_3 <= ~horizontal_addr_wr[0] &  vertical_addr_wr[0];
                wea_4 <=  horizontal_addr_wr[0] &  vertical_addr_wr[0];
                horizontal_addr_wr <= horizontal_addr_wr + 1;
                if (horizontal_addr_wr == 8'd255) begin
                    FIFO_rx_enable <= 1'b0;
                    if (vertical_addr_wr == 8'd255) begin
                        cur_state_wr <= IDLE;
                        DRAM_write_complete <= 1'b1;
                    end else begin
                        cur_state_wr <= Hold;
                        vertical_addr_wr <= vertical_addr_wr + 1;
                    end
                end             
            end
        endcase
    end
    
    assign data_ready = DRAM_write_complete;
    
    always @ (posedge clk) begin
        case (cur_state_MB)
            2'd0 : begin
                if (inqury_update == 1'b1) begin
                    DRAM_read_complete <= frame_complete; 
                    cur_state_MB <= 2'd1;
                    addrb <= inq_addr;
                    MB_ready <= 1'b0;
                end
                else MB_ready <= 1'b1;        
            end
            2'd1 : begin
                cur_state_MB <= 2'd2;
            end
            2'd2 : begin
                cur_state_MB <= 2'd0;
                MB_flat <= {doutb_4,doutb_3,doutb_2,doutb_1};
                MB_ready <= 1'b1;
            end
        endcase    
    end
    
    assign led[0] = &cur_state_wr;
    assign led[1] = &cur_state_MB;
       
         
    
    
    
      
   
                           
        
    
    
endmodule
