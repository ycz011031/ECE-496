`timescale 1ns/1ps

module tb_Memory_Interface;

    // Clock generation
    reg clk;
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz clock (10 ns period)

    // Signals for testing
    reg [31:0] PC_rx_async;
    wire [31:0] PC_tx_async;

    reg FIFO_tx_BT;
    wire FIFO_tx_enable;
    wire [7:0] FIFO_tx_din;
    reg FIFO_rx_BT;
    reg [7:0] FIFO_rx_dout;
    reg FIFO_rx_empty;
    reg FIFO_rx_Block_rdy;
    wire FIFO_rx_enable;
    wire FIFO_rx_ready;

    reg frame_complete;
    reg [14:0] inq_addr;
    reg inqury_update;

    wire [31:0] MB_flat;
    wire MB_ready;
    wire data_ready;

    // Instantiate the DUT (Device Under Test)
    Memory_Interface DUT (
        .clk(clk),
        .PC_rx_async(PC_rx_async),
        .PC_tx_async(PC_tx_async),
        .FIFO_tx_BT(FIFO_tx_BT),
        .FIFO_tx_enable(FIFO_tx_enable),
        .FIFO_tx_din(FIFO_tx_din),
        .FIFO_rx_BT(FIFO_rx_BT),
        .FIFO_rx_dout(FIFO_rx_dout),
        .FIFO_rx_empty(FIFO_rx_empty),
        .FIFO_rx_Block_rdy(FIFO_rx_Block_rdy),
        .FIFO_rx_enable(FIFO_rx_enable),
        .FIFO_rx_ready(FIFO_rx_ready),
        .MB_flat(MB_flat),
        .MB_ready(MB_ready),
        .data_ready(data_ready),
        .frame_complete(frame_complete),
        .inq_addr(inq_addr),
        .inqury_update(inqury_update)
    );

    // Testbench logic
    initial begin
        // Initialize inputs
        PC_rx_async = 32'h0000_0000;
        FIFO_tx_BT = 0;
        FIFO_rx_BT = 0;
        FIFO_rx_dout = 8'h00;
        FIFO_rx_empty = 1;
        FIFO_rx_Block_rdy = 1;
        frame_complete = 0;
        inq_addr = 15'h0000;
        inqury_update = 0;

        // Wait for reset
        #50;

        // Test scenario: Write data into RAM
        FIFO_rx_empty = 0; // Simulate data ready in FIFO
        FIFO_rx_Block_rdy = 0; // Simulate block ready signal
        #100;

        // Feed data to FIFO_rx_dout
        repeat (256) begin
            @(posedge clk);
            FIFO_rx_dout = $random % 256; // Generate random data
        end

        // Complete writing and check DRAM_write_complete
        @(posedge clk);
        FIFO_rx_empty = 1;
        FIFO_rx_Block_rdy = 1;

        // Test scenario: Read from RAM
        frame_complete = 1;
        inqury_update = 1;
        inq_addr = 15'h0020;
        #10;
        inqury_update = 0;

        // Wait for MB_ready
        wait(MB_ready);
        $display("MB_flat: %h", MB_flat);

        // End simulation
        #100;
        $stop;
    end

endmodule