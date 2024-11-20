module DC_prediction (
    input wire clk,
    
    input wire[127:0] MB_data,
    input wire[31:0] Top_data,
    input wire[31:0] Left_data,
    input wire data_ready,
    input wire data_stall,
    
    output wire[131:0] Residual_out,
    output reg Residual_ready   
    
);

    // State encoding using localparam
    localparam IDLE_SAMPLE = 2'b00;
    localparam COMPUTE_DC  = 2'b01;
    localparam COMPUTE_RES = 2'b10;

    // State register
    reg [1:0] state;

    // Registers for input sampling
    reg [7:0] top_sample[3:0];
    reg [7:0] left_sample[3:0];
    reg [7:0] mb_pixels[15:0];
    
    // Registers for intermediate calculations
    reg [7:0] prediction_value;     // Predicted DC value (8 bits)
    reg [8:0] residual[15:0];       // Residual values (9 bits)

    integer i; // Loop index

    // State machine
    always @(posedge clk) begin
        case (state)
            IDLE_SAMPLE: begin
                Residual_ready <= 1'b0;
                
                // Sample inputs if data is ready and no stall condition
                if (data_ready && !data_stall) begin
                    // Sample Top and Left reference pixels
                    for (i = 0; i < 4; i = i + 1) begin
                        top_sample[i] <= Top_data[i * 8 +: 8];
                        left_sample[i] <= Left_data[i * 8 +: 8];
                    end

                    // Sample Macroblock pixels
                    for (i = 0; i < 16; i = i + 1) begin
                        mb_pixels[i] <= MB_data[i * 8 +: 8];
                    end

                    // Transition to next state
                    state <= COMPUTE_DC;
                end
            end

            COMPUTE_DC: begin
                // Compute the average using top 6 MSBs
                reg [5:0] avg_top;  // Temporary storage for 6 MSBs of the top average
                reg [5:0] avg_left; // Temporary storage for 6 MSBs of the left average

                avg_top = (top_sample[0][7:2] + top_sample[1][7:2] + 
                           top_sample[2][7:2] + top_sample[3][7:2]) >> 2;
                avg_left = (left_sample[0][7:2] + left_sample[1][7:2] + 
                            left_sample[2][7:2] + left_sample[3][7:2]) >> 2;

                // Calculate the predicted DC value
                prediction_value <= {avg_top + avg_left}; // 8-bit predicted value
                state <= COMPUTE_RES; // Move to next state
            end

            COMPUTE_RES: begin
                // Compute residuals
                for (i = 0; i < 16; i = i + 1) begin
                    residual[i] <= $signed(mb_pixels[i]) - $signed(prediction_value);
                end

                // Flatten residuals for output
                for (i = 0; i < 16; i = i + 1) begin
                    Residual_out[i * 9 +: 9] <= residual[i];
                end

                Residual_ready <= 1'b1; // Signal residuals are ready
                state <= IDLE_SAMPLE; // Return to idle/sample state
            end
        endcase
    end

    // Initial state
    initial begin
        state = IDLE_SAMPLE;
        Residual_ready = 1'b0;
    end

endmodule