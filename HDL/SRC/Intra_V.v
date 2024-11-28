module Vertical_prediction (
    input wire clk,
    
    input wire [127:0] MB_data,       // Flattened left sample (16 * 8 bits, unsigned)
    input wire [31:0] Top_data,         // Flattened macroblock pixels (16 * 16 * 8 bits, unsigned)
    input wire data_ready,              // Indicates valid data is available
    input wire data_stall,              // Stall mechanism signal

    output wire [127:0] Residual_out,    // Flattened residual (16 * 16 * 8 bits, signed)
    output reg Residual_ready           // Indicates residuals are ready
);

    // State encoding
    localparam IDLE         = 2'b00;
    localparam COMPUTE_PRED = 2'b01;
    localparam COMPUTE_RES  = 2'b10;

    // State register
    reg [1:0] state;

    // Registers for input sampling
    reg [7:0] top_sample[3:0];        // Neighboring left sample (unsigned)
    reg [7:0] mb_pixels[15:0];    // Macroblock pixels (unsigned)

    // Registers for intermediate calculations
    reg [8:0] residual[15:0];     // Residual values (signed, 9 bits for intermediate calculations)
    reg [7:0] prediction[15:0];
    
    reg data_ready_reg = 1'b0;
    
    integer i;

    // Initial block to initialize signals
    initial begin
        state = IDLE;
        i = 0;
        Residual_ready = 0;
    end

    // State machine
    always @(posedge clk) begin
        case (state)
            // IDLE state: Wait for data_ready signal
            IDLE: begin
                Residual_ready <= 1'b0;
                data_ready_reg <= data_ready; 
                // Sample inputs if data is ready and no stall condition
                if (~data_ready_reg && data_ready && !data_stall) begin
                    // Sample Top and Left reference pixels
                    for (i = 0; i < 4; i = i + 1) begin
                        top_sample[i] <= Top_data[i * 8 +: 8];
                    end

                    // Sample Macroblock pixels
                    for (i = 0; i < 16; i = i + 1) begin
                        mb_pixels[i] <= MB_data[i * 8 +: 8];
                    end

                    state <= COMPUTE_PRED; // Move to prediction computation
                end
            end

            // COMPUTE_PRED state: Compute horizontal predictions
            COMPUTE_PRED: begin
                for (i = 0; i < 4; i=i+1) begin
                    prediction[i]   <= top_sample[0];
                    prediction[i+1] <= top_sample[1];
                    prediction[i+2] <= top_sample[2];
                    prediction[i+3] <= top_sample[3];
                end
                state <= COMPUTE_RES;
            end

            // COMPUTE_RES state: Compute residuals
            COMPUTE_RES: begin
                for (i=0; i < 16; i=i+1) begin
                    residual[i] <= $signed(mb_pixels[i]) - $signed(prediction[i]);
                end
                 Residual_ready <= 1'b1; // Signal residuals are ready
                state <= IDLE; // Return to idle/sample state    
            end

            default: state <= IDLE;
        endcase
    end
    
    wire[31:0] row_1;
    wire[31:0] row_2;
    wire[31:0] row_3;
    wire[31:0] row_4;
    assign row_1[7:0]   = residual[0][8:1];
    assign row_1[15:8]  = residual[1][8:1];
    assign row_1[23:16] = residual[2][8:1];
    assign row_1[31:24] = residual[3][8:1];
    assign row_2[7:0]   = residual[4][8:1];
    assign row_2[15:8]  = residual[5][8:1];
    assign row_2[23:16] = residual[6][8:1];
    assign row_2[31:24] = residual[7][8:1];
    assign row_3[7:0]   = residual[8][8:1];
    assign row_3[15:8]  = residual[9][8:1];
    assign row_3[23:16] = residual[10][8:1];
    assign row_3[31:24] = residual[11][8:1];
    assign row_4[7:0]   = residual[12][8:1];
    assign row_4[15:8]  = residual[13][8:1];
    assign row_4[23:16] = residual[14][8:1];
    assign row_4[31:24] = residual[15][8:1];
    
    assign Residual_out = {row_4,row_3,row_2,row_1};

endmodule