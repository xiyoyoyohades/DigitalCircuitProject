`timescale 1ns / 1ps

module down_counter #(parameter  target = 60) (clk, rst, out_clk, number);
input clk;
input rst;
output out_clk;
output [7:0] number;

reg [7:0] counter;
assign number=target-counter;

divider #(50000000,32)(clk, rst, out_clk);

always @(posedge out_clk) begin
    counter=counter+1;
end

endmodule





