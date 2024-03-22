`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/21 22:02:23
// Design Name: 
// Module Name: main
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


module main(    input  clk_i,
                input  reset_in,
                input  trigger_i,
                input [255:0][7:0]org_data_i,
                input [15:0][7:0]ref_data_i,
                
                output[255:0][7:0]residual_o,
                output ready_o
    );
    
integer itr =0;
integer idx =0;
reg [3:0] ptr;
reg [255:0]residual_r[7:0];
reg ready_r;

assign ready_o = ready_r;
assign residual_o[0] = residual_r[0];
genvar i;
generate
    for (i = 1; i <= 255; i = i + 1) begin : ASSIGN_LOOP
        assign residual_o[i] = residual_r[i];
    end
endgenerate
always @(posedge clk_i) begin
    if (trigger_i == 1'b1)begin
    ready_r <= 1'b0;
    itr <= 0;
    end
    if (ready_o == 1'b0)begin
        for (ptr =0; ptr<15; ptr = ptr+1) begin
            residual_r[ptr+itr*16] <= org_data_i[itr*8+ptr] - ref_data_i[ptr];
        end 
        itr <= itr+1;
        if (itr == 16) begin
            ready_r <=0;
        end
    end
end
 
endmodule
