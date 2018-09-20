`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/09/09 20:00:48
// Design Name: 
// Module Name: VM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module VM(one_yuan, ten_yuan, clk, rst, cancel, buy_g1, buy_g2, on , occupy, get_good, ret_coin, good1, good2, AN, seg_out,status);

input one_yuan;
input ten_yuan;
input clk;
input rst;
input cancel;
input buy_g1;
input buy_g2;

output on;
output occupy;
output get_good;
output ret_coin;
output good1;
output good2;
output [7:0] AN;
output [7:0] seg_out;

output wire [3:0] status;
wire op_start;
wire [7:0] amount_value;
wire [7:0] ret_value;
wire [3:0] display_mode;
wire g1_bought, g2_bought;

wire counter;


coin_collector cc(one_yuan, ten_yuan, op_start, amount_value, clk, status, counter, g1_bought, g2_bought, cancel, rst);
VMControl control(rst, clk, op_start, amount_value, cancel, buy_g1, buy_g2, on, occupy, get_good, ret_coin, ret_value, good1, good2, status, display_mode, g1_bought, g2_bought);
display dis(clk, rst, occupy, amount_value, AN, seg_out);
endmodule
