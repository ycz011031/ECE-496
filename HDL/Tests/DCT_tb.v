`timescale 1ns / 1ps

module tb_dct4x4_h264;

    // Parameters
    localparam CLK_PERIOD = 10; // Clock period in ns

    // Testbench signals
    reg clk;
    reg reset;
    reg enable;
    reg [127:0] matrix_in_flat;
    wire [207:0] matrix_out_flat;
    wire valid;

    // Instantiate the DUT (Device Under Test)
    dct4x4_h264 dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .matrix_in_flat(matrix_in_flat),
        .matrix_out_flat(matrix_out_flat),
        .valid(valid)
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
        enable = 0;
        matrix_in_flat = 0;

        // Wait for 2 clock cycles
        #(2 * CLK_PERIOD);

        // Deassert reset
        reset = 0;

        // Apply input and enable computation
        @(posedge clk);
        matrix_in_flat = {
            8'd1, 8'd2, 8'd3, 8'd4,   // Row 3
            8'd5, 8'd6, 8'd7, 8'd8,   // Row 2
            8'd9, 8'd10, 8'd11, 8'd12, // Row 1
            8'd13, 8'd14, 8'd15, 8'd16 // Row 0
        };
        enable = 1;

        // Wait for 1 clock cycle
        @(posedge clk);
        enable = 0;

        // Wait for the output to be valid
        wait(valid);

        // Check output
        $display("Output valid at time %0t", $time);
        $display("matrix_out_flat = %h", matrix_out_flat);

        // Finish simulation
        #(CLK_PERIOD);
        $stop;
    end

endmodule