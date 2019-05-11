// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
// Date        : Fri May 10 17:38:43 2019
// Host        : DESKTOP-4ICLTEQ running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {c:/Users/Misael/Desktop/UNB/7 SEMESTRE/PROJETO DE CIRCUITOS
//               RECONFIGURAVEIS/prova/prova.srcs/sources_1/ip/blk_mem_gen_xul/blk_mem_gen_xul_stub.v}
// Design      : blk_mem_gen_xul
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_3_6,Vivado 2017.2" *)
module blk_mem_gen_xul(clka, ena, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,addra[6:0],douta[26:0]" */;
  input clka;
  input ena;
  input [6:0]addra;
  output [26:0]douta;
endmodule
