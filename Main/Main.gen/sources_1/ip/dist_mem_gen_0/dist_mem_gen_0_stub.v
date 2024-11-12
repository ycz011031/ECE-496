// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Sun Nov 10 21:55:57 2024
// Host        : DESKTOP-AENBBM7 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {c:/Users/Yicheng Zhou/OneDrive/Desktop/UIUC/ECE
//               496/FPGA_build/Main/Main.gen/sources_1/ip/dist_mem_gen_0/dist_mem_gen_0_stub.v}
// Design      : dist_mem_gen_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a75tfgg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_13,Vivado 2022.2" *)
module dist_mem_gen_0(a, d, dpra, clk, we, dpo)
/* synthesis syn_black_box black_box_pad_pin="a[14:0],d[7:0],dpra[14:0],clk,we,dpo[7:0]" */;
  input [14:0]a;
  input [7:0]d;
  input [14:0]dpra;
  input clk;
  input we;
  output [7:0]dpo;
endmodule
