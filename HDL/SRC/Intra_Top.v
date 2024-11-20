module Intra_Top (
    input  wire clk,
    
    input  wire[31:0] MB_flat,       // Flattened macroblock pixels (16 * 16 * 8 bits)
    input  wire MB_ready,
    input  wire data_ready,
    output reg[14:0] inq_addr,
    output reg inq_update,
    output reg frame_complete,
    
    output wire[1:0] mode,           // Mode selection: 00 - DC, 01 - Horizontal, 10 - Vertical, 11 - Plane
    output wire[31:0] residual_flat,  // Flattened residual (16 * 16 * 8 bits)
    output wire residual_ready,
    input  wire DCT_clear
);

    reg[31:0] row_1;
    reg[31:0] row_2;
    reg[31:0] row_3;
    reg[31:0] row_4;
    
    reg[31:0] row_cache[63:0];
    reg[31:0] col_cache;
    
    reg[5:0] horizontal_index;
    reg[5:0] vertical_index;       
   
    reg [2:0] cur_state_inq;
    reg [1:0] cur_sub_block;
    reg data_strobe;
    reg data_ready_reg;
    
    wire prediction_ready;
    
    initial begin
        horizontal_index <= 7'd0;
        vertical_index   <= 7'd0;
        cur_state_inq    <= 3'd0;
        cur_sub_block    <= 2'd0;
    end 
    
    always @(posedge clk) begin
        case(cur_state_inq)
          3'b000 : begin
            data_strobe <= 1'b0;
            data_ready_reg <= data_ready;
            if (data_ready_reg == 1'b0 && data_ready == 1'b1) begin
                cur_state_inq     <= 3'b001;
                horizontal_index  <= 7'd0;
                vertical_index    <= 7'd0;
                cur_sub_block     <= 2'd0;
                frame_complete    <= 1'd0;
            end else frame_complete <= 1'd1;
          end
          3'b001 : begin
            data_strobe <= 1'b0;
            inq_addr <= {horizontal_index,cur_sub_block[0],vertical_index,cur_sub_block[1]}*424;                  
            inq_update <= 1'b1;
            if (MB_ready == 1'b0) begin
                cur_state_inq <= 3'b010;
                cur_sub_block <= cur_sub_block + 1;
            end    
          end
          3'b010 : begin
            inq_update <= 1'b0;
            if (MB_ready == 1'b1) begin
                case (cur_sub_block)
                    2'd0 : begin
                        row_1[15:0] <= MB_flat[15:0];
                        row_2[15:0] <= MB_flat[31:16];
                        cur_state_inq <= 3'b001;
                    end
                    2'd1 : begin
                        row_1[31:16] <= MB_flat[15:0];
                        row_2[31:16] <= MB_flat[31:16];
                        cur_state_inq <= 3'b001;
                    end          
                    2'd2 : begin
                        row_3[15:0] <= MB_flat[15:0];
                        row_4[15:0] <= MB_flat[31:16];
                        cur_state_inq <= 3'b001;
                    end
                    2'd3 : begin
                        row_3[31:16] <= MB_flat[15:0];
                        row_4[31:16] <= MB_flat[31:16];
                        cur_state_inq <= 3'b100;
                    end
                endcase              
            end
          end
          3'b100 : begin
             data_strobe <= 1'b1;
             row_cache[horizontal_index] <= row_4;
             col_cache<={row_4[31:24],row_3[31:24],row_2[31:24],row_1[31:24]};
             if (prediction_ready == 1'b1) begin
                 if (horizontal_index == 6'd63) begin
                     horizontal_index <= 6'd0;
                     if (vertical_index == 6'd63) begin
                         vertical_index <= 6'd0;
                         cur_state_inq <= 3'b000;
                     end else begin
                         vertical_index <= vertical_index + 1;
                         cur_state_inq <= 3'b001;
                     end
                 end else begin
                     horizontal_index <= horizontal_index + 1;
                     cur_state_inq <= 3'b001;
                 end
            end       
          end                    
        endcase            
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