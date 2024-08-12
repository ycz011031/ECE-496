`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/11 13:29:47
// Design Name: 
// Module Name: Quantise
// Project Name: 
// Target Devices: 0
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


module h264quantise(
    input wire CLK,                // Pixel clock
    input wire ENABLE,             // Values transferred only when this is 1
    input wire [5:0] QP,           // 0..51 as specified in standard
    input wire DCCI,               // 2x2 DC chroma in
    input wire [15:0] YNIN,
    output reg [11:0] ZOUT = 12'b0,
    output reg DCCO,               // 2x2 DC chroma out
    output reg VALID = 1'b0        // Enable delayed to same as YOUT timing
);

    // Internal signals
    reg [3:0] zig = 4'hF;
    reg [13:0] qmf, qmfA, qmfB, qmfC;
    reg enab1 = 1'b0, enab2 = 1'b0, enab3 = 1'b0;
    reg dcc1 = 1'b0, dcc2 = 1'b0, dcc3 = 1'b0;
    reg [15:0] yn1;
    reg [30:0] zr;
    reg [15:0] zz;
    reg [2:0] rr;

    // Quantisation multiplier factors
    always @(*) begin
        case (QP)
            6'd0, 6'd6, 6'd12, 6'd18, 6'd24, 6'd30, 6'd36, 6'd42, 6'd48: qmfA = 14'd13107;
            6'd1, 6'd7, 6'd13, 6'd19, 6'd25, 6'd31, 6'd37, 6'd43, 6'd49: qmfA = 14'd11916;
            6'd2, 6'd8, 6'd14, 6'd20, 6'd26, 6'd32, 6'd38, 6'd44, 6'd50: qmfA = 14'd10082;
            6'd3, 6'd9, 6'd15, 6'd21, 6'd27, 6'd33, 6'd39, 6'd45, 6'd51: qmfA = 14'd9362;
            6'd4, 6'd10, 6'd16, 6'd22, 6'd28, 6'd34, 6'd40, 6'd46: qmfA = 14'd8192;
            default: qmfA = 14'd7282;
        endcase

        case (QP)
            6'd0, 6'd6, 6'd12, 6'd18, 6'd24, 6'd30, 6'd36, 6'd42, 6'd48: qmfB = 14'd5243;
            6'd1, 6'd7, 6'd13, 6'd19, 6'd25, 6'd31, 6'd37, 6'd43, 6'd49: qmfB = 14'd4660;
            6'd2, 6'd8, 6'd14, 6'd20, 6'd26, 6'd32, 6'd38, 6'd44, 6'd50: qmfB = 14'd4194;
            6'd3, 6'd9, 6'd15, 6'd21, 6'd27, 6'd33, 6'd39, 6'd45, 6'd51: qmfB = 14'd3647;
            6'd4, 6'd10, 6'd16, 6'd22, 6'd28, 6'd34, 6'd40, 6'd46: qmfB = 14'd3355;
            default: qmfB = 14'd2893;
        endcase

        case (QP)
            6'd0, 6'd6, 6'd12, 6'd18, 6'd24, 6'd30, 6'd36, 6'd42, 6'd48: qmfC = 14'd8066;
            6'd1, 6'd7, 6'd13, 6'd19, 6'd25, 6'd31, 6'd37, 6'd43, 6'd49: qmfC = 14'd7490;
            6'd2, 6'd8, 6'd14, 6'd20, 6'd26, 6'd32, 6'd38, 6'd44, 6'd50: qmfC = 14'd6554;
            6'd3, 6'd9, 6'd15, 6'd21, 6'd27, 6'd33, 6'd39, 6'd45, 6'd51: qmfC = 14'd5825;
            6'd4, 6'd10, 6'd16, 6'd22, 6'd28, 6'd34, 6'd40, 6'd46: qmfC = 14'd5243;
            default: qmfC = 14'd4559;
        endcase
    end

    always @(posedge CLK) begin
        if (ENABLE == 1'b0 || DCCI == 1'b1) begin
            zig <= 4'hF;
        end else begin
            zig <= zig - 1;
        end

        enab1 <= ENABLE;
        enab2 <= enab1;
        enab3 <= enab2;
        VALID <= enab3;

        dcc1 <= DCCI;
        dcc2 <= dcc1;
        dcc3 <= dcc2;
        DCCO <= dcc3;

        if (ENABLE == 1'b1) begin
            if (DCCI == 1'b1) begin
                qmf <= qmfA >> 1;
            end else if (zig == 4'h0 || zig == 4'h3 || zig == 4'h5 || zig == 4'hB) begin
                qmf <= qmfA;
            end else if (zig == 4'h4 || zig == 4'hA || zig == 4'hC || zig == 4'hF) begin
                qmf <= qmfB;
            end else begin
                qmf <= qmfC;
            end
            yn1 <= YNIN;
        end

        if (enab1 == 1'b1) begin
            zr <= yn1 * {1'b0, qmf};  // Quantize
        end

        // Two bits of rounding (and leading zero)
        // rr := b"010";			--simple round-to-middle
        // rr := b"000";			--no rounding (=> -ve numbers round away from zero)
        rr = {1'b0, zr[29], 1'b1};  // round to zero if <0.75

        if (enab2 == 1'b1) begin
            case (QP)
                6'd0: zz <= zr[28:13] + rr;
                6'd6: zz <= zr[28:13] + rr;
                6'd12: zz <= zr[28:13] + rr;
                6'd18: zz <= zr[28:13] + rr;
                6'd24: zz <= zr[28:13] + rr;
                6'd30: zz <= zr[28:13] + rr;
                6'd36: zz <= zr[28:13] + rr;
                6'd42: zz <= zr[28:13] + rr;
                default: zz <= $signed(zr[30:16]) + rr;
            endcase
        end

        if (enab3 == 1'b1) begin
            if (zz[15] == zz[14] && zz[15] == zz[13] && zz[13:2] != 14'h800) begin
                ZOUT <= zz[13:2];
            end else if (zz[15] == 1'b0) begin
                ZOUT <= 12'h7FF;  // Clip max
            end else begin
                ZOUT <= 12'h801;  // Clip min
            end
        end
    end
endmodule