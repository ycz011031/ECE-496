module dct4x4_h264 (
    input wire clk,                     // Clock signal
    input wire reset,                   // Reset signal (active high)
    input wire enable,                  // Enable signal for input loading
    input wire [127:0] matrix_in_flat,  // Flattened 4x4 input matrix (8-bit * 16 elements = 128 bits)
    output reg [207:0] matrix_out_flat, // Flattened 4x4 output matrix (13-bit * 16 elements = 208 bits)
    output reg valid                    // Output valid signal
);

    // Internal 2D matrix wires for input and output
    wire [7:0] matrix_in[3:0][3:0];     // 4x4 input matrix (8-bit elements, unsigned by default)
    reg [12:0] matrix_out[3:0][3:0];    // 4x4 output matrix (13-bit elements, unsigned by default)

    // Intermediate pipeline registers
    reg [10:0] row_stage[3:0][3:0];     // Stage 1: Row transform intermediate values
    reg [12:0] col_stage[3:0][3:0];     // Stage 2: Column transform intermediate values

    // Pipeline control
    reg [1:0] stage;                    // Stage counter (0: idle, 1: row, 2: column)
    reg [3:0] index;                    // Index for computation
    reg computing;                      // Computing flag

    // Transform coefficients for H.264
    localparam [10:0] C0 = 11'd1, C1 = 11'd2;

    // Unflatten the reversed input bit vector into the 2D input matrix
    genvar i, j;
    integer row, col;
    generate
        for (i = 0; i < 4; i = i + 1) begin : unflatten_in
            for (j = 0; j < 4; j = j + 1) begin : unflatten_in_inner
                assign matrix_in[i][j] = matrix_in_flat[((3 - i) * 4 + (3 - j)) * 8 +: 8];
            end
        end
    endgenerate

    // Reset and initialization
    always @(posedge clk) begin
        if (reset) begin
            stage <= 0;
            index <= 0;
            computing <= 0;
            valid <= 0;
            for (row = 0; row < 4; row = row + 1) begin
                for (col = 0; col < 4; col = col + 1) begin
                    row_stage[row][col] <= 0;
                    col_stage[row][col] <= 0;
                    matrix_out[row][col] <= 0;
                end
            end
        end else if (enable) begin
            computing <= 1;
            valid <= 0;
            stage <= 1; // Start row transform
            index <= 0;
        end
    end

    // Stage 1: Row-wise transform (matrix_in * CfT)
    always @(posedge clk) begin
        if (computing && stage == 1) begin
            // Compute row-wise transform using explicit signed casting
            row_stage[index][0] <= $signed(matrix_in[index][0]) + $signed(matrix_in[index][3]);
            row_stage[index][1] <= $signed(matrix_in[index][1]) + $signed(matrix_in[index][2]);
            row_stage[index][2] <= $signed(matrix_in[index][1]) - $signed(matrix_in[index][2]);
            row_stage[index][3] <= $signed(matrix_in[index][0]) - $signed(matrix_in[index][3]);

            if (index == 3) begin
                stage <= 2; // Move to column transform
                index <= 0;
            end else begin
                index <= index + 1;
            end
        end
    end

    // Stage 2: Column-wise transform (Cf * row_stage)

    always @(posedge clk) begin
        if (computing && stage == 2) begin
            // Compute column-wise transform
            col_stage[0][index] <= $signed(row_stage[0][index]) + $signed(row_stage[3][index]);
            col_stage[1][index] <= $signed(row_stage[1][index]) + $signed(row_stage[2][index]);
            col_stage[2][index] <= $signed(row_stage[1][index]) - $signed(row_stage[2][index]);
            col_stage[3][index] <= $signed(row_stage[0][index]) - $signed(row_stage[3][index]);
    
            if (index == 4) begin
                stage <= 0; // Computation done
                index <= 0;
                computing <= 0;
                valid <= 1; // Output is now valid
    
                // Assign col_stage to matrix_out element by element
                for (row = 0; row < 4; row = row + 1) begin
                    for (col = 0; col < 4; col = col + 1) begin
                        matrix_out[row][col] <= col_stage[row][col];
                    end
                end
            end else begin
                index <= index + 1;
            end
        end
    end
    // Flatten the 2D output matrix into the reversed output bit vector
    integer x, y;
    always @(*) begin
        for (x = 0; x < 4; x = x + 1) begin
            for (y = 0; y < 4; y = y + 1) begin
                matrix_out_flat[((3 - x) * 4 + (3 - y)) * 13 +: 13] = matrix_out[x][y];
            end
        end
    end
endmodule