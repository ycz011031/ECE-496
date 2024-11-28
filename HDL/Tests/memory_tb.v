`timescale 1ns / 1ps

module Memory_Interface_tb;

    // Parameters
    parameter CLK_PERIOD = 10;

    // Signals
    reg clk;
    reg [31:0] PC_rx_async;
    reg FIFO_rx_BT;
    reg [7:0] FIFO_rx_dout;
    reg FIFO_rx_empty;
    reg FIFO_rx_Block_rdy;
    reg frame_complete;
    reg [14:0] inq_addr;
    reg inqury_update;
    
    wire FIFO_rx_enable;
    wire FIFO_rx_ready;
    wire [31:0] MB_flat;
    wire MB_ready;
    wire data_ready;

    // DUT instantiation
    Memory_Interface uut (
        .clk(clk),
        .PC_rx_async(PC_rx_async),
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

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    // Testbench logic
    initial begin
        // Initialization
        PC_rx_async = 0;
        FIFO_rx_BT = 0;
        FIFO_rx_dout = 0;
        FIFO_rx_empty = 1;
        FIFO_rx_Block_rdy = 1;
        frame_complete = 0;
        inq_addr = 0;
        inqury_update = 0;

        // Reset
        #100;

        // Simulate receiving blocks of data
        for (integer vertical = 0; vertical < 256; vertical = vertical + 1) begin
            // Deassert FIFO empty first
            FIFO_rx_empty = 0;    // Indicate data available in FIFO
            #40;          // Wait one clock cycle
            
            // Assert block ready
            FIFO_rx_Block_rdy = 0; // Block of data is ready
            wait (FIFO_rx_ready); // Wait until module signals it's ready

            // Send 256 bytes for the current row
            for (integer horizontal = 0; horizontal < 256; horizontal = horizontal + 1) begin
                FIFO_rx_dout = horizontal + vertical; // Example data
                #CLK_PERIOD;
            end

            FIFO_rx_empty = 1;    // Indicate FIFO is now empty
            #CLK_PERIOD;          // Wait one clock cycle before deasserting block ready
            FIFO_rx_Block_rdy = 1; // Deassert block ready
            wait (!FIFO_rx_ready); // Wait for the module to finish the current block
        end

        // Completion
        #100;
        $stop;
    end

endmodule