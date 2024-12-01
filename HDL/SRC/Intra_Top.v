module Intra_Top (
    input  wire clk,
    
    input  wire[31:0] MB_flat,       // Flattened macroblock pixels (16 * 16 * 8 bits)
    input  wire MB_ready,
    input  wire data_ready,
    input  wire Process_start,
    output reg[14:0] inq_addr,
    output reg inq_update,
    output reg frame_complete,
    
    output wire[1:0] mode,           // Mode selection: 00 - DC, 01 - Horizontal, 10 - Vertical, 11 - Plane
    output wire[127:0] residual_flat,  // Flattened residual (16 * 16 * 8 bits)
    output wire residual_ready,
    input  wire DCT_busy,
    input  wire[1:0] mode_select,
    
    output wire[2:0] debug_status_intra
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
    integer i;
    initial begin
        horizontal_index <= 7'd0;
        vertical_index   <= 7'd0;
        cur_state_inq    <= 3'd0;
        cur_sub_block    <= 2'd0;
        col_cache        <= 64'h0f0f0f0f;        
        for (i = 0; i < 64; i = i + 1) begin
            row_cache[i] = 64'h0f0f0f0f;
        end
        inq_addr   <= 15'd0;
        inq_update <= 1'b0;
        
        row_1 <= 32'd0;
        row_2 <= 32'd0;
        row_3 <= 32'd0;
        row_4 <= 32'd0;
        
    end 
    
    always @(posedge clk) begin
        case(cur_state_inq)
          3'b000 : begin
            data_strobe <= 1'b0;
            inq_addr    <= 15'd0;
            inq_update  <= 1'b0;
            if (Process_start == 1'b1 && data_ready == 1'b1) begin
                cur_state_inq     <= 3'b001;
                horizontal_index  <= 7'd0;
                vertical_index    <= 7'd0;
                cur_sub_block     <= 2'd0;
                frame_complete    <= 1'd0;
            end else frame_complete <= 1'd1;
          end
          3'b001 : begin
            data_strobe <= 1'b0;
            inq_addr <= {vertical_index,cur_sub_block[1],horizontal_index,cur_sub_block[0]};                  
            inq_update <= 1'b1;
            if (MB_ready == 1'b0) begin
                cur_state_inq <= 3'b010;
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
                        cur_sub_block <= cur_sub_block + 1;
                    end
                    2'd1 : begin
                        row_1[31:16] <= MB_flat[15:0];
                        row_2[31:16] <= MB_flat[31:16];
                        cur_state_inq <= 3'b001;
                        cur_sub_block <= cur_sub_block + 1;
                    end          
                    2'd2 : begin
                        row_3[15:0] <= MB_flat[15:0];
                        row_4[15:0] <= MB_flat[31:16];
                        cur_state_inq <= 3'b001;
                        cur_sub_block <= cur_sub_block + 1;
                    end
                    2'd3 : begin
                        row_3[31:16] <= MB_flat[15:0];
                        row_4[31:16] <= MB_flat[31:16];
                        cur_state_inq <= 3'b100;
                        cur_sub_block <= cur_sub_block + 1;
                    end
                endcase              
            end
          end
          3'b100 : begin
             data_strobe <= 1'b1;             
             if (prediction_ready == 1'b1) begin
                row_cache[horizontal_index] <= row_4;
                col_cache<={row_4[31:24],row_3[31:24],row_2[31:24],row_1[31:24]};
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
    
    wire[127:0] pred_data_DC;
    wire[127:0] pred_data_H;
    wire[127:0] pred_data_V;
    wire pred_ready_DC;
    wire pred_ready_H;
    wire pred_ready_V;
    
    wire select_busy;        
    
    assign prediction_ready = pred_ready_DC;
    
    DC_prediction DC_mode(
        .clk(clk),
        
        .MB_data({row_4,row_3,row_2,row_1}),
        .Top_data(row_cache[horizontal_index]),
        .Left_data(col_cache),
        .data_ready(data_strobe),
        .data_stall(select_busy),
        
        .Residual_out(pred_data_DC),
        .Residual_ready(pred_ready_DC));
        
    Vertical_prediction V_mode(
        .clk(clk),
        
        .MB_data({row_4,row_3,row_2,row_1}),
        .Top_data(row_cache[horizontal_index]),
        .data_ready(data_strobe),
        .data_stall(select_busy),
        
        .Residual_out(pred_data_V),
        .Residual_ready(pred_ready_V));
            
    Horizontal_prediction H_mode(
        .clk(clk),
        
        .MB_data({row_4,row_3,row_2,row_1}),
        .Left_data(col_cache),
        .data_ready(data_strobe),
        .data_stall(select_busy),
        
        .Residual_out(pred_data_H),
        .Residual_ready(pred_ready_H));
    
    
    wire [127:0] placeholder;        
    Residual_Select Residual_select(
        .clk(clk),
        .stall(DCT_busy),
        
        .pred_block_0(pred_data_DC),
        .pred_block_0_ready(pred_ready_DC),
        .pred_block_1(pred_data_V),
        .pred_block_1_ready(pred_ready_V),
        .pred_block_2(pred_data_H),
        .pred_block_2_ready(pred_ready_H),
        
        .mode_select(mode_select),
        .residual_flat(placeholder),
        .residual_mode(mode),
        .residual_ready(residual_ready),
        .select_busy(select_busy));
    
    assign debug_status_intra = cur_state_inq;
    assign residual_flat = {row_4,row_3,row_2,row_1};

    // Output the residual data based on the selected mode
    
endmodule