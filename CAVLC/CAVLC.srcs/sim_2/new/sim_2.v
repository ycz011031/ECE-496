module test;

    // State constants
    localparam STATE_IDLE   = 3'b000;
    localparam STATE_READ   = 3'b001;
    localparam STATE_CTOKEN = 3'b010;
    localparam STATE_T1SIGN = 3'b011;
    localparam STATE_COEFFS = 3'b100;
    localparam STATE_TZEROS = 3'b101;
    localparam STATE_RUNBF  = 3'b110;

    // Signals
    reg CLK = 0;            // clock
    reg CLK2;               // 2x clock
    reg ENABLE = 0;         // values transferred only when this is 1
    wire READY;             // values transferred only when this is 1
    reg [11:0] VIN = 12'h000;    // 12-bit max (+/- 2048)
    reg [4:0] NIN;
    wire [24:0] VE;
    wire [4:0] VL;
    wire VALID = 0;          // enable delayed to same as VE/VL
    wire [2:0] XSTATE;
    reg [2:0] STATE = 3'b000;
    wire [4:0] NOUT;
    reg [11:0] VIN1 = 12'h000;
    reg [11:0] VIN2 = 12'h000;
    reg EN1, EN2;
    reg SIN = 0;            // stream/strobe flag, copied to VS
    wire VS;                // stream/strobe flag sync'd with VL/VE

    // Instantiate h264cavlc module
    reg signed [11:0] data[0:6][0:15];

    // Initialize the data array in an initial block
    initial begin
        data[0][0] = 12'd0;    data[0][1] = 12'd3;    data[0][2] = -12'd1;  data[0][3] = 12'd0;
        data[0][4] = 12'd0;    data[0][5] = -12'd1;   data[0][6] = 12'd1;   data[0][7] = 12'd0;
        data[0][8] = 12'd1;    data[0][9] = 12'd0;    data[0][10] = 12'd0;  data[0][11] = 12'd0;
        data[0][12] = 12'd0;   data[0][13] = 12'd0;   data[0][14] = 12'd0;  data[0][15] = 12'd0;

        data[1][0] = -12'd2;   data[1][1] = 12'd4;    data[1][2] = 12'd0;   data[1][3] = -12'd1;
        data[1][4] = 12'd3;    data[1][5] = 12'd0;    data[1][6] = 12'd0;   data[1][7] = 12'd0;
        data[1][8] = -12'd3;   data[1][9] = 12'd0;    data[1][10] = 12'd0;  data[1][11] = 12'd0;
        data[1][12] = 12'd0;   data[1][13] = 12'd0;   data[1][14] = 12'd0;  data[1][15] = 12'd0;

        data[2][0] = -12'd2;   data[2][1] = 12'd4;    data[2][2] = 12'd2;   data[2][3] = -12'd1;
        data[2][4] = 12'd3;    data[2][5] = 12'd1;    data[2][6] = 12'd1;   data[2][7] = 12'd1;
        data[2][8] = -12'd3;   data[2][9] = 12'd1;    data[2][10] = 12'd1;  data[2][11] = 12'd2;
        data[2][12] = -12'd1;  data[2][13] = -12'd1;  data[2][14] = 12'd1;  data[2][15] = 12'd1;

        data[3][0] = -12'd2;   data[3][1] = 12'd4;    data[3][2] = 12'd0;   data[3][3] = -12'd1;
        data[3][4] = 12'd3;    data[3][5] = 12'd0;    data[3][6] = 12'd0;   data[3][7] = 12'd2;
        data[3][8] = -12'd3;   data[3][9] = 12'd0;    data[3][10] = 12'd0;  data[3][11] = 12'd0;
        data[3][12] = 12'd0;   data[3][13] = 12'd0;   data[3][14] = 12'd0;  data[3][15] = 12'd0;

        data[4][0] = 12'd4;    data[4][1] = 12'd3;    data[4][2] = 12'd3;   data[4][3] = 12'd3;
        data[4][4] = 12'd3;    data[4][5] = 12'd2;    data[4][6] = 12'd3;   data[4][7] = 12'd2;
        data[4][8] = -12'd3;   data[4][9] = 12'd1;    data[4][10] = 12'd2;  data[4][11] = 12'd2;
        data[4][12] = 12'd1;   data[4][13] = 12'd2;   data[4][14] = 12'd3;  data[4][15] = 12'd2;

        data[5][0] = 12'd1;    data[5][1] = 12'd1;    data[5][2] = 12'd1;   data[5][3] = 12'd1;
        data[5][4] = 12'd1;    data[5][5] = 12'd1;    data[5][6] = 12'd1;   data[5][7] = 12'd1;
        data[5][8] = 12'd1;    data[5][9] = 12'd1;    data[5][10] = 12'd1;  data[5][11] = 12'd1;
        data[5][12] = 12'd0;   data[5][13] = 12'd0;   data[5][14] = 12'd0;  data[5][15] = 12'd0;

        data[6][0] = 12'd0;    data[6][1] = 12'd0;    data[6][2] = 12'd0;   data[6][3] = 12'd0;
        data[6][4] = 12'd0;    data[6][5] = 12'd0;    data[6][6] = 12'd0;   data[6][7] = 12'd0;
        data[6][8] = 12'd0;    data[6][9] = 12'd0;    data[6][10] = 12'd0;  data[6][11] = 12'd0;
        data[6][12] = 12'd0;   data[6][13] = 12'd0;   data[6][14] = 12'd0;  data[6][15] = 12'd0;
    end

    // Instantiate h264cavlc module
    h264cavlc uut (
        .CLK(CLK),
        .CLK2(CLK2),
        .ENABLE(ENABLE),
        .READY(READY),
        .VIN(VIN),
        .NIN(NIN),
        .SIN(SIN),
        .VS(VS),
        .VE(VE),
        .VL(VL),
        .VALID(VALID),
        .XSTATE(XSTATE),
        .NOUT(NOUT)
    );

    // Clock generation
    always begin
        CLK2 = 0;
        #5;
        CLK2 = 1;
        CLK = ~CLK;
        #5;
    end

    // Data input process
    integer index;

    initial begin
        ENABLE = 0;

        for (index = 0; index <= 6; index = index + 1) begin
            wait(READY == 1);
            @(posedge CLK2); ENABLE = 1;
            if (index == 5) SIN = 1;
            NIN = 5'b00000;
            VIN = $signed(data[index][15]);
            @(posedge CLK2); VIN = $signed(data[index][14]);
            @(posedge CLK2); VIN = $signed(data[index][11]);
            @(posedge CLK2); VIN = $signed(data[index][7]);
            @(posedge CLK2); VIN = $signed(data[index][10]);
            @(posedge CLK2); VIN = $signed(data[index][13]);
            @(posedge CLK2); VIN = $signed(data[index][12]);
            @(posedge CLK2); VIN = $signed(data[index][9]);
            @(posedge CLK2); VIN = $signed(data[index][6]);
            @(posedge CLK2); VIN = $signed(data[index][3]);
            @(posedge CLK2); VIN = $signed(data[index][2]);
            @(posedge CLK2); VIN = $signed(data[index][5]);
            @(posedge CLK2); VIN = $signed(data[index][8]);
            @(posedge CLK2); VIN = $signed(data[index][4]);
            @(posedge CLK2); VIN = $signed(data[index][1]);
            @(posedge CLK2); VIN = $signed(data[index][0]);
            @(posedge CLK2); ENABLE = 0;
        end

        #1000000; // wait for 1 ms
    end

    // Pipeline for VIN
    always @(posedge CLK2) begin
        EN2 <= ENABLE;
        VIN2 <= VIN;
        EN1 <= EN2;
        VIN1 <= VIN2;
    end

    // Debug process
    always @(posedge CLK) begin
        STATE <= XSTATE;  // delay XSTATE by 1 clk so it lines up with VE/VL
    end

endmodule


