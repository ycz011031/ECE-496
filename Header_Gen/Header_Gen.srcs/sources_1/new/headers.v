`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/17 22:03:06
// Design Name: 
// Module Name: headers
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


module h264header (
    input wire CLK,                  // clock
    // slice:
    input wire NEWSLICE,             // reset: this is the first in a slice
    input wire LASTSLICE,            // this is last slice in frame
    input wire SINTRA,               // slice I flag
    // macroblock:
    input wire MINTRA,               // macroblock I flag
    input wire LSTROBE,              // luma data here (16 of these)
    input wire CSTROBE,              // chroma data (first latches CMODE)
    input wire [5:0] QP,             // 0..51 as specified in standard
    // for intra:
    input wire PMODE,                // luma prev_intra4x4_pred_mode_flag
    input wire [2:0] RMODE,          // luma rem_intra4x4_pred_mode_flag
    input wire [1:0] CMODE,          // intra_chroma_pred_mode
    // for inter:
    input wire [1:0] PTYPE,          // 0=P16x16,1=P16x8,2=P8x16,3=subtypes
    input wire [1:0] PSUBTYPE,       // only if PTYPE=2'b11
    input wire [11:0] MVDX,          // signed MVD X (qtr pixel)
    input wire [11:0] MVDY,          // signed MVD Y (qtr pixel)
    // output:
    output reg [19:0] VE,            // wide bits stream
    output reg [4:0] VL,             // bits length
    output reg VALID                 // VE/VL valid
);

    reg slicehead1, slicehead2, mbhead, idrtwice, lstrobed, tailf, pushf, sevf, uevf;
    reg [15:0] lbuf, sev, uevp1;
    reg [4:0] lbufc;
    reg [1:0] cmodei;
    reg [3:0] lcount, fcount;
    reg ccount;
    reg [3:0] ix;
    reg [15:0] abuf [15:0];
    reg [4:0] abufc [15:0];
    reg [3:0] emit;

    parameter ZERO = 5'b00000;

    always @(posedge CLK) begin
        if (NEWSLICE || (emit == ix - 1 && emit != 0)) begin
            slicehead1 <= NEWSLICE;
            slicehead2 <= NEWSLICE;
            mbhead <= 1;
            lcount <= 0;
            ccount <= 0;
            lbufc <= 0;
            ix <= 4'h1;
            emit <= 4'h0;
        end else if (emit != 0) begin
            emit <= emit + 1;
        end else if (slicehead1) begin
            // NAL header byte: IDR or normal:
            if (SINTRA) begin
                lbuf <= 16'h5525;  // 0x25 (8 bits)
            end else begin
                lbuf <= 16'h5521;  // 0x21 (8 bits)
            end
            lbufc <= ZERO + 8;
            pushf <= 1;
            slicehead1 <= 0;
        end else if (slicehead2 && !pushf) begin
            // IDR I-frame headers or P-frame headers:
            if (SINTRA && !idrtwice) begin
                lbuf <= 16'b0010101110000100;  // 101110000100 (12 bits)
                lbufc <= ZERO + 12;
                idrtwice <= 1;
                fcount <= {3'b000, LASTSLICE};
            end else if (SINTRA) begin
                lbuf <= 16'b0010111000001000;  // 10111000001000 (14 bits)
                lbufc <= ZERO + 14;
                idrtwice <= 0;
                fcount <= {3'b000, LASTSLICE};
            end else begin
                lbuf <= {5'b11111, fcount, 1'b0};  // 11111nnnn0 (10 bits)
                lbufc <= ZERO + 10;
                idrtwice <= 0;
                if (LASTSLICE) fcount <= fcount + 1;
            end
            sev <= $signed(QP) - 26;
            sevf <= 1;
            slicehead2 <= 0;
            pushf <= 1;
        end
        if (CSTROBE && !ccount && !NEWSLICE) begin  // chroma
            ccount <= 1;
            cmodei <= CMODE;
        end
        if (!LSTROBE) lstrobed <= LSTROBE;
        if (LSTROBE && !lstrobed && !NEWSLICE) begin  // luma
            if (mbhead && !pushf) begin
                // mb_skip_run and mb_type
                if (SINTRA && MINTRA) begin  // macroblock header
                    lbuf[5:0] <= 6'b000111;  // I4x4
                    lbufc <= ZERO + 1;
                end else if (!SINTRA && MINTRA) begin  // I4x4 in P slice
                    lbuf[5:0] <= 6'b100110;
                    lbufc <= ZERO + 7;
                end else begin  // P16x16
                    lbuf[5:0] <= 6'b000111;
                    lbufc <= ZERO + 2;
                end
                mbhead <= 0;
            end else if (!pushf) begin
                // normal processing
                lcount <= lcount + 1;
                lstrobed <= LSTROBE;
                if (MINTRA) begin
                    if (PMODE) begin
                        lbuf <= {lbuf[14:0], PMODE};
                        lbufc <= lbufc + 1;
                    end else begin
                        lbuf <= {lbuf[11:0], PMODE, RMODE};
                        lbufc <= lbufc + 4;
                    end
                end else begin  // P macroblocks
                    if (lcount == 1 || lcount == 2) begin
                        lbuf <= {lbuf[14:0], 1'b1};
                        lbufc <= lbufc + 1;
                    end
                end
                if (lcount == 15) begin
                    tailf <= 1;
                    pushf <= 1;
                end
            end
        end
        if (sevf) begin
            // convert 16bit sev to 16bit uev, then add 1
            if (!sev[15] && sev != 0) begin
                uevp1 <= {sev[14:0], 1'b0};
            end else begin
                uevp1 <= {~sev[14:0], 1'b1};
            end
            uevf <= sevf;
            sevf <= 0;
        end
        if (uevf == 1) begin
            lbuf <= uevp1;
            casez (uevp1[15:1])
                15'b000000000000000: lbufc <= ZERO + 1;
                15'b00000000000000?: lbufc <= ZERO + 3;
                15'b0000000000000??: lbufc <= ZERO + 5;
                15'b000000000000???: lbufc <= ZERO + 7;
                15'b00000000000????: lbufc <= ZERO + 9;
                15'b0000000000?????: lbufc <= ZERO + 11;
                15'b000000000??????: lbufc <= ZERO + 13;
                15'b00000000???????: lbufc <= ZERO + 15;
                15'b0000000????????: lbufc <= ZERO + 17;
                15'b000000?????????: lbufc <= ZERO + 19;
                15'b00000??????????: lbufc <= ZERO + 21;
                15'b0000???????????: lbufc <= ZERO + 23;
                15'b000????????????: lbufc <= ZERO + 25;
                15'b00?????????????: lbufc <= ZERO + 27;
                15'b0??????????????: lbufc <= ZERO + 29;
                default: lbufc <= ZERO + 31;
            endcase
            uevf <= sevf;
            pushf <= 1;
        end
    end
endmodule