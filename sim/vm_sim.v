`timescale 1ns / 1ps

module vm_sim();

reg one_yuan=0;
reg ten_yuan=0;
reg clk=0;
reg rst=0;
reg cancel=0;
reg buy_g1=0;
reg buy_g2=0;

wire on;
wire occupy;
wire get_good;
wire ret_coin;
wire good1;
wire good2;
wire [7:0] AN;
wire [7:0] seg_out;

wire [3:0] status;

always #5 clk = ~clk;

initial fork

#0 rst=0;
#20 rst=1;
#40 one_yuan=1;
#60 one_yuan=0;
#80 one_yuan=1;
#100 one_yuan=0;
#120 one_yuan=1;
#140 one_yuan=0;
#160 buy_g1=1;
#190 buy_g1=0;
#240 ten_yuan=1;
#260 ten_yuan=0;
#280 one_yuan=1;
#300 one_yuan=0;
#320 one_yuan=1;
#340 one_yuan=0;

#360 buy_g2=1;
#390 buy_g2=0;
#440 buy_g1=1;
#470 buy_g1=0;

#570 cancel=1;
#610 cancel=0;
#660 rst=0;

#710 rst=1;
#750 one_yuan=1;
#770 one_yuan=0;
#850 rst=0;


join

VM vm(one_yuan, ten_yuan, clk, rst, cancel, buy_g1, buy_g2, on , occupy, get_good, ret_coin, good1, good2, AN, seg_out,status);
endmodule
