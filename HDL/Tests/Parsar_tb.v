`timescale 1ns / 1ps

module Output_Parsar_tb;

    // Clock period
    parameter CLK_PERIOD = 10;

    // Inputs to the DUT
    reg clk;
    reg [127:0] data_flat;
    reg data_ready;
    reg data_idle;

    // Outputs from the DUT
    wire Parsar_busy;
    wire [31:0] FIFO_tx_din;
    wire FIFO_tx_enable;

    // Instantiate the DUT (Device Under Test)
    Output_Parsar dut (
        .clk(clk),
        .data_flat(data_flat),
        .data_ready(data_ready),
        .data_idle(data_idle),
        .Parsar_busy(Parsar_busy),
        .FIFO_tx_din(FIFO_tx_din),
        .FIFO_tx_enable(FIFO_tx_enable)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    // Testbench logic
    initial begin
        // Initialize signals
        data_flat = 128'd0;
        data_ready = 1'b0;
        data_idle = 1'b0;

        // Wait for reset
        #100;

        // Simulate transmitting 256 bytes of data
        for (integer i = 0; i < 256 / 16; i = i + 1) begin
            // Assert data_ready with new data_flat values
            data_flat = {32'hA1B2C3D4, 32'hE5F60718, 32'h192A3B4C, 32'h5D6E7F80}; // Example data
            data_ready = 1'b1;
            data_idle = (i == (256 / 16) - 1) ? 1'b1 : 1'b0; // Assert data_idle only for the last chunk

            // Wait for the module to accept the data
            wait(Parsar_busy);
            #CLK_PERIOD;
            data_ready = 1'b0; // Deassert data_ready once data is accepted

            // Wait until module finishes processing the current chunk
            wait(!Parsar_busy);
        end

        // Wait for a few clock cycles after data transmission
        #50;

        // End the simulation
        $stop;
    end

    // Monitor output signals
    initial begin
        $monitor("Time: %t | Parsar_busy: %b | FIFO_tx_enable: %b | FIFO_tx_din: %h",
                 $time, Parsar_busy, FIFO_tx_enable, FIFO_tx_din);
    end

endmodule