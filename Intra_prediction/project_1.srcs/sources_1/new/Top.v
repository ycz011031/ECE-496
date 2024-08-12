module intra16x16_top (
    input clk,
    input reset,
    input [127:0] top_sample_flat,    // Flattened top sample (16 * 8 bits)
    input top_sample_avail,
    input [127:0] left_sample_flat,   // Flattened left sample (16 * 8 bits)
    input left_sample_avail,
    input [2047:0] mb_pixels_flat,    // Flattened macroblock pixels (16 * 16 * 8 bits)
    input [1:0] mode,                 // Mode selection: 00 - DC, 01 - Horizontal, 10 - Vertical, 11 - Plane
    output reg [2047:0] residual_flat // Flattened residual (16 * 16 * 8 bits)
);

    wire [2047:0] dc_residual, horizontal_residual, vertical_residual, plane_residual;
    wire dc_available, horizontal_available, vertical_available, plane_available;

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
    always @(*) begin
        case (mode)
            2'b00: residual_flat = dc_residual;
            2'b01: residual_flat = horizontal_residual;
            2'b10: residual_flat = vertical_residual;
            2'b11: residual_flat = plane_residual;
            default: residual_flat = dc_residual;
        endcase
    end

endmodule