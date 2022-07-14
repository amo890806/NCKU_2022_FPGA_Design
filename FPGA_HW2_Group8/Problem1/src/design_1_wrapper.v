//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
//Date        : Sat Mar 26 12:08:58 2022
//Host        : LAPTOP-VHM006HJ running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (clk,
    rgb4,
    rgb5,
    rst,
    sw);
  input clk;
  output [2:0]rgb4;
  output [2:0]rgb5;
  input rst;
  input [1:0]sw;

  wire clk;
  wire [2:0]rgb4;
  wire [2:0]rgb5;
  wire rst;
  wire [1:0]sw;

  design_1 design_1_i
       (.clk(clk),
        .rgb4(rgb4),
        .rgb5(rgb5),
        .rst(rst),
        .sw(sw));
endmodule
