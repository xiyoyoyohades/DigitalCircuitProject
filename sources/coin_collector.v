`timescale 1ns / 1ps

module coin_collector(one_yuan, ten_yuan, op_start, amount_value, clk, status, counter, g1_bought, g2_bought,
cancel, rst);
input one_yuan;
input ten_yuan;
input clk;
input [3:0] status;
input g1_bought;
input g2_bought;
input cancel;
input rst;

output reg [7:0] amount_value;
output reg op_start;
output reg counter;
reg bought_lock;

always @(posedge clk) begin
if(one_yuan==1) begin
    if(counter==0) begin
    amount_value<=(amount_value+2)>30?amount_value:amount_value+2;
    counter<=1;
    end
end
else if(ten_yuan==1) begin
        if(counter==0) begin
        amount_value<=(amount_value+20)>30?amount_value:amount_value+20;
        counter<=1;
        end
        end
else begin
    counter<=0;
end

if(g1_bought==1) begin
if(bought_lock==0) begin
amount_value<=amount_value-5;
bought_lock<=1;
end
end
else if(g2_bought==1) begin
if(bought_lock==0) begin
amount_value<=amount_value-10;
bought_lock<=1;
end
end
else begin
bought_lock<=0;
end

if(amount_value!=0 && status==1) begin
  op_start<=1;
end

if(status!=1) begin
  op_start<=0;
end

if(cancel==1||rst==0) begin
amount_value<=0;
end

end



endmodule // coin_collector