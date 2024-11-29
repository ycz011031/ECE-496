module quantize (
    input wire clk,                         // Clock signal
    input wire reset,                       // Reset signal (active high)
    input wire enable,                      // Enable signal for input processing
    input wire [207:0] dct_in_flat,         // Flattened 4x4 DCT matrix (13-bit * 16 elements = 208 bits)
    input wire [127:0] quant_matrix_flat,   // Flattened 4x4 quantization matrix (8-bit unsigned * 16 elements = 128 bits)
    output reg [127:0] quant_out_flat,      // Flattened 4x4 quantized matrix (8-bit unsigned * 16 elements = 128 bits)
    output reg valid                        // Output valid signal
);

    // Internal 2D representations
    wire signed [12:0] dct_in[3:0][3:0];     // 4x4 DCT matrix (signed 13-bit)
    wire [7:0] quant_matrix[3:0][3:0];       // 4x4 quantization matrix (unsigned 8-bit)
    reg [7:0] quant_out[3:0][3:0];           // 4x4 quantized output matrix (unsigned 8-bit)

    // Flatten to 2D representation
    genvar i, j;
    generate
        for (i = 0; i < 4; i = i + 1) begin : flatten_dct
            for (j = 0; j < 4; j = j + 1) begin : flatten_dct_inner
                assign dct_in[i][j] = dct_in_flat[((i * 4 + j) * 13) +: 13];
                assign quant_matrix[i][j] = quant_matrix_flat[((i * 4 + j) * 8) +: 8];
            end
        end
    endgenerate

    // Processing control
    reg [3:0] row, col; // Indices for processing
    reg processing;     // Processing flag

    // Reset and initialization
    always @(posedge clk) begin
        if (reset) begin
            valid <= 0;
            processing <= 0;
            row <= 0;
            col <= 0;

            // Initialize quant_out
            for (row = 0; row < 4; row = row + 1) begin
                for (col = 0; col < 4; col = col + 1) begin
                    quant_out[row][col] <= 0;
                end
            end
        end else if (enable) begin
            processing <= 1;
            valid <= 0;
            row <= 0;
            col <= 0;
        end
    end

    // Quantization logic
    always @(posedge clk) begin
        if (processing) begin
            // Perform quantization: Quantize each DCT coefficient using the quantization matrix
            quant_out[row][col] <= ($signed(dct_in[row][col]) / $signed(quant_matrix[row][col]));

            // Update indices
            if (col == 3) begin
                col <= 0;
                if (row == 3) begin
                    row <= 0;
                    processing <= 0; // Quantization complete
                    valid <= 1;      // Signal valid output
                end else begin
                    row <= row + 1;
                end
            end else begin
                col <= col + 1;
            end
        end
    end

    // Flatten the 2D quantized matrix into the output bit vector
    integer x, y;
    always @(*) begin
        for (x = 0; x < 4; x = x + 1) begin
            for (y = 0; y < 4; y = y + 1) begin
                quant_out_flat[((x * 4 + y) * 8) +: 8] = quant_out[x][y];
            end
        end
    end
endmodule