//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
//Date        : Sat Mar 26 12:31:14 2022
//Host        : LAPTOP-VHM006HJ running 64-bit major release  (build 9200)
//Command     : generate_target top_wrapper.bd
//Design      : top_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module top_wrapper
   (clk,
    rgb4,
    rst);
  input clk;
  output [2:0]rgb4;
  input rst;

  wire clk;
  wire [2:0]rgb4;
  wire rst;

  top top_i
       (.clk(clk),
        .rgb4(rgb4),
        .rst(rst));
endmodule
