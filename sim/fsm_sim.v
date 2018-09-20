`timescale 1ns / 1ps

module fsm_sim();
reg rst=0;
reg clk=0;
reg op_start=0;
reg [7:0] coin_value=0;
reg cancel=0;
reg buy_g1=0;
reg buy_g2=0;

wire on;
wire occupy;
wire get_good;
wire ret_coin;
wire [7:0] ret_value;
wire good1;
wire good2;
wire g1_bought;
wire g2_bought;

wire [3:0] status;
wire [3:0] display_mode;

always #5 clk = ~clk;

initial fork

#0 rst=0;
#0 coin_value=0;
#40 rst=1;
#60 op_start=1;
#70 op_start=0;
#100 coin_value=4;
#120 coin_value=5;
#140 coin_value=10;
#160 coin_value=20;

#210 buy_g1=1;
#240 buy_g1=0;
#290 buy_g2=1;
#320 buy_g2=0;
#370 buy_g1=1;
#400 buy_g1=0;

#730 cancel=1;
#760 cancel=0;
#790 rst=0;
#840 rst=1;
#870 op_start=1;
#890 op_start=0;
#920 rst=0;


join

VMControl con(rst, clk, op_start, coin_value, cancel, buy_g1, buy_g2, on, occupy, get_good, ret_coin, ret_value, good1, good2, status, display_mode, g1_bought, g2_bought);
endmodule
