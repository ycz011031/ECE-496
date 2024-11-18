module Horizontal_prediction (
    input clk,
    input reset,
    input [127:0] left_sample_flat,    // Flattened left sample (16 * 8 bits)
    input left_sample_avail,
    input [2047:0] mb_pixels_flat,     // Flattened macroblock pixels (16 * 16 * 8 bits)
    output reg [2047:0] residual_flat, // Flattened residual (16 * 16 * 8 bits)
    output reg available
);

    reg [7:0] left_sample[15:0];
    reg [7:0] mb_pixels[15:0][15:0];
    reg [7:0] prediction[15:0][15:0];
    reg [7:0] residual[15:0][15:0];

    integer i, j;
    integer k;
    reg [1:0] state;

    localparam IDLE = 2'd0,
               PREDICT = 2'd1,
               CALC_RESIDUAL = 2'd2;

    // Unflatten inputs
    always @(*) begin
        
        for (k = 0; k < 16; k = k + 1) begin
            left_sample[k] = left_sample_flat[8*k +: 8];
        end
        for (k = 0; k < 256; k = k + 1) begin
            mb_pixels[k/16][k%16] = mb_pixels_flat[8*k +: 8];
        end
    end

    // State machine for prediction and residual calculation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            i <= 0;
            j <= 0;
            state <= IDLE;
            available <= 0;
            residual_flat <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (left_sample_avail) begin
                        i <= 0;
                        state <= PREDICT;
                        available <= 0;
                    end
                end

                PREDICT: begin
                    if (i < 16) begin
                        for (j = 0; j < 16; j = j + 1) begin
                            prediction[i][j] <= left_sample[i];
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
