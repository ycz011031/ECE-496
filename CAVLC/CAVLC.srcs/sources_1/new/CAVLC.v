`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/07 08:10:11
// Design Name: 
// Module Name: CAVLC
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


module h264cavlc (
    input wire CLK,                    // main clock / output clock
    input wire CLK2,                   // input clock (typically twice CLK)
    input wire ENABLE,                 // values transferred only when this is 1
    output reg READY,                  // enable can fall when this is 1
    input wire [11:0] VIN,             // 12 bits max (+/- 2048)
    input wire [4:0] NIN,              // N coeffs nearby mb
    input wire SIN,                    // stream/strobe flag, copied to VS
    output reg VS,                     // stream/strobe flag sync'd with VL/VE
    output reg [24:0] VE,              // output vector VE
    output reg [4:0] VL,               // output vector VL
    output reg VALID,                  // enable delayed to same as VE/VL
    output reg [2:0] XSTATE,           // debug only
    output reg [4:0] NOUT              // N coeffs for this mb
);

    // Information collected from input when ENABLE=1 (CLK2 domain)
    reg eenable = 1'b0;                // 1 if ENABLE=1 seen
    reg eparity = 1'b0;                // which register bank to use
    reg [4:0] emaxcoeffs = 5'b00000;
    reg [4:0] etotalcoeffs = 5'b00000;
    reg [4:0] etotalzeros = 5'b00000;
    reg [1:0] etrailingones = 2'b00;   // max 3 allowed
    reg ecnz = 1'b0;                   // flag set if coeff nz so far
    reg ecgt1 = 1'b0;                  // flag set if coeff >1 so far
    reg [2:0] et1signs = 3'b000;       // signs of above (1=-ve)
    reg [3:0] erun = 4'b0000;          // run before next coeff
    reg [3:0] eindex = 4'b0000;        // index into coeff table
    reg [1:0] etable;
    reg es = 1'b0;                     // s (stream) flag
    
    // Holding buffer; CLK2 timing domain
    reg hvalidi = 1'b0;                // 1 if holding buffer valid
    reg hvalid = 1'b0;                 // 1 if holding buffer valid (delayed 1 clk)
    reg hparity = 1'b0;                // which register bank to use
    reg [4:0] hmaxcoeffs = 5'b00000;
    reg [4:0] htotalcoeffs = 5'b00000;
    reg [4:0] htotalzeros = 5'b00000;
    reg [1:0] htrailingones = 2'b00;   // max 3 allowed
    reg [1:0] htable;
    reg hs = 1'b0;                     // s (stream) flag
    reg [2:0] t1signs = 3'b000;       // signs of above (1=-ve)
    
    // Information copied from above during STATE_IDLE or RUNBF (CLK domain)
    reg [4:0] maxcoeffs = 5'b00000;
    reg [4:0] totalcoeffs = 5'b00000;
    reg [4:0] totalzeros = 5'b00000;
    reg [1:0] trailingones = 2'b00;   // max 3 allowed
    reg parity = 1'b0;
    
    reg [11:0] coeff;
    reg [4:0] tmpindex;                // which register bank to use
    
    // States private to this processing engine
    localparam [2:0] STATE_IDLE   = 3'b000;
    localparam [2:0] STATE_READ   = 3'b001;
    localparam [2:0] STATE_CTOKEN = 3'b010;
    localparam [2:0] STATE_T1SIGN = 3'b011;
    localparam [2:0] STATE_COEFFS = 3'b100;
    localparam [2:0] STATE_TZEROS = 3'b101;
    localparam [2:0] STATE_RUNBF  = 3'b110;
    reg [2:0] state = STATE_IDLE;
    
    // Runbefore subprocessor state
    reg rbstate = 1'b0;               // 1=running 0=done
    
    // Stuff used during processing
    reg [3:0] cindex = 4'b0000;      // index into coeff table
    reg [10:0] abscoeff;
    reg [10:0] abscoeffa;            // adjusted version of abscoeff
    reg signcoeff = 1'b0;
    reg [2:0] suffixlen;             // 0..6
    reg [3:0] rbindex = 4'b0000;     // index into coeff table
    reg [3:0] runb = 4'b0000;        // run before next coeff
    reg [4:0] rbzerosleft = 5'b00000;
    reg [24:0] rbve = 25'b0000000000000000000000000;
    reg [4:0] rbvl = 5'b00000;
    
    // Tables
    reg [5:0] coeff_token;
    reg [4:0] ctoken_len;
    localparam [2:0] CTABLE0 = 3'b000;
    localparam [2:0] CTABLE1 = 3'b001;
    localparam [2:0] CTABLE2 = 3'b010;
    localparam [2:0] CTABLE3 = 3'b011;
    localparam [2:0] CTABLE4 = 3'b100;
    reg [2:0] ctable = CTABLE0;
    reg [2:0] ztoken;
    reg [3:0] ztoken_len;
    reg ztable = 1'b0;
    reg [2:0] rbtoken;
    
    // Data arrays
    reg [11:0] coeffarray [31:0];
    reg [3:0] runbarray [31:0];

always @* begin
    // Default value for coeff_token
    coeff_token = 6'b000000;

    case(ctable)
        3'b000: begin
            case({trailingones, totalcoeffs})
                 10'b00000_00000: coeff_token = 6'b000001;
                 10'b00000_00001: coeff_token = 6'b000101;
                 10'b00001_00001: coeff_token = 6'b000001;
                 10'b00000_00010: coeff_token = 6'b000111;
                 10'b00001_00010: coeff_token = 6'b000100;
                 10'b00010_00010: coeff_token = 6'b000001;
                 10'b00000_00011: coeff_token = 6'b000111;
                 10'b00001_00011: coeff_token = 6'b000110;
                 10'b00010_00011: coeff_token = 6'b000101;
                 10'b00011_00011: coeff_token = 6'b000011;
                 10'b00000_00100: coeff_token = 6'b000111;
                 10'b00001_00100: coeff_token = 6'b000110;
                 10'b00010_00100: coeff_token = 6'b000101;
                 10'b00011_00100: coeff_token = 6'b000011;
                 10'b00000_00101: coeff_token = 6'b000111;
                 10'b00001_00101: coeff_token = 6'b000110;
                 10'b00010_00101: coeff_token = 6'b000101;
                 10'b00011_00101: coeff_token = 6'b000100;
                 10'b00000_00110: coeff_token = 6'b001111;
                 10'b00001_00110: coeff_token = 6'b000110;
                 10'b00010_00110: coeff_token = 6'b000101;
                 10'b00011_00110: coeff_token = 6'b000100;
                 10'b00000_00111: coeff_token = 6'b001011;
                 10'b00001_00111: coeff_token = 6'b001110;
                 10'b00010_00111: coeff_token = 6'b000101;
                 10'b00011_00111: coeff_token = 6'b000100;
                 10'b00000_01000: coeff_token = 6'b001000;
                 10'b00001_01000: coeff_token = 6'b001010;
                 10'b00010_01000: coeff_token = 6'b001101;
                 10'b00011_01000: coeff_token = 6'b000100;
                 10'b00000_01001: coeff_token = 6'b001111;
                 10'b00001_01001: coeff_token = 6'b001110;
                 10'b00010_01001: coeff_token = 6'b001001;
                 10'b00011_01001: coeff_token = 6'b000100;
                 10'b00000_01010: coeff_token = 6'b001011;
                 10'b00001_01010: coeff_token = 6'b001010;
                 10'b00010_01010: coeff_token = 6'b001101;
                 10'b00011_01010: coeff_token = 6'b001100;
                 10'b00000_01011: coeff_token = 6'b001111;
                 10'b00001_01011: coeff_token = 6'b001110;
                 10'b00010_01011: coeff_token = 6'b001001;
                 10'b00011_01011: coeff_token = 6'b001100;
                 10'b00000_01100: coeff_token = 6'b001011;
                 10'b00001_01100: coeff_token = 6'b001010;
                 10'b00010_01100: coeff_token = 6'b001101;
                 10'b00011_01100: coeff_token = 6'b001000;
                 10'b00000_01101: coeff_token = 6'b001111;
                 10'b00001_01101: coeff_token = 6'b000001;
                 10'b00010_01101: coeff_token = 6'b001001;
                 10'b00011_01101: coeff_token = 6'b001100;
                 10'b00000_01110: coeff_token = 6'b001011;
                 10'b00001_01110: coeff_token = 6'b001110;
                 10'b00010_01110: coeff_token = 6'b001101;
                 10'b00011_01110: coeff_token = 6'b001000;
                 10'b00000_01111: coeff_token = 6'b000111;
                 10'b00001_01111: coeff_token = 6'b001010;
                 10'b00010_01111: coeff_token = 6'b001001;
                 10'b00011_01111: coeff_token = 6'b001100;
                 10'b00000_10000: coeff_token = 6'b000100;
                 10'b00001_10000: coeff_token = 6'b000110;
                 10'b00010_10000: coeff_token = 6'b000101;
                 10'b00011_10000: coeff_token = 6'b001000;
                 default: coeff_token = 6'b000000;
            endcase
        end
        3'b001: begin
             case({trailingones, totalcoeffs})
                    10'b00000_00000: coeff_token = 6'b000011;
                    10'b00000_00001: coeff_token = 6'b001011;
                    10'b00001_00001: coeff_token = 6'b000010;
                    10'b00000_00010: coeff_token = 6'b000111;
                    10'b00001_00010: coeff_token = 6'b000111;
                    10'b00010_00010: coeff_token = 6'b000011;
                    10'b00000_00011: coeff_token = 6'b000111;
                    10'b00001_00011: coeff_token = 6'b001010;
                    10'b00010_00011: coeff_token = 6'b001001;
                    10'b00011_00011: coeff_token = 6'b000101;
                    10'b00000_00100: coeff_token = 6'b000111;
                    10'b00001_00100: coeff_token = 6'b000110;
                    10'b00010_00100: coeff_token = 6'b000101;
                    10'b00011_00100: coeff_token = 6'b000100;
                    10'b00000_00101: coeff_token = 6'b000100;
                    10'b00001_00101: coeff_token = 6'b000110;
                    10'b00010_00101: coeff_token = 6'b000101;
                    10'b00011_00101: coeff_token = 6'b000110;
                    10'b00000_00110: coeff_token = 6'b000111;
                    10'b00001_00110: coeff_token = 6'b000110;
                    10'b00010_00110: coeff_token = 6'b000101;
                    10'b00011_00110: coeff_token = 6'b001000;
                    10'b00000_00111: coeff_token = 6'b001111;
                    10'b00001_00111: coeff_token = 6'b000110;
                    10'b00010_00111: coeff_token = 6'b000101;
                    10'b00011_00111: coeff_token = 6'b000100;
                    10'b00000_01000: coeff_token = 6'b001011;
                    10'b00001_01000: coeff_token = 6'b001110;
                    10'b00010_01000: coeff_token = 6'b001101;
                    10'b00011_01000: coeff_token = 6'b000100;
                    10'b00000_01001: coeff_token = 6'b001111;
                    10'b00001_01001: coeff_token = 6'b001010;
                    10'b00010_01001: coeff_token = 6'b001001;
                    10'b00011_01001: coeff_token = 6'b000100;
                    10'b00000_01010: coeff_token = 6'b001011;
                    10'b00001_01010: coeff_token = 6'b001110;
                    10'b00010_01010: coeff_token = 6'b001101;
                    10'b00011_01010: coeff_token = 6'b001100;
                    10'b00000_01011: coeff_token = 6'b001000;
                    10'b00001_01011: coeff_token = 6'b001010;
                    10'b00010_01011: coeff_token = 6'b001001;
                    10'b00011_01011: coeff_token = 6'b001000;
                    10'b00000_01100: coeff_token = 6'b001111;
                    10'b00001_01100: coeff_token = 6'b001110;
                    10'b00010_01100: coeff_token = 6'b001101;
                    10'b00011_01100: coeff_token = 6'b001100;
                    10'b00000_01101: coeff_token = 6'b001011;
                    10'b00001_01101: coeff_token = 6'b001010;
                    10'b00010_01101: coeff_token = 6'b001001;
                    10'b00011_01101: coeff_token = 6'b001100;
                    10'b00000_01110: coeff_token = 6'b000111;
                    10'b00001_01110: coeff_token = 6'b001011;
                    10'b00010_01110: coeff_token = 6'b000110;
                    10'b00011_01110: coeff_token = 6'b001000;
                    10'b00000_01111: coeff_token = 6'b001001;
                    10'b00001_01111: coeff_token = 6'b001000;
                    10'b00010_01111: coeff_token = 6'b001010;
                    10'b00011_01111: coeff_token = 6'b000001;
                    10'b00000_10000: coeff_token = 6'b000111;
                    10'b00001_10000: coeff_token = 6'b000110;
                    10'b00010_10000: coeff_token = 6'b000101;
                    10'b00011_10000: coeff_token = 6'b000100;
                    default: coeff_token = 6'b000000;
                endcase
            end
        3'b010: begin
            case({trailingones, totalcoeffs})
                    10'b00000_00000: coeff_token = 6'b001111;
                    10'b00000_00001: coeff_token = 6'b001111;
                    10'b00001_00001: coeff_token = 6'b001110;
                    10'b00000_00010: coeff_token = 6'b001011;
                    10'b00001_00010: coeff_token = 6'b001111;
                    10'b00010_00010: coeff_token = 6'b001101;
                    10'b00000_00011: coeff_token = 6'b001000;
                    10'b00001_00011: coeff_token = 6'b001100;
                    10'b00010_00011: coeff_token = 6'b001110;
                    10'b00011_00011: coeff_token = 6'b001100;
                    10'b00000_00100: coeff_token = 6'b001111;
                    10'b00001_00100: coeff_token = 6'b001010;
                    10'b00010_00100: coeff_token = 6'b001011;
                    10'b00011_00100: coeff_token = 6'b001011;
                    10'b00000_00101: coeff_token = 6'b001011;
                    10'b00001_00101: coeff_token = 6'b001000;
                    10'b00010_00101: coeff_token = 6'b001001;
                    10'b00011_00101: coeff_token = 6'b001010;
                    10'b00000_00110: coeff_token = 6'b001001;
                    10'b00001_00110: coeff_token = 6'b001110;
                    10'b00010_00110: coeff_token = 6'b001101;
                    10'b00011_00110: coeff_token = 6'b001001;
                    10'b00000_00111: coeff_token = 6'b001000;
                    10'b00001_00111: coeff_token = 6'b001010;
                    10'b00010_00111: coeff_token = 6'b001001;
                    10'b00011_00111: coeff_token = 6'b001000;
                    10'b00000_01000: coeff_token = 6'b001111;
                    10'b00001_01000: coeff_token = 6'b001110;
                    10'b00010_01000: coeff_token = 6'b001101;
                    10'b00011_01000: coeff_token = 6'b001101;
                    10'b00000_01001: coeff_token = 6'b001011;
                    10'b00001_01001: coeff_token = 6'b001110;
                    10'b00010_01001: coeff_token = 6'b001010;
                    10'b00011_01001: coeff_token = 6'b001100;
                    10'b00000_01010: coeff_token = 6'b001111;
                    10'b00001_01010: coeff_token = 6'b001010;
                    10'b00010_01010: coeff_token = 6'b001101;
                    10'b00011_01010: coeff_token = 6'b001100;
                    10'b00000_01011: coeff_token = 6'b001011;
                    10'b00001_01011: coeff_token = 6'b001110;
                    10'b00010_01011: coeff_token = 6'b001001;
                    10'b00011_01011: coeff_token = 6'b001100;
                    10'b00000_01100: coeff_token = 6'b001000;
                    10'b00001_01100: coeff_token = 6'b001010;
                    10'b00010_01100: coeff_token = 6'b001101;
                    10'b00011_01100: coeff_token = 6'b001000;
                    10'b00000_01101: coeff_token = 6'b001101;
                    10'b00001_01101: coeff_token = 6'b000111;
                    10'b00010_01101: coeff_token = 6'b001001;
                    10'b00011_01101: coeff_token = 6'b001100;
                    10'b00000_01110: coeff_token = 6'b001001;
                    10'b00001_01110: coeff_token = 6'b001100;
                    10'b00010_01110: coeff_token = 6'b001011;
                    10'b00011_01110: coeff_token = 6'b001010;
                    10'b00000_01111: coeff_token = 6'b000101;
                    10'b00001_01111: coeff_token = 6'b001000;
                    10'b00010_01111: coeff_token = 6'b000111;
                    10'b00011_01111: coeff_token = 6'b000110;
                    10'b00000_10000: coeff_token = 6'b000001;
                    10'b00001_10000: coeff_token = 6'b000100;
                    10'b00010_10000: coeff_token = 6'b000011;
                    10'b00011_10000: coeff_token = 6'b000010;
                    default: coeff_token = 6'b000000;
                endcase
            end
        3'b011: begin
           case({trailingones, totalcoeffs})
                    10'b00000_00000: coeff_token = 6'b000011;
                    10'b00000_00001: coeff_token = 6'b000000;
                    10'b00001_00001: coeff_token = 6'b000001;
                    10'b00000_00010: coeff_token = 6'b000100;
                    10'b00001_00010: coeff_token = 6'b000101;
                    10'b00010_00010: coeff_token = 6'b000110;
                    10'b00000_00011: coeff_token = 6'b001000;
                    10'b00001_00011: coeff_token = 6'b001001;
                    10'b00010_00011: coeff_token = 6'b001010;
                    10'b00011_00011: coeff_token = 6'b001011;
                    10'b00000_00100: coeff_token = 6'b001100;
                    10'b00001_00100: coeff_token = 6'b001101;
                    10'b00010_00100: coeff_token = 6'b001110;
                    10'b00011_00100: coeff_token = 6'b001111;
                    10'b00000_00101: coeff_token = 6'b010000;
                    10'b00001_00101: coeff_token = 6'b010001;
                    10'b00010_00101: coeff_token = 6'b010010;
                    10'b00011_00101: coeff_token = 6'b010011;
                    10'b00000_00110: coeff_token = 6'b010100;
                    10'b00001_00110: coeff_token = 6'b010101;
                    10'b00010_00110: coeff_token = 6'b010110;
                    10'b00011_00110: coeff_token = 6'b010111;
                    10'b00000_00111: coeff_token = 6'b011000;
                    10'b00001_00111: coeff_token = 6'b011001;
                    10'b00010_00111: coeff_token = 6'b011010;
                    10'b00011_00111: coeff_token = 6'b011011;
                    10'b00000_01000: coeff_token = 6'b011100;
                    10'b00001_01000: coeff_token = 6'b011101;
                    10'b00010_01000: coeff_token = 6'b011110;
                    10'b00011_01000: coeff_token = 6'b011111;
                    10'b00000_01001: coeff_token = 6'b100000;
                    10'b00001_01001: coeff_token = 6'b100001;
                    10'b00010_01001: coeff_token = 6'b100010;
                    10'b00011_01001: coeff_token = 6'b100011;
                    10'b00000_01010: coeff_token = 6'b100100;
                    10'b00001_01010: coeff_token = 6'b100101;
                    10'b00010_01010: coeff_token = 6'b100110;
                    10'b00011_01010: coeff_token = 6'b100111;
                    10'b00000_01011: coeff_token = 6'b101000;
                    10'b00001_01011: coeff_token = 6'b101001;
                    10'b00010_01011: coeff_token = 6'b101010;
                    10'b00011_01011: coeff_token = 6'b101011;
                    10'b00000_01100: coeff_token = 6'b101100;
                    10'b00001_01100: coeff_token = 6'b101101;
                    10'b00010_01100: coeff_token = 6'b101110;
                    10'b00011_01100: coeff_token = 6'b101111;
                    10'b00000_01101: coeff_token = 6'b110000;
                    10'b00001_01101: coeff_token = 6'b110001;
                    10'b00010_01101: coeff_token = 6'b110010;
                    10'b00011_01101: coeff_token = 6'b110011;
                    10'b00000_01110: coeff_token = 6'b110100;
                    10'b00001_01110: coeff_token = 6'b110101;
                    10'b00010_01110: coeff_token = 6'b110110;
                    10'b00011_01110: coeff_token = 6'b110111;
                    10'b00000_01111: coeff_token = 6'b111000;
                    10'b00001_01111: coeff_token = 6'b111001;
                    10'b00010_01111: coeff_token = 6'b111010;
                    10'b00011_01111: coeff_token = 6'b111011;
                    10'b00000_10000: coeff_token = 6'b111100;
                    10'b00001_10000: coeff_token = 6'b111101;
                    10'b00010_10000: coeff_token = 6'b111110;
                    10'b00011_10000: coeff_token = 6'b111111;
                    default: coeff_token = 6'b000000;
                endcase
            end     
        3'b100: begin
                    case({trailingones, totalcoeffs})
                        10'b00000_00000: coeff_token = 6'b000001;
                        10'b00000_00001: coeff_token = 6'b000111;
                        10'b00001_00001: coeff_token = 6'b000001;
                        10'b00000_00010: coeff_token = 6'b000100;
                        10'b00001_00010: coeff_token = 6'b000110;
                        10'b00010_00010: coeff_token = 6'b000001;
                        10'b00000_00011: coeff_token = 6'b000011;
                        10'b00001_00011: coeff_token = 6'b000011;
                        10'b00010_00011: coeff_token = 6'b000010;
                        10'b00011_00011: coeff_token = 6'b000101;
                        10'b00000_00100: coeff_token = 6'b000010;
                        10'b00001_00100: coeff_token = 6'b000011;
                        10'b00010_00100: coeff_token = 6'b000010;
                        default: coeff_token = 6'b000000;
                    endcase
                end    
        endcase
    
    
    case (ctable)
        3'b000: begin
            case ({trailingones, totalcoeffs})
                10'b00000_00000: ctoken_len = 5'b00001;
                10'b00000_00001: ctoken_len = 5'b00110;
                10'b00001_00001: ctoken_len = 5'b00010;
                10'b00000_00010: ctoken_len = 5'b01000;
                10'b00001_00010: ctoken_len = 5'b00110;
                10'b00010_00010: ctoken_len = 5'b00011;
                10'b00000_00011: ctoken_len = 5'b01001;
                10'b00001_00011: ctoken_len = 5'b01000;
                10'b00010_00011: ctoken_len = 5'b00111;
                10'b00011_00011: ctoken_len = 5'b00101;
                10'b00000_00100: ctoken_len = 5'b01010;
                10'b00001_00100: ctoken_len = 5'b01001;
                10'b00010_00100: ctoken_len = 5'b01000;
                10'b00011_00100: ctoken_len = 5'b00110;
                10'b00000_00101: ctoken_len = 5'b01011;
                10'b00001_00101: ctoken_len = 5'b01010;
                10'b00010_00101: ctoken_len = 5'b01001;
                10'b00011_00101: ctoken_len = 5'b00111;
                10'b00000_00110: ctoken_len = 5'b01101;
                10'b00001_00110: ctoken_len = 5'b01011;
                10'b00010_00110: ctoken_len = 5'b01010;
                10'b00011_00110: ctoken_len = 5'b01000;
                10'b00000_00111: ctoken_len = 5'b01101;
                10'b00001_00111: ctoken_len = 5'b01101;
                10'b00010_00111: ctoken_len = 5'b01011;
                10'b00011_00111: ctoken_len = 5'b01001;
                10'b00000_01000: ctoken_len = 5'b01101;
                10'b00001_01000: ctoken_len = 5'b01101;
                10'b00010_01000: ctoken_len = 5'b01101;
                10'b00011_01000: ctoken_len = 5'b01010;
                10'b00000_01001: ctoken_len = 5'b01110;
                10'b00001_01001: ctoken_len = 5'b01110;
                10'b00010_01001: ctoken_len = 5'b01101;
                10'b00011_01001: ctoken_len = 5'b01011;
                10'b00000_01010: ctoken_len = 5'b01110;
                10'b00001_01010: ctoken_len = 5'b01110;
                10'b00010_01010: ctoken_len = 5'b01110;
                10'b00011_01010: ctoken_len = 5'b01101;
                10'b00000_01011: ctoken_len = 5'b01111;
                10'b00001_01011: ctoken_len = 5'b01111;
                10'b00010_01011: ctoken_len = 5'b01110;
                10'b00011_01011: ctoken_len = 5'b01110;
                10'b00000_01100: ctoken_len = 5'b01111;
                10'b00001_01100: ctoken_len = 5'b01111;
                10'b00010_01100: ctoken_len = 5'b01111;
                10'b00011_01100: ctoken_len = 5'b01110;
                10'b00000_01101: ctoken_len = 5'b10000;
                10'b00001_01101: ctoken_len = 5'b01111;
                10'b00010_01101: ctoken_len = 5'b01111;
                10'b00011_01101: ctoken_len = 5'b01111;
                10'b00000_01110: ctoken_len = 5'b10000;
                10'b00001_01110: ctoken_len = 5'b10000;
                10'b00010_01110: ctoken_len = 5'b10000;
                10'b00011_01110: ctoken_len = 5'b01111;
                10'b00000_01111: ctoken_len = 5'b10000;
                10'b00001_01111: ctoken_len = 5'b10000;
                10'b00010_01111: ctoken_len = 5'b10000;
                10'b00011_01111: ctoken_len = 5'b10000;
                10'b00000_10000: ctoken_len = 5'b10000;
                10'b00001_10000: ctoken_len = 5'b10000;
                10'b00010_10000: ctoken_len = 5'b10000;
                10'b00011_10000: ctoken_len = 5'b10000;
                default: ctoken_len = 5'b00000;
            endcase
        end

        3'b001: begin
            case ({trailingones, totalcoeffs})
                10'b00000_00000: ctoken_len = 5'b00010;
                10'b00000_00001: ctoken_len = 5'b00110;
                10'b00001_00001: ctoken_len = 5'b00010;
                10'b00000_00010: ctoken_len = 5'b00110;
                10'b00001_00010: ctoken_len = 5'b00101;
                10'b00010_00010: ctoken_len = 5'b00011;
                10'b00000_00011: ctoken_len = 5'b00111;
                10'b00001_00011: ctoken_len = 5'b00110;
                10'b00010_00011: ctoken_len = 5'b00110;
                10'b00011_00011: ctoken_len = 5'b00100;
                10'b00000_00100: ctoken_len = 5'b01000;
                10'b00001_00100: ctoken_len = 5'b00110;
                10'b00010_00100: ctoken_len = 5'b00110;
                10'b00011_00100: ctoken_len = 5'b00100;
                10'b00000_00101: ctoken_len = 5'b01000;
                10'b00001_00101: ctoken_len = 5'b00111;
                10'b00010_00101: ctoken_len = 5'b00111;
                10'b00011_00101: ctoken_len = 5'b00101;
                10'b00000_00110: ctoken_len = 5'b01001;
                10'b00001_00110: ctoken_len = 5'b01000;
                10'b00010_00110: ctoken_len = 5'b01000;
                10'b00011_00110: ctoken_len = 5'b00110;
                10'b00000_00111: ctoken_len = 5'b01011;
                10'b00001_00111: ctoken_len = 5'b01001;
                10'b00010_00111: ctoken_len = 5'b01001;
                10'b00011_00111: ctoken_len = 5'b00110;
                10'b00000_01000: ctoken_len = 5'b01011;
                10'b00001_01000: ctoken_len = 5'b01011;
                10'b00010_01000: ctoken_len = 5'b01011;
                10'b00011_01000: ctoken_len = 5'b00111;
                10'b00000_01001: ctoken_len = 5'b01100;
                10'b00001_01001: ctoken_len = 5'b01011;
                10'b00010_01001: ctoken_len = 5'b01011;
                10'b00011_01001: ctoken_len = 5'b01001;
                10'b00000_01010: ctoken_len = 5'b01100;
                10'b00001_01010: ctoken_len = 5'b01100;
                10'b00010_01010: ctoken_len = 5'b01100;
                10'b00011_01010: ctoken_len = 5'b01011;
                10'b00000_01011: ctoken_len = 5'b01101;
                10'b00001_01011: ctoken_len = 5'b01101;
                10'b00010_01011: ctoken_len = 5'b01100;
                10'b00011_01011: ctoken_len = 5'b01100;
                10'b00000_01100: ctoken_len = 5'b01101;
                10'b00001_01100: ctoken_len = 5'b01101;
                10'b00010_01100: ctoken_len = 5'b01101;
                10'b00011_01100: ctoken_len = 5'b01100;
                10'b00000_01101: ctoken_len = 5'b01101;
                10'b00001_01101: ctoken_len = 5'b01101;
                10'b00010_01101: ctoken_len = 5'b01101;
                10'b00011_01101: ctoken_len = 5'b01101;
                10'b00000_01110: ctoken_len = 5'b01101;
                10'b00001_01110: ctoken_len = 5'b01101;
                10'b00010_01110: ctoken_len = 5'b01101;
                10'b00011_01110: ctoken_len = 5'b01101;
                10'b00000_01111: ctoken_len = 5'b01101;
                10'b00001_01111: ctoken_len = 5'b01101;
                10'b00010_01111: ctoken_len = 5'b01101;
                10'b00011_01111: ctoken_len = 5'b01101;
                default: ctoken_len = 5'b00000;
            endcase
        end

        3'b010: begin
            case ({trailingones, totalcoeffs})
                10'b00000_00000: ctoken_len = 5'b00101;
                10'b00000_00001: ctoken_len = 5'b00110;
                10'b00001_00001: ctoken_len = 5'b00100;
                10'b00000_00010: ctoken_len = 5'b01000;
                10'b00001_00010: ctoken_len = 5'b00110;
                10'b00010_00010: ctoken_len = 5'b00101;
                10'b00000_00011: ctoken_len = 5'b01001;
                10'b00001_00011: ctoken_len = 5'b01000;
                10'b00010_00011: ctoken_len = 5'b00111;
                10'b00011_00011: ctoken_len = 5'b00100;
                10'b00000_00100: ctoken_len = 5'b01010;
                10'b00001_00100: ctoken_len = 5'b01000;
                10'b00010_00100: ctoken_len = 5'b01000;
                10'b00011_00100: ctoken_len = 5'b00110;
                10'b00000_00101: ctoken_len = 5'b01011;
                10'b00001_00101: ctoken_len = 5'b01010;
                10'b00010_00101: ctoken_len = 5'b01001;
                10'b00011_00101: ctoken_len = 5'b00111;
                10'b00000_00110: ctoken_len = 5'b01101;
                10'b00001_00110: ctoken_len = 5'b01011;
                10'b00010_00110: ctoken_len = 5'b01010;
                10'b00011_00110: ctoken_len = 5'b01000;
                10'b00000_00111: ctoken_len = 5'b01101;
                10'b00001_00111: ctoken_len = 5'b01101;
                10'b00010_00111: ctoken_len = 5'b01011;
                10'b00011_00111: ctoken_len = 5'b01001;
                10'b00000_01000: ctoken_len = 5'b01101;
                10'b00001_01000: ctoken_len = 5'b01101;
                10'b00010_01000: ctoken_len = 5'b01101;
                10'b00011_01000: ctoken_len = 5'b01010;
                10'b00000_01001: ctoken_len = 5'b01110;
                10'b00001_01001: ctoken_len = 5'b01110;
                10'b00010_01001: ctoken_len = 5'b01101;
                10'b00011_01001: ctoken_len = 5'b01011;
                10'b00000_01010: ctoken_len = 5'b01110;
                10'b00001_01010: ctoken_len = 5'b01110;
                10'b00010_01010: ctoken_len = 5'b01110;
                10'b00011_01010: ctoken_len = 5'b01101;
                10'b00000_01011: ctoken_len = 5'b01111;
                10'b00001_01011: ctoken_len = 5'b01111;
                10'b00010_01011: ctoken_len = 5'b01110;
                10'b00011_01011: ctoken_len = 5'b01110;
                10'b00000_01100: ctoken_len = 5'b01111;
                10'b00001_01100: ctoken_len = 5'b01111;
                10'b00010_01100: ctoken_len = 5'b01111;
                10'b00011_01100: ctoken_len = 5'b01110;
                10'b00000_01101: ctoken_len = 5'b10000;
                10'b00001_01101: ctoken_len = 5'b01111;
                10'b00010_01101: ctoken_len = 5'b01111;
                10'b00011_01101: ctoken_len = 5'b01111;
                10'b00000_01110: ctoken_len = 5'b10000;
                10'b00001_01110: ctoken_len = 5'b10000;
                10'b00010_01110: ctoken_len = 5'b10000;
                10'b00011_01110: ctoken_len = 5'b01111;
                10'b00000_01111: ctoken_len = 5'b10000;
                10'b00001_01111: ctoken_len = 5'b10000;
                10'b00010_01111: ctoken_len = 5'b10000;
                10'b00011_01111: ctoken_len = 5'b10000;
                default: ctoken_len = 5'b00000;
            endcase
        end

       3'b011: begin // ctable = 3
            ctoken_len = 5'b00110; // Default case for ctable = 3
        end
        
        3'b100: begin // ctable = 4
            case ({trailingones, totalcoeffs})
                10'b00000_00000: ctoken_len = 5'b00010; // trailingones=0, totalcoeffs=0
                10'b00000_00001: ctoken_len = 5'b00110; // trailingones=0, totalcoeffs=1
                10'b00000_00010: ctoken_len = 5'b00001; // trailingones=1, totalcoeffs=1
                10'b00000_00011: ctoken_len = 5'b00110; // trailingones=0, totalcoeffs=2
                10'b00000_00100: ctoken_len = 5'b00110; // trailingones=1, totalcoeffs=2
                10'b00000_00101: ctoken_len = 5'b00011; // trailingones=2, totalcoeffs=2
                10'b00000_00110: ctoken_len = 5'b00110; // trailingones=0, totalcoeffs=3
                10'b00000_00111: ctoken_len = 5'b00111; // trailingones=1, totalcoeffs=3
                10'b00000_01000: ctoken_len = 5'b00111; // trailingones=2, totalcoeffs=3
                10'b00000_01001: ctoken_len = 5'b00110; // trailingones=3, totalcoeffs=3
                10'b00000_01010: ctoken_len = 5'b00110; // trailingones=0, totalcoeffs=4
                10'b00000_01011: ctoken_len = 5'b01000; // trailingones=1, totalcoeffs=4
                10'b00000_01100: ctoken_len = 5'b01000; // trailingones=2, totalcoeffs=4
                10'b00000_01101: ctoken_len = 5'b00111; // trailingones=3, totalcoeffs=4
                default: ctoken_len = 6'b000111; // undefined case
            endcase
        end
        default: ctoken_len = 5'b00111;
    endcase

    case (ztable)
        1'b0: begin
            case ({totalzeros, totalcoeffs})
                {4'b0000, 4'b0001}: ztoken = 3'b001;
                {4'b0001, 4'b0001}: ztoken = 3'b011;
                {4'b0010, 4'b0001}: ztoken = 3'b010;
                {4'b0011, 4'b0001}: ztoken = 3'b011;
                {4'b0100, 4'b0001}: ztoken = 3'b010;
                {4'b0101, 4'b0001}: ztoken = 3'b011;
                {4'b0110, 4'b0001}: ztoken = 3'b010;
                {4'b0111, 4'b0001}: ztoken = 3'b011;
                {4'b1000, 4'b0001}: ztoken = 3'b010;
                {4'b1001, 4'b0001}: ztoken = 3'b011;
                {4'b1010, 4'b0001}: ztoken = 3'b010;
                {4'b1011, 4'b0001}: ztoken = 3'b011;
                {4'b1100, 4'b0001}: ztoken = 3'b010;
                {4'b1101, 4'b0001}: ztoken = 3'b011;
                {4'b1110, 4'b0001}: ztoken = 3'b010;
                {4'b1111, 4'b0001}: ztoken = 3'b001;
                {4'b0000, 4'b0010}: ztoken = 3'b111;
                {4'b0001, 4'b0010}: ztoken = 3'b110;
                {4'b0010, 4'b0010}: ztoken = 3'b101;
                {4'b0011, 4'b0010}: ztoken = 3'b100;
                {4'b0100, 4'b0010}: ztoken = 3'b011;
                {4'b0101, 4'b0010}: ztoken = 3'b101;
                {4'b0110, 4'b0010}: ztoken = 3'b100;
                {4'b0111, 4'b0010}: ztoken = 3'b011;
                {4'b1000, 4'b0010}: ztoken = 3'b010;
                {4'b1001, 4'b0010}: ztoken = 3'b011;
                {4'b1010, 4'b0010}: ztoken = 3'b010;
                {4'b1011, 4'b0010}: ztoken = 3'b011;
                {4'b1100, 4'b0010}: ztoken = 3'b010;
                {4'b1101, 4'b0010}: ztoken = 3'b001;
                {4'b1110, 4'b0010}: ztoken = 3'b000;
                {4'b0000, 4'b0011}: ztoken = 3'b101;
                {4'b0001, 4'b0011}: ztoken = 3'b111;
                {4'b0010, 4'b0011}: ztoken = 3'b110;
                {4'b0011, 4'b0011}: ztoken = 3'b101;
                {4'b0100, 4'b0011}: ztoken = 3'b100;
                {4'b0101, 4'b0011}: ztoken = 3'b011;
                {4'b0110, 4'b0011}: ztoken = 3'b100;
                {4'b0111, 4'b0011}: ztoken = 3'b011;
                {4'b1000, 4'b0011}: ztoken = 3'b010;
                {4'b1001, 4'b0011}: ztoken = 3'b011;
                {4'b1010, 4'b0011}: ztoken = 3'b010;
                {4'b1011, 4'b0011}: ztoken = 3'b001;
                {4'b1100, 4'b0011}: ztoken = 3'b001;
                {4'b1101, 4'b0011}: ztoken = 3'b000;
                {4'b0000, 4'b0100}: ztoken = 3'b011;
                {4'b0001, 4'b0100}: ztoken = 3'b111;
                {4'b0010, 4'b0100}: ztoken = 3'b101;
                {4'b0011, 4'b0100}: ztoken = 3'b100;
                {4'b0100, 4'b0100}: ztoken = 3'b110;
                {4'b0101, 4'b0100}: ztoken = 3'b101;
                {4'b0110, 4'b0100}: ztoken = 3'b100;
                {4'b0111, 4'b0100}: ztoken = 3'b011;
                {4'b1000, 4'b0100}: ztoken = 3'b010;
                {4'b1001, 4'b0100}: ztoken = 3'b010;
                {4'b1010, 4'b0100}: ztoken = 3'b001;
                {4'b1011, 4'b0100}: ztoken = 3'b000;
                {4'b1100, 4'b0100}: ztoken = 3'b000;
                {4'b1101, 4'b0100}: ztoken = 3'b000;
                {4'b0000, 4'b0101}: ztoken = 3'b101;
                {4'b0001, 4'b0101}: ztoken = 3'b100;
                {4'b0010, 4'b0101}: ztoken = 3'b011;
                {4'b0011, 4'b0101}: ztoken = 3'b111;
                {4'b0100, 4'b0101}: ztoken = 3'b110;
                {4'b0101, 4'b0101}: ztoken = 3'b101;
                {4'b0110, 4'b0101}: ztoken = 3'b100;
                {4'b0111, 4'b0101}: ztoken = 3'b011;
                {4'b1000, 4'b0101}: ztoken = 3'b001;
                {4'b1001, 4'b0101}: ztoken = 3'b001;
                {4'b1010, 4'b0101}: ztoken = 3'b000;
                {4'b1011, 4'b0101}: ztoken = 3'b001;
                {4'b1100, 4'b0101}: ztoken = 3'b000;
                {4'b1101, 4'b0101}: ztoken = 3'b001;
                {4'b0000, 4'b0110}: ztoken = 3'b001;
                {4'b0001, 4'b0110}: ztoken = 3'b001;
                {4'b0010, 4'b0110}: ztoken = 3'b111;
                {4'b0011, 4'b0110}: ztoken = 3'b110;
                {4'b0100, 4'b0110}: ztoken = 3'b101;
                {4'b0101, 4'b0110}: ztoken = 3'b100;
                {4'b0110, 4'b0110}: ztoken = 3'b011;
                {4'b0111, 4'b0110}: ztoken = 3'b010;
                {4'b1000, 4'b0110}: ztoken = 3'b001;
                {4'b1001, 4'b0110}: ztoken = 3'b001;
                {4'b1010, 4'b0110}: ztoken = 3'b000;
                {4'b1011, 4'b0110}: ztoken = 3'b000;
                {4'b1100, 4'b0110}: ztoken = 3'b000;
                {4'b1101, 4'b0110}: ztoken = 3'b001;
                {4'b0000, 4'b0111}: ztoken = 3'b001;
                {4'b0001, 4'b0111}: ztoken = 3'b001;
                {4'b0010, 4'b0111}: ztoken = 3'b101;
                {4'b0011, 4'b0111}: ztoken = 3'b100;
                {4'b0100, 4'b0111}: ztoken = 3'b011;
                {4'b0101, 4'b0111}: ztoken = 3'b011;
                {4'b0110, 4'b0111}: ztoken = 3'b010;
                {4'b0111, 4'b0111}: ztoken = 3'b001;
                {4'b1000, 4'b0111}: ztoken = 3'b001;
                {4'b1001, 4'b0111}: ztoken = 3'b000;
                {4'b0000, 4'b1000}: ztoken = 3'b001;
                {4'b0001, 4'b1000}: ztoken = 3'b001;
                {4'b0010, 4'b1000}: ztoken = 3'b001;
                {4'b0011, 4'b1000}: ztoken = 3'b011;
                {4'b0100, 4'b1000}: ztoken = 3'b011;
                {4'b0101, 4'b1000}: ztoken = 3'b010;
                {4'b0110, 4'b1000}: ztoken = 3'b010;
                {4'b0111, 4'b1000}: ztoken = 3'b001;
                {4'b1000, 4'b1000}: ztoken = 3'b000;
                {4'b0000, 4'b1001}: ztoken = 3'b001;
                {4'b0001, 4'b1001}: ztoken = 3'b000;
                {4'b0010, 4'b1001}: ztoken = 3'b001;
                {4'b0011, 4'b1001}: ztoken = 3'b011;
                {4'b0100, 4'b1001}: ztoken = 3'b010;
                {4'b0101, 4'b1001}: ztoken = 3'b001;
                {4'b0110, 4'b1001}: ztoken = 3'b001;
                {4'b0111, 4'b1001}: ztoken = 3'b000;
                {4'b1000, 4'b1001}: ztoken = 3'b001;
                {4'b1001, 4'b1001}: ztoken = 3'b000;
                {4'b0000, 4'b1010}: ztoken = 3'b001;
                {4'b0001, 4'b1010}: ztoken = 3'b000;
                {4'b0010, 4'b1010}: ztoken = 3'b001;
                {4'b0011, 4'b1010}: ztoken = 3'b011;
                {4'b0100, 4'b1010}: ztoken = 3'b010;
                {4'b0101, 4'b1010}: ztoken = 3'b001;
                {4'b0110, 4'b1010}: ztoken = 3'b000;
                {4'b0111, 4'b1010}: ztoken = 3'b000;
                {4'b1000, 4'b1010}: ztoken = 3'b001;
                {4'b1001, 4'b1010}: ztoken = 3'b000;
                {4'b0000, 4'b1011}: ztoken = 3'b001;
                {4'b0001, 4'b1011}: ztoken = 3'b000;
                {4'b0010, 4'b1011}: ztoken = 3'b001;
                {4'b0011, 4'b1011}: ztoken = 3'b010;
                {4'b0100, 4'b1011}: ztoken = 3'b001;
                {4'b0101, 4'b1011}: ztoken = 3'b001;
                {4'b0110, 4'b1011}: ztoken = 3'b000;
                {4'b0111, 4'b1011}: ztoken = 3'b000;
                {4'b1000, 4'b1011}: ztoken = 3'b000;
                {4'b1001, 4'b1011}: ztoken = 3'b000;
                {4'b0000, 4'b1100}: ztoken = 3'b000;
                {4'b0001, 4'b1100}: ztoken = 3'b001;
                {4'b0010, 4'b1100}: ztoken = 3'b000;
                {4'b0011, 4'b1100}: ztoken = 3'b000;
                {4'b0100, 4'b1100}: ztoken = 3'b000;
                {4'b0101, 4'b1100}: ztoken = 3'b001;
                {4'b0110, 4'b1100}: ztoken = 3'b000;
                {4'b0111, 4'b1100}: ztoken = 3'b000;
                {4'b1000, 4'b1100}: ztoken = 3'b000;
                {4'b1001, 4'b1100}: ztoken = 3'b000;
                {4'b0000, 4'b1111}: ztoken = 3'b000;
                {4'b0001, 4'b1111}: ztoken = 3'b001;
                {4'b0010, 4'b1111}: ztoken = 3'b000;
                {4'b0011, 4'b1111}: ztoken = 3'b000;
                {4'b0100, 4'b1111}: ztoken = 3'b000;
                {4'b0101, 4'b1111}: ztoken = 3'b000;
                {4'b0110, 4'b1111}: ztoken = 3'b000;
                {4'b0111, 4'b1111}: ztoken = 3'b000;
                {4'b1000, 4'b1111}: ztoken = 3'b000;
                {4'b1001, 4'b1111}: ztoken = 3'b000;
                default: ztoken = 3'b000; // Default case
            endcase
        end
        
        1'b1: begin
            case ({totalzeros, totalcoeffs})
                {4'b0000, 4'b0001}: ztoken = 3'b001;
                {4'b0001, 4'b0001}: ztoken = 3'b001;
                {4'b0010, 4'b0001}: ztoken = 3'b001;
                {4'b0011, 4'b0001}: ztoken = 3'b000;
                {4'b0000, 4'b0010}: ztoken = 3'b001;
                {4'b0001, 4'b0010}: ztoken = 3'b001;
                {4'b0010, 4'b0010}: ztoken = 3'b000;
                {4'b0000, 4'b0011}: ztoken = 3'b001;
                {4'b0001, 4'b0011}: ztoken = 3'b000;
                default: ztoken = 3'b000; // Default case for ztable = 1
            endcase
        end
        
        default: ztoken = 3'b000; // Default case for ztable not equal to 0 or 1
    endcase
    
    case (ztable)
        1'b0: begin
            case ({totalzeros, totalcoeffs})
                 {4'b0000, 4'b0001}: ztoken_len = 4'b0001;
                {4'b0001, 4'b0001}: ztoken_len = 4'b0011;
                {4'b0010, 4'b0001}: ztoken_len = 4'b0011;
                {4'b0011, 4'b0001}: ztoken_len = 4'b0100;
                {4'b0100, 4'b0001}: ztoken_len = 4'b0100;
                {4'b0101, 4'b0001}: ztoken_len = 4'b0101;
                {4'b0110, 4'b0001}: ztoken_len = 4'b0101;
                {4'b0111, 4'b0001}: ztoken_len = 4'b0110;
                {4'b1000, 4'b0001}: ztoken_len = 4'b0110;
                {4'b1001, 4'b0001}: ztoken_len = 4'b0111;
                {4'b1010, 4'b0001}: ztoken_len = 4'b0111;
                {4'b1011, 4'b0001}: ztoken_len = 4'b1000;
                {4'b1100, 4'b0001}: ztoken_len = 4'b1000;
                {4'b1101, 4'b0001}: ztoken_len = 4'b1001;
                {4'b1110, 4'b0001}: ztoken_len = 4'b1001;
                {4'b0000, 4'b0010}: ztoken_len = 4'b0011;
                {4'b0001, 4'b0010}: ztoken_len = 4'b0011;
                {4'b0010, 4'b0010}: ztoken_len = 4'b0011;
                {4'b0011, 4'b0010}: ztoken_len = 4'b0011;
                {4'b0100, 4'b0010}: ztoken_len = 4'b0100;
                {4'b0101, 4'b0010}: ztoken_len = 4'b0100;
                {4'b0110, 4'b0010}: ztoken_len = 4'b0100;
                {4'b0111, 4'b0010}: ztoken_len = 4'b0100;
                {4'b1000, 4'b0010}: ztoken_len = 4'b0101;
                {4'b1001, 4'b0010}: ztoken_len = 4'b0101;
                {4'b1010, 4'b0010}: ztoken_len = 4'b0110;
                {4'b1011, 4'b0010}: ztoken_len = 4'b0110;
                {4'b1100, 4'b0010}: ztoken_len = 4'b0110;
                {4'b1101, 4'b0010}: ztoken_len = 4'b0110;
                {4'b1110, 4'b0010}: ztoken_len = 4'b0100;
                {4'b0000, 4'b0011}: ztoken_len = 4'b0100;
                {4'b0001, 4'b0011}: ztoken_len = 4'b0011;
                {4'b0010, 4'b0011}: ztoken_len = 4'b0011;
                {4'b0011, 4'b0011}: ztoken_len = 4'b0011;
                {4'b0100, 4'b0011}: ztoken_len = 4'b0100;
                {4'b0101, 4'b0011}: ztoken_len = 4'b0100;
                {4'b0110, 4'b0011}: ztoken_len = 4'b0011;
                {4'b0111, 4'b0011}: ztoken_len = 4'b0011;
                {4'b1000, 4'b0011}: ztoken_len = 4'b0100;
                {4'b1001, 4'b0011}: ztoken_len = 4'b0101;
                {4'b1010, 4'b0011}: ztoken_len = 4'b0101;
                {4'b1011, 4'b0011}: ztoken_len = 4'b0110;
                {4'b1100, 4'b0011}: ztoken_len = 4'b0110;
                {4'b1101, 4'b0011}: ztoken_len = 4'b0101;
                {4'b1110, 4'b0011}: ztoken_len = 4'b0110;
                {4'b0000, 4'b0100}: ztoken_len = 4'b0011;
                {4'b0001, 4'b0100}: ztoken_len = 4'b0011;
                {4'b0010, 4'b0100}: ztoken_len = 4'b0011;
                {4'b0011, 4'b0100}: ztoken_len = 4'b0011;
                {4'b0100, 4'b0100}: ztoken_len = 4'b0100;
                {4'b0101, 4'b0100}: ztoken_len = 4'b0100;
                {4'b0110, 4'b0100}: ztoken_len = 4'b0100;
                {4'b0111, 4'b0100}: ztoken_len = 4'b0011;
                {4'b1000, 4'b0100}: ztoken_len = 4'b0100;
                {4'b1001, 4'b0100}: ztoken_len = 4'b0101;
                {4'b1010, 4'b0100}: ztoken_len = 4'b0101;
                {4'b1011, 4'b0100}: ztoken_len = 4'b0101;
                {4'b1100, 4'b0100}: ztoken_len = 4'b0100;
                {4'b1101, 4'b0100}: ztoken_len = 4'b0100;
                {4'b1110, 4'b0100}: ztoken_len = 4'b0100;
                {4'b0000, 4'b0101}: ztoken_len = 4'b0100;
                {4'b0001, 4'b0101}: ztoken_len = 4'b0011;
                {4'b0010, 4'b0101}: ztoken_len = 4'b0011;
                {4'b0011, 4'b0101}: ztoken_len = 4'b0011;
                {4'b0100, 4'b0101}: ztoken_len = 4'b0011;
                {4'b0101, 4'b0101}: ztoken_len = 4'b0011;
                {4'b0110, 4'b0101}: ztoken_len = 4'b0011;
                {4'b0111, 4'b0101}: ztoken_len = 4'b0100;
                {4'b1000, 4'b0101}: ztoken_len = 4'b0100;
                {4'b1001, 4'b0101}: ztoken_len = 4'b0100;
                {4'b1010, 4'b0101}: ztoken_len = 4'b0101;
                {4'b1011, 4'b0101}: ztoken_len = 4'b0101;
                {4'b1100, 4'b0101}: ztoken_len = 4'b0101;
                {4'b1101, 4'b0101}: ztoken_len = 4'b0101;
                {4'b1110, 4'b0101}: ztoken_len = 4'b0101;
                {4'b0000, 4'b0110}: ztoken_len = 4'b0101;
                {4'b0001, 4'b0110}: ztoken_len = 4'b0101;
                {4'b0010, 4'b0110}: ztoken_len = 4'b0011;
                {4'b0011, 4'b0110}: ztoken_len = 4'b0011;
                {4'b0100, 4'b0110}: ztoken_len = 4'b0011;
                {4'b0101, 4'b0110}: ztoken_len = 4'b0011;
                {4'b0110, 4'b0110}: ztoken_len = 4'b0011;
                {4'b0111, 4'b0110}: ztoken_len = 4'b0011;
                {4'b1000, 4'b0110}: ztoken_len = 4'b0100;
                {4'b1001, 4'b0110}: ztoken_len = 4'b0100;
                {4'b1010, 4'b0110}: ztoken_len = 4'b0110;
                {4'b1011, 4'b0110}: ztoken_len = 4'b0110;
                {4'b1100, 4'b0110}: ztoken_len = 4'b0110;
                {4'b1101, 4'b0110}: ztoken_len = 4'b0100;
                {4'b1110, 4'b0110}: ztoken_len = 4'b0101;
                {4'b0000, 4'b0111}: ztoken_len = 4'b0110;
                {4'b0001, 4'b0111}: ztoken_len = 4'b0101;
                {4'b0010, 4'b0111}: ztoken_len = 4'b0011;
                {4'b0011, 4'b0111}: ztoken_len = 4'b0011;
                {4'b0100, 4'b0111}: ztoken_len = 4'b0011;
                {4'b0101, 4'b0111}: ztoken_len = 4'b0010;
                {4'b0110, 4'b0111}: ztoken_len = 4'b0011;
                {4'b0111, 4'b0111}: ztoken_len = 4'b0100;
                {4'b1000, 4'b0111}: ztoken_len = 4'b0011;
                {4'b1001, 4'b0111}: ztoken_len = 4'b0110;
                {4'b1010, 4'b0111}: ztoken_len = 4'b0110;
                {4'b1011, 4'b0111}: ztoken_len = 4'b0100;
                {4'b1100, 4'b0111}: ztoken_len = 4'b0110;
                {4'b1101, 4'b0111}: ztoken_len = 4'b0100;
                {4'b1110, 4'b0111}: ztoken_len = 4'b0110;
                {4'b0000, 4'b1000}: ztoken_len = 4'b0110;
                {4'b0001, 4'b1000}: ztoken_len = 4'b0100;
                {4'b0010, 4'b1000}: ztoken_len = 4'b0101;
                {4'b0011, 4'b1000}: ztoken_len = 4'b0011;
                {4'b0100, 4'b1000}: ztoken_len = 4'b0010;
                {4'b0101, 4'b1000}: ztoken_len = 4'b0010;
                {4'b0110, 4'b1000}: ztoken_len = 4'b0011;
                {4'b0111, 4'b1000}: ztoken_len = 4'b0100;
                {4'b1000, 4'b1000}: ztoken_len = 4'b0110;
                {4'b1001, 4'b1000}: ztoken_len = 4'b0011;
                {4'b1010, 4'b1000}: ztoken_len = 4'b0110;
                {4'b1011, 4'b1000}: ztoken_len = 4'b0101;
                {4'b1100, 4'b1000}: ztoken_len = 4'b0100;
                {4'b1101, 4'b1000}: ztoken_len = 4'b0101;
                {4'b1110, 4'b1000}: ztoken_len = 4'b0101;
                {4'b0000, 4'b1001}: ztoken_len = 4'b0110;
                {4'b0001, 4'b1001}: ztoken_len = 4'b0110;
                {4'b0010, 4'b1001}: ztoken_len = 4'b0100;
                {4'b0011, 4'b1001}: ztoken_len = 4'b0010;
                {4'b0100, 4'b1001}: ztoken_len = 4'b0010;
                {4'b0101, 4'b1001}: ztoken_len = 4'b0011;
                {4'b0110, 4'b1001}: ztoken_len = 4'b0101;
                {4'b0111, 4'b1001}: ztoken_len = 4'b0101;
                {4'b1000, 4'b1001}: ztoken_len = 4'b0101;
                {4'b1001, 4'b1001}: ztoken_len = 4'b0101;
                {4'b1010, 4'b1001}: ztoken_len = 4'b0010;
                {4'b1011, 4'b1001}: ztoken_len = 4'b0101;
                {4'b1100, 4'b1001}: ztoken_len = 4'b0101;
                {4'b1101, 4'b1001}: ztoken_len = 4'b0101;
                {4'b1110, 4'b1001}: ztoken_len = 4'b0101;
                {4'b0000, 4'b1010}: ztoken_len = 4'b0101;
                {4'b0001, 4'b1010}: ztoken_len = 4'b0101;
                {4'b0010, 4'b1010}: ztoken_len = 4'b0011;
                {4'b0011, 4'b1010}: ztoken_len = 4'b0010;
                {4'b0100, 4'b1010}: ztoken_len = 4'b0010;
                {4'b0101, 4'b1010}: ztoken_len = 4'b0011;
                {4'b0110, 4'b1010}: ztoken_len = 4'b0101;
                {4'b0111, 4'b1010}: ztoken_len = 4'b0101;
                {4'b1000, 4'b1010}: ztoken_len = 4'b0101;
                {4'b1001, 4'b1010}: ztoken_len = 4'b0101;
                {4'b1010, 4'b1010}: ztoken_len = 4'b0101;
                {4'b1011, 4'b1010}: ztoken_len = 4'b0010;
                {4'b1100, 4'b1010}: ztoken_len = 4'b0101;
                {4'b1101, 4'b1010}: ztoken_len = 4'b0010;
                {4'b1110, 4'b1010}: ztoken_len = 4'b0101;
                {4'b0000, 4'b1011}: ztoken_len = 4'b0101;
                {4'b0001, 4'b1011}: ztoken_len = 4'b0101;
                {4'b0010, 4'b1011}: ztoken_len = 4'b0011;
                {4'b0011, 4'b1011}: ztoken_len = 4'b0011;
                {4'b0100, 4'b1011}: ztoken_len = 4'b0010;
                {4'b0101, 4'b1011}: ztoken_len = 4'b0011;
                {4'b0110, 4'b1011}: ztoken_len = 4'b0101;
                {4'b0111, 4'b1011}: ztoken_len = 4'b0010;
                {4'b1000, 4'b1011}: ztoken_len = 4'b0101;
                {4'b1001, 4'b1011}: ztoken_len = 4'b0011;
                {4'b1010, 4'b1011}: ztoken_len = 4'b0011;
                {4'b1011, 4'b1011}: ztoken_len = 4'b0101;
                {4'b1100, 4'b1011}: ztoken_len = 4'b0101;
                {4'b1101, 4'b1011}: ztoken_len = 4'b0101;
                {4'b1110, 4'b1011}: ztoken_len = 4'b0101;
                {4'b0000, 4'b1100}: ztoken_len = 4'b0011;
                {4'b0001, 4'b1100}: ztoken_len = 4'b0011;
                {4'b0010, 4'b1100}: ztoken_len = 4'b0011;
                {4'b0011, 4'b1100}: ztoken_len = 4'b0011;
                {4'b0100, 4'b1100}: ztoken_len = 4'b0010;
                {4'b0101, 4'b1100}: ztoken_len = 4'b0010;
                {4'b0110, 4'b1100}: ztoken_len = 4'b0011;
                {4'b0111, 4'b1100}: ztoken_len = 4'b0011;
                {4'b1000, 4'b1100}: ztoken_len = 4'b0101;
                {4'b1001, 4'b1100}: ztoken_len = 4'b0101;
                {4'b1010, 4'b1100}: ztoken_len = 4'b0011;
                {4'b1011, 4'b1100}: ztoken_len = 4'b0101;
                {4'b1100, 4'b1100}: ztoken_len = 4'b0101;
                {4'b1101, 4'b1100}: ztoken_len = 4'b0011;
                {4'b1110, 4'b1100}: ztoken_len = 4'b0011;
                {4'b0000, 4'b1101}: ztoken_len = 4'b0011;
                {4'b0001, 4'b1101}: ztoken_len = 4'b0011;
                {4'b0010, 4'b1101}: ztoken_len = 4'b0011;
                {4'b0011, 4'b1101}: ztoken_len = 4'b0100;
                {4'b0100, 4'b1101}: ztoken_len = 4'b0010;
                {4'b0101, 4'b1101}: ztoken_len = 4'b0010;
                {4'b0110, 4'b1101}: ztoken_len = 4'b0101;
                {4'b0111, 4'b1101}: ztoken_len = 4'b0010;
                {4'b1000, 4'b1101}: ztoken_len = 4'b0100;
                {4'b1001, 4'b1101}: ztoken_len = 4'b0011;
                {4'b1010, 4'b1101}: ztoken_len = 4'b0101;
                {4'b1011, 4'b1101}: ztoken_len = 4'b0010;
                {4'b1100, 4'b1101}: ztoken_len = 4'b0101;
                {4'b1101, 4'b1101}: ztoken_len = 4'b0101;
                {4'b1110, 4'b1101}: ztoken_len = 4'b0101;
                {4'b0000, 4'b1110}: ztoken_len = 4'b0011;
                {4'b0001, 4'b1110}: ztoken_len = 4'b0011;
                {4'b0010, 4'b1110}: ztoken_len = 4'b0010;
                {4'b0011, 4'b1110}: ztoken_len = 4'b0010;
                {4'b0100, 4'b1110}: ztoken_len = 4'b0011;
                {4'b0101, 4'b1110}: ztoken_len = 4'b0010;
                {4'b0110, 4'b1110}: ztoken_len = 4'b0101;
                {4'b0111, 4'b1110}: ztoken_len = 4'b0100;
                {4'b1000, 4'b1110}: ztoken_len = 4'b0101;
                {4'b1001, 4'b1110}: ztoken_len = 4'b0011;
                {4'b1010, 4'b1110}: ztoken_len = 4'b0010;
                {4'b1011, 4'b1110}: ztoken_len = 4'b0101;
                {4'b1100, 4'b1110}: ztoken_len = 4'b0011;
                {4'b1101, 4'b1110}: ztoken_len = 4'b0101;
                {4'b1110, 4'b1110}: ztoken_len = 4'b0101;
                {4'b0000, 4'b1111}: ztoken_len = 4'b0010;
                {4'b0001, 4'b1111}: ztoken_len = 4'b0010;
                {4'b0010, 4'b1111}: ztoken_len = 4'b0011;
                {4'b0011, 4'b1111}: ztoken_len = 4'b0011;
                {4'b0100, 4'b1111}: ztoken_len = 4'b0100;
                {4'b0101, 4'b1111}: ztoken_len = 4'b0011;
                {4'b0110, 4'b1111}: ztoken_len = 4'b0011;
                {4'b0111, 4'b1111}: ztoken_len = 4'b0011;
                {4'b1000, 4'b1111}: ztoken_len = 4'b0010;
                {4'b1001, 4'b1111}: ztoken_len = 4'b0100;
                {4'b1010, 4'b1111}: ztoken_len = 4'b0101;
                {4'b1011, 4'b1111}: ztoken_len = 4'b0011;
                {4'b1100, 4'b1111}: ztoken_len = 4'b0010;
                {4'b1101, 4'b1111}: ztoken_len = 4'b0101;
                {4'b1110, 4'b1111}: ztoken_len = 4'b0011;
                {4'b1111, 4'b1111}: ztoken_len = 4'b0011;
              endcase
          end
       1'b1 :begin
            case ({totalzeros, totalcoeffs})
                {4'b0000, 4'b0001, 1'b1}: ztoken_len = 4'b0001; // totalzeros=0, totalcoeffs=1, ztable='1'
                {4'b0001, 4'b0001, 1'b1}: ztoken_len = 4'b0010; // totalzeros=1, totalcoeffs=1, ztable='1'
                {4'b0010, 4'b0001, 1'b1}: ztoken_len = 4'b0011; // totalzeros=2, totalcoeffs=1, ztable='1'
                {4'b0011, 4'b0001, 1'b1}: ztoken_len = 4'b0011; // totalzeros=3, totalcoeffs=1, ztable='1'
                {4'b0000, 4'b0010, 1'b1}: ztoken_len = 4'b0001; // totalzeros=0, totalcoeffs=2, ztable='1'
                {4'b0001, 4'b0010, 1'b1}: ztoken_len = 4'b0010; // totalzeros=1, totalcoeffs=2, ztable='1'
                {4'b0010, 4'b0010, 1'b1}: ztoken_len = 4'b0010; // totalzeros=2, totalcoeffs=2, ztable='1'
                {4'b0000, 4'b0011, 1'b1}: ztoken_len = 4'b0001; // totalzeros=0, totalcoeffs=3, ztable='1'      
            endcase
          end
     endcase
     
     case ({runb, rbzerosleft})
    {4'b0000, 3'b000}: rbtoken <= 3'b111; // runb=0
    {4'b0001, 3'b001}: rbtoken <= 3'b000; // runb=1, rbzerosleft=1
    {4'b0001, 3'b010}: rbtoken <= 3'b001; // runb=1, rbzerosleft=2
    {4'b0001, 3'b011}: rbtoken <= 3'b010; // runb=1, rbzerosleft=3
    {4'b0001, 3'b100}: rbtoken <= 3'b010; // runb=1, rbzerosleft=4
    {4'b0001, 3'b101}: rbtoken <= 3'b010; // runb=1, rbzerosleft=5
    {4'b0001, 3'b110}: rbtoken <= 3'b000; // runb=1, rbzerosleft=6
    {4'b0001, 3'bxxx}: rbtoken <= 3'b110; // runb=1 (default case for any rbzerosleft)
    {4'b0010, 3'b010}: rbtoken <= 3'b000; // runb=2, rbzerosleft=2
    {4'b0010, 3'b011}: rbtoken <= 3'b001; // runb=2, rbzerosleft=3
    {4'b0010, 3'b100}: rbtoken <= 3'b001; // runb=2, rbzerosleft=4
    {4'b0010, 3'b101}: rbtoken <= 3'b011; // runb=2, rbzerosleft=5
    {4'b0010, 3'b110}: rbtoken <= 3'b001; // runb=2, rbzerosleft=6
    {4'b0010, 3'bxxx}: rbtoken <= 3'b101; // runb=2 (default case for any rbzerosleft)
    {4'b0011, 3'b011}: rbtoken <= 3'b000; // runb=3, rbzerosleft=3
    {4'b0011, 3'b100}: rbtoken <= 3'b001; // runb=3, rbzerosleft=4
    {4'b0011, 3'b101}: rbtoken <= 3'b010; // runb=3, rbzerosleft=5
    {4'b0011, 3'b110}: rbtoken <= 3'b011; // runb=3, rbzerosleft=6
    {4'b0011, 3'bxxx}: rbtoken <= 3'b100; // runb=3 (default case for any rbzerosleft)
    {4'b0100, 3'b100}: rbtoken <= 3'b000; // runb=4, rbzerosleft=4
    {4'b0100, 3'b101}: rbtoken <= 3'b001; // runb=4, rbzerosleft=5
    {4'b0100, 3'b110}: rbtoken <= 3'b010; // runb=4, rbzerosleft=6
    {4'b0100, 3'bxxx}: rbtoken <= 3'b011; // runb=4 (default case for any rbzerosleft)
    {4'b0101, 3'b101}: rbtoken <= 3'b000; // runb=5, rbzerosleft=5
    {4'b0101, 3'b110}: rbtoken <= 3'b101; // runb=5, rbzerosleft=6
    {4'b0101, 3'bxxx}: rbtoken <= 3'b010; // runb=5 (default case for any rbzerosleft)
    {4'b0110, 3'b110}: rbtoken <= 3'b100; // runb=6, rbzerosleft=6
    {4'b0110, 3'bxxx}: rbtoken <= 3'b001; // runb=6 (default case for any rbzerosleft)
endcase

      READY = ~eenable;
      NOUT = etotalcoeffs;          
end
    
always @(posedge CLK2) begin
    if (ENABLE == 1'b1) begin
        // Reading subprocess
        // Principle variables start with 'e' so are separate pipeline stage from output
        // t1sign is used by output before overwritten here; likewise arrays
        eenable <= 1'b1;
        emaxcoeffs <= emaxcoeffs + 1;  // This is a coefficient
        es <= SIN;

        if (VIN != 0) begin
            etotalcoeffs <= etotalcoeffs + 1;  // Total non-zero coefficients
            ecnz <= 1'b1;                      // We've seen a non-zero

            if (VIN == 1 || VIN == 12'hFFF) begin  // 1 or -1
                if (ecgt1 == 1'b0 && etrailingones != 3) begin
                    etrailingones <= etrailingones + 1;
                    et1signs <= {et1signs[1:0], VIN[11]};  // Encode sign
                end
            end else begin
                ecgt1 <= 1'b1;  // We've seen a greater-than-1
            end

            // Put coefficients into array; put runs into array
            // Coeff is coded as sign & abscoeff
            if (VIN[11] == 1'b1) begin
                coeffarray[{eparity, eindex}] <= {1'b1, 11'b00000000000 - VIN[10:0]};
            end else begin
                coeffarray[{eparity, eindex}] <= VIN;
            end

            runbarray[{eparity, eindex}] <= erun;
            erun <= 12'h0;
            eindex <= eindex + 1;
        end else if (ecnz == 1'b1) begin
            // VIN=0 and ecnz
            etotalzeros <= etotalzeros + 1;  // Total zeros after first non-zero coefficient
            erun <= erun + 1;
        end

        // Select table for coeff_token (assume 4x4)
        if (NIN < 2) begin
            etable <= CTABLE0[1:0];
        end else if (NIN < 4) begin
            etable <= CTABLE1[1:0];
        end else if (NIN < 8) begin
            etable <= CTABLE2[1:0];
        end else begin
            etable <= CTABLE3[1:0];
        end
    end else begin  // ENABLE=0
        if (hvalid == 1'b0 && eenable == 1'b1) begin
            // Transfer to holding stage
            hmaxcoeffs <= emaxcoeffs;
            htotalcoeffs <= etotalcoeffs;
            htotalzeros <= etotalzeros;
            htrailingones <= etrailingones;
            htable <= etable;
            hs <= es;
            t1signs <= et1signs;
            hparity <= eparity;
            hvalidi <= 1'b1;



            eenable <= 1'b0;
            emaxcoeffs <= 5'b00000;
            etotalcoeffs <= 5'b00000;
            etotalzeros <= 5'b00000;
            etrailingones <= 2'b00;
            erun <= 12'h0;
            eindex <= 5'b00000;
            ecnz <= 1'b0;
            ecgt1 <= 1'b0;
            eparity <= ~eparity;
        end
    end

    if (hvalid == 1'b1 && state == STATE_COEFFS && cindex > totalcoeffs[4:1] && parity == hparity) begin
        // OK to clear holding register
        hvalidi <= 1'b0;
    end

    hvalid <= hvalidi;  // Delay 1 cycle to overcome CLK/CLK2 sync problems
end

always @(posedge CLK) begin
    XSTATE <= state;

    if (state == STATE_IDLE) begin
        VALID <= 1'b0;
    end

    if ((state == STATE_IDLE || (state == STATE_RUNBF && rbstate == 1'b0)) && hvalid == 1'b1) begin
        // Done reading, start processing
        maxcoeffs <= hmaxcoeffs;
        totalcoeffs <= htotalcoeffs;
        totalzeros <= htotalzeros;
        trailingones <= htrailingones;
        parity <= hparity;

        if (hmaxcoeffs == 4) begin
            ctable <= CTABLE4;  // Special table for ChromaDC
            ztable <= 1'b1;    // Ditto
        end else begin
            ctable <= {1'b0, htable};  // Normal tables
            ztable <= 1'b0;    // Ditto
        end

        state <= STATE_CTOKEN;
        cindex <= {2'b00, htrailingones};
        if (htotalcoeffs > 1) begin
            rbstate <= 1'b1;  // Run-before processing starts
        end

        rbindex <= 4'h2;
        tmpindex = {hparity, 1'b1};
        runb <= runbarray[tmpindex];
        rbzerosleft <= htotalzeros;
        rbvl <= 5'b00000;
        rbve <= 24'b0;
    end

    if (state == STATE_CTOKEN) begin
        if (trailingones != 0) begin
            state <= STATE_T1SIGN;
        end else begin
            state <= STATE_COEFFS;  // Skip T1SIGN
        end
    end

    if (state == STATE_T1SIGN) begin
        state <= STATE_COEFFS;
    end

    if (state == STATE_COEFFS && (cindex >= totalcoeffs || cindex == 0)) begin
        if (totalcoeffs != maxcoeffs && totalcoeffs != 0) begin
            state <= STATE_TZEROS;
        end else begin
            state <= STATE_RUNBF;  // Skip TZEROS
        end
    end

    if (state == STATE_TZEROS) begin
        state <= STATE_RUNBF;
    end

    if (state == STATE_RUNBF && rbstate == 1'b1) begin
        // Wait
        VALID <= 1'b0;
    end else if (state == STATE_RUNBF && rbstate == 1'b0) begin
        // All done; reset and get ready to go again
        if (hvalid == 1'b0) begin
            state <= STATE_IDLE;
        end
        if (rbvl != 0 && totalzeros != 0) begin
            VALID <= 1'b1;
            VE <= rbve;  // Results of run-before subprocessor
            VL <= rbvl;
        end else begin
            VALID <= 1'b0;
        end
    end

    // Run-before subprocess
    if (rbstate == 1'b1) begin
        if (runb <= 7) begin  // Normal processing
            runb <= runbarray[{parity, rbindex}];
            rbindex <= rbindex + 1;
            if (rbindex == totalcoeffs || rbzerosleft <= runb) begin
                rbstate <= 1'b0;  // Done
            end

            // runb is currently runbarray[rbindex-1], since rbindex not yet loaded
            if (rbzerosleft + runb <= 2) begin  // 1-bit code
                rbve <= {rbve[23:0], ~runb[0]};
                rbvl <= rbvl + 1;
            end else if (rbzerosleft + runb <= 6) begin  // 2-bit code
                rbve <= {rbve[22:0], rbtoken[1:0]};
                rbvl <= rbvl + 2;
            end else if (runb <= 6) begin  // 3-bit code
                rbve <= {rbve[21:0], rbtoken[2:0]};
                rbvl <= rbvl + 3;
            end else begin  // runb = 7  // 4-bit code
                rbve <= {rbve[20:0], 4'b0001};
                rbvl <= rbvl + 4;
            end

            rbzerosleft <= rbzerosleft - runb;
        end else begin  // runb > 7, emit a zero and reduce counters by 1
            rbve <= {rbve[23:0], 1'b0};
            rbvl <= rbvl + 1;
            rbzerosleft <= rbzerosleft - 1;
            runb <= runb - 1;
        end
    end



    // Output stuff...
    // CTOKEN
    if (state == STATE_CTOKEN) begin
        // Output coeff_token based on (totalcoeffs, trailingones)
        VE <= {16'h0000, 4'b0000, coeff_token};  // From tables above
        VL <= ctoken_len;
        VALID <= 1'b1;
        VS <= hs;

        // Setup for COEFFS (do it here because T1SIGN may be skipped)
        // Start at cindex = trailingones since we don't need to encode those
        coeff = coeffarray[{parity, 2'b00, trailingones}];
        cindex <= {2'b00, trailingones} + 1;
        signcoeff <= coeff[11];
        abscoeff <= coeff[10:0];

        if (trailingones == 3) begin
            abscoeffa <= abscoeff - 1;  // Normal case
        end else begin
            abscoeffa <= abscoeff - 2;  // Special case for t1s < 3
        end

        if (totalcoeffs > 10 && trailingones != 3) begin
            suffixlen <= 3'b001;  // Start at 1
        end else begin
            suffixlen <= 3'b000;  // Start at zero (normal)
        end
    end

    // T1SIGN
    if (state == STATE_T1SIGN) begin
        //assert(trailingones != 0) else $fatal("Trailing ones should not be zero");
        VALID <= 1'b1;
        VE <= {16'h00000, 4'b0000, t1signs};
        VL <= {4'b000, trailingones};
    end

    // COEFFS
    if (state == STATE_COEFFS) begin
        if (suffixlen == 0) begin
            // Three sub-cases depending on size of abscoeff
            if (abscoeffa < 7) begin
                // Normal, just levelprefix which is unary encoded
                VE <= {1'b0, 6'h000001};
                VL <= abscoeffa[3:0] + 1 + signcoeff;
            end else if (abscoeffa < 15) begin  // 7..14
                // Use level 14 with 4-bit suffix
                VE <= {1'b0, 5'h00001, abscoeffa[2:0] + 1, signcoeff};
                VL <= 5'b10011;  // 14 + 1 + 4 = 19 bits
            end else begin
                // Use level 15 with 12-bit suffix
                VE <= {1'b0, 6'h001, abscoeffa - 15, signcoeff};
                VL <= 5'b11100;  // 15 + 1 + 12 = 28 bits
            end

            if (abscoeff > 3) begin
                suffixlen <= 3'b010;  // Double increment
            end else begin
                suffixlen <= 3'b001;  // Always increment
            end
        end else begin  // suffixlen > 0: 1..6
            if (suffixlen == 1 && abscoeffa < 15) begin
                VE <= {1'b0, 5'h00000, 3'b001, signcoeff};
                VL <= abscoeffa[4:0] + 2;
            end else if (suffixlen == 2 && abscoeffa < 30) begin
                VE <= {1'b0, 5'h00000, 2'b01, abscoeffa[0], signcoeff};
                VL <= abscoeffa[5:1] + 3;
            end else if (suffixlen == 3 && abscoeffa < 60) begin
                VE <= {1'b0, 5'h00000, 1'b1, abscoeffa[1:0], signcoeff};
                VL <= abscoeffa[6:2] + 4;
            end else if (suffixlen == 4 && abscoeffa < 120) begin
                VE <= {1'b0, 5'h00001, abscoeffa[2:0], signcoeff};
                VL <= abscoeffa[7:3] + 5;
            end else if (suffixlen == 5 && abscoeffa < 240) begin
             VE <= {1'b0, 5'h0000, 3'b001, abscoeffa[3:0], signcoeff};
                VL <= abscoeffa[8:4] + 6;
            end else if (suffixlen == 6 && abscoeffa < 480) begin
                VE <= {1'b0, 5'h0000, 2'b01, abscoeffa[4:0], signcoeff};
                VL <= abscoeffa[9:5] + 7;
            end else if (suffixlen == 1) begin
                // Use level 15 with 12-bit suffix, VLC1
                VE <= {1'b0, 6'h001, abscoeffa - 15, signcoeff};
                VL <= 5'b11100;  // 15 + 1 + 12 = 28 bits
            end else if (suffixlen == 2) begin
                // Use level 15 with 12-bit suffix, VLC2
                VE <= {1'b0, 6'h001, abscoeffa - 30, signcoeff};
                VL <= 5'b11100;  // 15 + 1 + 12 = 28 bits
            end else if (suffixlen == 3) begin
                // Use level 15 with 12-bit suffix, VLC3
                VE <= {1'b0, 6'h001, abscoeffa - 60, signcoeff};
                VL <= 5'b11100;  // 15 + 1 + 12 = 28 bits
            end else if (suffixlen == 4) begin
                // Use level 15 with 12-bit suffix, VLC4
                VE <= {1'b0, 6'h001, abscoeffa - 120, signcoeff};
                VL <= 5'b11100;  // 15 + 1 + 12 = 28 bits
            end else if (suffixlen == 5) begin
                // Use level 15 with 12-bit suffix, VLC5
                VE <= {1'b0, 6'h001, abscoeffa - 240, signcoeff};
                VL <= 5'b11100;  // 15 + 1 + 12 = 28 bits
            end else begin
                // Use level 15 with 12-bit suffix, VLC6
                VE <= {1'b0, 6'h001, abscoeffa - 480, signcoeff};
                VL <= 5'b11100;  // 15 + 1 + 12 = 28 bits
            end

            if ((suffixlen == 1 && abscoeff > 3) ||
                (suffixlen == 2 && abscoeff > 6) ||
                (suffixlen == 3 && abscoeff > 12) ||
                (suffixlen == 4 && abscoeff > 24) ||
                (suffixlen == 5 && abscoeff > 48)) begin
                suffixlen <= suffixlen + 1;
            end
        end

        if (cindex <= totalcoeffs && totalcoeffs != 0) begin
            VALID <= 1'b1;
        end else begin
            VALID <= 1'b0;
        end

        // Next coeff
        coeff = coeffarray[{parity, cindex}];
        signcoeff <= coeff[11];
        abscoeff <= coeff[10:0];
        abscoeffa <= coeff[10:0] - 1;
        cindex <= cindex + 1;
    end

    // TZEROS
     if (state == STATE_TZEROS) begin
        //assert(totalcoeffs != maxcoeffs && totalcoeffs != 0) else $fatal("Invalid state for TZEROS");
        VALID <= 1'b1;
        VE <= {5'b00000, 2'b00, ztoken};
        VL <= {1'b0, ztoken_len};
    end
end



endmodule