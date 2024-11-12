module Intra_Top (
    input  wire clk,
    
    input  wire[31:0] MB_flat,       // Flattened macroblock pixels (16 * 16 * 8 bits)
    input  wire MB_ready,
    input  wire data_ready,
    output reg[14:0] inq_addr,
    output reg inq_update,
    
    output wire[1:0] mode,           // Mode selection: 00 - DC, 01 - Horizontal, 10 - Vertical, 11 - Plane
    output wire[31:0] residual_flat,  // Flattened residual (16 * 16 * 8 bits)
    output wire residual_ready,
    input  wire DCT_clear
);

    reg[31:0] row_1;
    reg[31:0] row_2;
    reg[31:0] row_3;
    reg[31:0] row_4;
    
    reg[31:0] row_cache[239:0];
    reg[31:0] col_cache;
    
    reg[6:0] horizontal_index;
    reg[6:0] vertical_index; 

    initial begin
        horizontal_index <= 7'd0;
        vertical_index   <= 7'd0;
    end       
    
    
    
    
    
    // Instantiate DC mode prediction module
    DC_prediction dc_prediction (
        .clk(clk),
        .reset(reset),
        .top_sample_flat(top_sample_flat),
        .top_sample_avail(top_sample_avail),
        .left_sample_flat(left_sample_flat),
        .left_sample_avail(left_sample_avail),
        .mb_pixels_flat(mb_pixels_flat),
        .residual_flat(dc_residual),
        .available(dc_available)
    );

    // Instantiate Horizontal mode prediction module
    Horizontal_prediction horizontal_prediction (
        .clk(clk),
        .reset(reset),
        .left_sample_flat(left_sample_flat),
        .left_sample_avail(left_sample_avail),
        .mb_pixels_flat(mb_pixels_flat),
        .residual_flat(horizontal_residual),
        .available(horizontal_available)
    );

    // Instantiate Vertical mode prediction module
    Vertical_prediction vertical_prediction (
        .clk(clk),
        .reset(reset),
        .top_sample_flat(top_sample_flat),
        .top_sample_avail(top_sample_avail),
        .mb_pixels_flat(mb_pixels_flat),
        .residual_flat(vertical_residual),
        .available(vertical_available)
    );

    // Instantiate Plane mode prediction module
    Plane_prediction plane_prediction (
        .clk(clk),
        .reset(reset),
        .top_sample_flat(top_sample_flat),
        .top_sample_avail(top_sample_avail),
        .left_sample_flat(left_sample_flat),
        .left_sample_avail(left_sample_avail),
        .mb_pixels_flat(mb_pixels_flat),
        .residual_flat(plane_residual),
        .available(plane_available)
    );

    // Output the residual data based on the selected mode
    
endmodule