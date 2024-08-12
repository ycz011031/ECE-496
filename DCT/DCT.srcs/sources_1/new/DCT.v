`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/11 10:42:50
// Design Name: 
// Module Name: DCT
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


module h264dctransform #(
    parameter TOGETHER = 0 // 1 if output kept together as one block
)(
    input CLK2,              // fast clock
    input RESET,             // reset when 1
    output reg READYI = 0,   // set when ready for ENABLE
    input ENABLE,            // values input only when this is 1
    input [15:0] XXIN,       // input data values (reverse order)
    output reg VALID = 0,    // values output only when this is 1
    output reg [15:0] YYOUT, // output values (reverse order)
    input READYO             // set when ready for ENABLE
);

    reg [15:0] xxii = 0;
    reg enablei = 0;
    reg [15:0] xx00 = 0;
    reg [15:0] xx01 = 0;
    reg [15:0] xx10 = 0;
    reg [15:0] xx11 = 0;
    reg [1:0] ixx = 2'b00;
    reg iout = 0;

    always @(posedge CLK2) begin
        READYI <= ~iout;

        if (RESET == 1) begin
            ixx <= 2'b00;
            iout <= 0;
        end

        enablei <= ENABLE;
        xxii <= XXIN;

        if (enablei == 1 && RESET == 0) begin // input in raster scan order
            if (ixx == 2'b00) begin
                xx00 <= xxii;
            end else if (ixx == 2'b01) begin
                xx00 <= xx00 + xxii; // compute 2nd stage
                xx01 <= xx00 - xxii;
            end else if (ixx == 2'b10) begin
                xx10 <= xxii;
            end else begin
                xx10 <= xx10 + xxii; // compute 2nd stage
                xx11 <= xx10 - xxii;
                iout <= 1;
            end
            ixx <= ixx + 1;
        end

        if (iout == 1 && (READYO == 1 || (TOGETHER == 1 && ixx != 0)) && RESET == 0) begin
            if (ixx == 2'b00) begin
                YYOUT <= xx00 + xx10; // out in raster scan order
            end else if (ixx == 2'b01) begin
                YYOUT <= xx01 + xx11;
            end else if (ixx == 2'b10) begin
                YYOUT <= xx00 - xx10;
            end else begin
                YYOUT <= xx01 - xx11;
                iout <= 0;
            end
            ixx <= ixx + 1;
            VALID <= 1;
        end else begin
            VALID <= 0;
        end
    end
endmodule