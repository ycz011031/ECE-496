`timescale 1ns / 1ps

module tb_dct_quantize;

    // Parameters
    localparam CLK_PERIOD = 10; // Clock period in ns

    // Testbench signals
    reg clk;
    reg reset;
    reg enable_dct;
    reg enable_quant;
    reg [127:0] matrix_in_flat;         // Input matrix to DCT
    reg [127:0] quant_matrix_flat;      // Quantization matrix
    wire [207:0] dct_out_flat;          // Output of DCT
    wire dct_valid;                     // DCT output valid signal
    wire [127:0] quant_out_flat;        // Final quantized output
    wire quant_valid;                   // Quantization output valid signal

    // Instantiate the DCT module
    dct4x4_h264 dct_module (
        .clk(clk),
        .reset(reset),
        .enable(enable_dct),
        .matrix_in_flat(matrix_in_flat),
        .matrix_out_flat(dct_out_flat),
        .valid(dct_valid)
    );

    // Instantiate the Quantization module
    quantize quant_module (
        .clk(clk),
        .reset(reset),
        .enable(enable_quant),
        .dct_in_flat(dct_out_flat),
        .quant_matrix_flat(quant_matrix_flat),
        .quant_out_flat(quant_out_flat),
        .valid(quant_valid)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk; // Toggle clock every half period
    end

    // Stimulus
    initial begin
        // Initialize signals
        reset = 1;
        enable_dct = 0;
        enable_quant = 0;
        matrix_in_flat = 0;
        quant_matrix_flat = {
            8'd16, 8'd11, 8'd10, 8'd16,   // Row 3
            8'd12, 8'd12, 8'd14, 8'd19,   // Row 2
            8'd14, 8'd13, 8'd16, 8'd24,   // Row 1
            8'd18, 8'd17, 8'd22, 8'd29    // Row 0
        }; // Example quantization matrix

        // Wait for 2 clock cycles
        #(2 * CLK_PERIOD);

        // Deassert reset
        reset = 0;

        // Apply input to DCT
        @(posedge clk);
        matrix_in_flat = {
            8'd1, 8'd2, 8'd3, 8'd4,   // Row 3
            8'd5, 8'd6, 8'd7, 8'd8,   // Row 2
            8'd9, 8'd10, 8'd11, 8'd12, // Row 1
            8'd13, 8'd14, 8'd15, 8'd16 // Row 0
        };
        enable_dct = 1;

        // Wait for 1 clock cycle
        @(posedge clk);
        enable_dct = 0;

        // Wait for DCT to produce a valid output
        wait(dct_valid);

        // Enable quantization after DCT output is valid
        @(posedge clk);
        enable_quant = 1;

        // Wait for 1 clock cycle
        @(posedge clk);
        enable_quant = 0;

        // Wait for Quantization to produce a valid output
        wait(quant_valid);

        // Check final quantized output
        $display("Quantized Output Valid at time %0t", $time);
        $display("Quantized Output (flattened): %h", quant_out_flat);

        // Finish simulation
        #(CLK_PERIOD);
        $stop;
    end

endmodule