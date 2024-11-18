module Plane_prediction (
    input clk,
    input reset,
    input [127:0] top_sample_flat,    // Flattened top sample (16 * 8 bits)
    input top_sample_avail,
    input [127:0] left_sample_flat,   // Flattened left sample (16 * 8 bits)
    input left_sample_avail,
    input [2047:0] mb_pixels_flat,    // Flattened macroblock pixels (16 * 16 * 8 bits)
    output reg [2047:0] residual_flat, // Flattened residual (16 * 16 * 8 bits)
    output reg available
);

    reg [7:0] top_sample[15:0];
    reg [7:0] left_sample[15:0];
    reg [7:0] mb_pixels[15:0][15:0];
    reg [7:0] prediction[15:0][15:0];
    reg [7:0] residual[15:0][15:0];

    integer H, V;
    reg signed [15:0] a, b, c; // Coefficients for plane mode
    reg [4:0] i, j;
    integer k;
    reg [1:0] state;

    localparam IDLE = 2'd0,
               CALC_H_V = 2'd1,
               CALC_PRED = 2'd2,
               CALC_RESIDUAL = 2'd3;

    // Unflatten inputs
    always @(*) begin
        for (k = 0; k < 16; k = k + 1) begin
            top_sample[k] = top_sample_flat[8*k +: 8];
            left_sample[k] = left_sample_flat[8*k +: 8];
        end
        for (k = 0; k < 256; k = k + 1) begin
            mb_pixels[k/16][k%16] = mb_pixels_flat[8*k +: 8];
        end
    end

    // State machine for prediction and residual calculation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            H <= 0;
            V <= 0;
            a <= 0;
            b <= 0;
            c <= 0;
            i <= 0;
            j <= 0;
            state <= IDLE;
            available <= 0;
            residual_flat <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (top_sample_avail && left_sample_avail) begin
                        H <= 0;
                        V <= 0;
                        i <= 0;
                        state <= CALC_H_V;
                        available <= 0;
                    end
                end

                CALC_H_V: begin
                    if (i < 8) begin
                        H <= H + (i + 1) * (top_sample[8 + i] - top_sample[6 - i]);
                        V <= V + (i + 1) * (left_sample[8 + i] - left_sample[6 - i]);
                        i <= i + 1;
                    end else begin
                        a <= 16 * (top_sample[15] + left_sample[15]);
                        b <= (5 * H + 32) >>> 6;
                        c <= (5 * V + 32) >>> 6;
                        i <= 0;
                        state <= CALC_PRED;
                    end
                end

                CALC_PRED: begin
                    if (i < 16) begin
                        for (j = 0; j < 16; j = j + 1) begin
                            prediction[i][j] <= (a + (i - 7) * c + (j - 7) * b + 16) >>> 5;
                        end
                        i <= i + 1;
                    end else begin
                        i <= 0;
                        state <= CALC_RESIDUAL;
                    end
                end

                CALC_RESIDUAL: begin
                    if (i < 16) begin
                        for (j = 0; j < 16; j = j + 1) begin
                            residual[i][j] <= mb_pixels[i][j] - prediction[i][j];
                        end
                        i <= i + 1;
                    end else begin
                        // Flatten the residual output
                        for (i = 0; i < 16; i = i + 1) begin
                            for (j = 0; j < 16; j = j + 1) begin
                                residual_flat[8*(i*16 + j) +: 8] <= residual[i][j];
                            end
                        end
                        state <= IDLE;
                        available <= 1;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule