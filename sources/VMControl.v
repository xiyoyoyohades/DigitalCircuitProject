`timescale 1ns / 1ps

module VMControl(
rst, clk, op_start, coin_value, cancel, buy_g1, buy_g2, on, occupy, get_good, ret_coin, ret_value, good1, good2, status, display_mode,
g1_bought, g2_bought
);

input rst;
input clk;
input op_start;
input [7:0] coin_value;
input cancel;
input buy_g1;
input buy_g2;

output reg on;
output reg occupy;
output reg get_good;
output reg ret_coin;
output reg [7:0] ret_value;
output reg good1;
output reg good2;
output reg g1_bought;
output reg g2_bought;

output reg [3:0] status;
output reg [3:0] display_mode;

reg [7:0] amount_twopfive;
reg [7:0] amount_five;

reg buy_lock, cancel_lock, wait_type;

wire clk_n;
reg [31:0] counter;

parameter S_off=0, S0=1, S1=2, S2=3, S3=4, S4=5, S5=6, S6=7, S_wait=8;

initial begin
  amount_twopfive=5;
  amount_five=5;
  status=S_off;
end

//divider conv_time(clk, 0, clk_n);

always @(posedge clk) begin

case (status)
  S_off : begin
    on<=0;
    occupy<=0;
    get_good<=0;
    ret_coin<=0;
    ret_value<=0;
    good1<=0;
    good2<=0;
    ret_value<=coin_value;
	if(rst==1) begin
	status<=S0;
	end
  end

  S0 : begin
    on<=1;
    occupy<=0;
    get_good<=0;
    ret_coin<=0;
    ret_value<=coin_value;
    good1<=0;
    good2<=0;
    display_mode<=0;
    if(op_start==1) begin
      status<=S1;
    end
	else if(rst==0) begin
	status<=S_off;
	end
  end

  S1: begin
    on<=1;
    occupy<=1;
    get_good<=0;
    ret_coin<=0;
    ret_value<=coin_value;
    good1<=0;
    good2<=0;
    if(coin_value<5) begin
      status<=S1;
    end
    else if(coin_value<10) begin
      if(amount_twopfive==0) begin
        status<=S1;
      end
      else begin
        status<=S2;
      end
    end
    else begin
      if(amount_twopfive==0&&amount_five==0) begin
        status<=S1;
      end
      else if(amount_twopfive!=0 && amount_five==0) begin
        status<=S2;
      end
      else if(amount_twopfive==0 && amount_five!=0) begin
        status<=S3;
      end
      else begin
        status<=S4;
      end

    end
	if(rst==0) begin
	status<=S6;
	end
	else if(cancel==1) begin
	cancel_lock<=1;
	status<=S6;
	end
  end

  S2: begin
    on<=1;
    occupy<=1;
    get_good<=0;
    ret_coin<=0;
    ret_value<=coin_value;
    good1<=1;
    good2<=0;

    if(coin_value<10) begin
      status<=S2;
    end
    else if(amount_five==0) begin
      status<=S2;
    end
    else begin
      status<=S4;
    end
	
	if(rst==0) begin
	status<=S6;
	end
	
	if(buy_g1==1 && buy_lock==0) begin
	amount_twopfive<=amount_twopfive-1;
	buy_lock<=1;
	g1_bought<=1;
	status<=S5;
	end
	
	
	if(cancel==1) begin
	cancel_lock<=1;
	status<=S6;
	end
	
  end

  S3: begin
    on<=1;
    occupy<=1;
    get_good<=0;
    ret_coin<=0;
    ret_value<=coin_value;
    good1<=0;
    good2<=1;
	if(rst==0) begin
	status<=S6;
	end
	
	if(buy_g2==1 && buy_lock==0) begin
	amount_five<=amount_five-1;
	buy_lock<=1;
	g2_bought<=1;
	status<=S5;
	end
	
	if(cancel==1) begin
	cancel_lock<=1;
	status<=S6;
	end
  end

  S4: begin
    on<=1;
    occupy<=1;
    get_good<=0;
    ret_coin<=0;
    ret_value<=coin_value;
    good1<=1;
    good2<=1;
	
	if(rst==0) begin
	status<=S6;
	end
	
	if(buy_g1==1 && buy_lock==0) begin
	amount_twopfive<=amount_twopfive-1;
	buy_lock<=1;
	g1_bought<=1;
	status<=S5;
	end
	if(buy_g2==1 && buy_lock==0) begin
	amount_five<=amount_five-1;
	buy_lock<=1;
	g2_bought<=1;
	status<=S5;
	end
	if(cancel==1) begin
	cancel_lock<=1;
	status<=S6;
	end
	
  end
  
  S5: begin
  on<=1;
  occupy<=1;
  ret_coin<=0;
  ret_value<=coin_value;
  

  //good1<=0;
  //good2<=0;
  get_good<=1;
  
  if(buy_g1==0||buy_g2==0) begin
  buy_lock<=0;
  status<=S_wait;
  wait_type<=0;
  end
  end
  
  S6: begin
  on<=1;
  occupy<=1;
  get_good<=0;
  ret_coin<=1;
  ret_value<=coin_value;
  good1<=0;
  good2<=0;
  cancel_lock<=0;
  status<=S_wait;
  wait_type<=1;
  end
  
  S_wait: begin
  if(!wait_type) begin
  if(counter!=500000000 && status==S_wait && clk==1) begin
    on<=1;
    occupy<=1;
    ret_coin<=0;
    ret_value<=coin_value;
    
      if(coin_value<5) begin
          good1<=0; good2<=0;
        end
        else if(coin_value<10) begin
          if(amount_twopfive==0) begin
            good1<=0; good2<=0;
          end
          else begin
            good1<=1; good2<=0;
          end
        end
        else begin
          if(amount_twopfive==0&&amount_five==0) begin
            good1<=0; good2<=0;
          end
          else if(amount_twopfive!=0 && amount_five==0) begin
            good1<=1; good2<=0;
          end
          else if(amount_twopfive==0 && amount_five!=0) begin
            good1<=0; good2<=1;
          end
          else begin
            good1<=1; good2<=1;
          end
        end
    //good1<=0;
    //good2<=0;
    get_good<=1;
    g1_bought<=0;
      g2_bought<=0;
    counter<=counter+1;
    end
  else if(counter==500000000 && status==S_wait && clk==1) begin
    on<=1;
    occupy<=1;
    ret_coin<=0;
    ret_value<=coin_value;
    //good1<=0;
    //good2<=0;
    get_good<=0;
    g1_bought<=0;
      g2_bought<=0;
    counter<=0;
    status<=S1;
    end
    end
  
  else begin
  if(counter!=500000000 && status==S_wait && clk==1) begin
      on<=1;
      occupy<=1;
      get_good<=0;
      ret_coin<=1;
      ret_value<=coin_value;
      good1<=0;
      good2<=0;
      counter<=counter+1;
      end
  else if(counter==500000000 && status==S_wait & clk==1) begin
      on<=1;
      occupy<=0;
      get_good<=0;
      ret_coin<=0;
      ret_value<=0;
      good1<=0;
      good2<=0;
      counter<=0;
      status<=S0;
      end
  end
  end

  default: begin
  end
endcase

end






endmodule // VendingMac