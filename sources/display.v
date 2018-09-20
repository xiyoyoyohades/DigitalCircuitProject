`timescale 1ns / 1ps


module display(
clk,
rst,
occupy,
coin_value,
AN,
seg_out
    );
    
input rst;
input clk;
input occupy;
input [7:0] coin_value;
output reg [7:0] AN;
output reg [7:0] seg_out;

reg [2:0] scan;
reg [4:0] data;
reg [7:0] temp;

wire clk_n;
divider #(100000, 32) div(clk,0,clk_n);

always @(posedge clk_n) begin
	scan<=scan+1;
end

always @(scan or occupy or rst) begin
if(rst==0) begin
	AN<=8'b00000000;
end
else begin
if(occupy==1) begin
	case(scan)
	3'b001: AN<=8'b11111110;
	3'b010: AN<=8'b11111101;
	3'b011: AN<=8'b11111011;
	default: AN<=8'b11111111;
	endcase
end

else begin
case(scan)
	3'b001: AN<=8'b11110111;
	3'b010: AN<=8'b11101111;
	3'b011: AN<=8'b11011111;
	3'b100: AN<=8'b10111111;
	3'b101: AN<=8'b01111111;
	default: AN<=8'b11111111;
	endcase
	end
end
end

always @(AN) begin
if(rst==0) begin
	data<=31;
end
else begin
	if(occupy==0) begin
		case(AN)
		8'b11110111: data<=0;
		8'b11101111: data<=1;
		8'b11011111: data<=2;
		8'b10111111: data<=3;
		8'b01111111: data<=4;
		endcase
	end
	else begin
	if(coin_value<20) begin
		temp<=coin_value>>1;
		if((coin_value-(temp<<1))==1) begin
		case(AN)
		8'b11111110: data<=5'b10101;
		8'b11111101: data<=temp[4:0];
		8'b11111011: data<=5'b11111;
		endcase
		end
		else begin
		case(AN)
		8'b11111110: data<=5'b10000;
		8'b11111101: data<=temp[4:0];
		8'b11111011: data<=5'b11111;
		endcase
		end
		
	end
	else begin
		temp<=coin_value>>1;
		if((coin_value-(temp<<1))==1) begin
		case(AN)
		8'b11111110: data<=5'b10101;
		8'b11111101: data<=temp[4:0]-10;
		8'b11111011: data<=5'b10001;
		endcase
		end
		else begin
		case(AN)
		8'b11111110: data<=5'b10000;
		8'b11111101: data<=temp[4:0]-10;
		8'b11111011: data<=5'b10001;
		endcase
		end
	end




	end
end

end


always @(data) begin
if(occupy==1) begin
	case(data) 
	5'b00000: seg_out<=8'b01000000;  //0.
	5'b00001: seg_out<=8'b01111001;  //1.
	5'b00010: seg_out<=8'b00100100;  //2.
	5'b00011: seg_out<=8'b00110000;  //3.
	5'b00100: seg_out<=8'b00011001;  //4.
	5'b00101: seg_out<=8'b00010010;  //5.
	5'b00110: seg_out<=8'b00000010;  //6.
	5'b00111: seg_out<=8'b01111000;  //7.
	5'b01000: seg_out<=8'b00000000;  //8.
	5'b01001: seg_out<=8'b00010000;  //9.
	
	5'b10000: seg_out<=8'b11000000;  //0
	5'b10001: seg_out<=8'b11111001;  //1
	5'b10010: seg_out<=8'b10100100;  //2
	5'b10011: seg_out<=8'b10110000;  //3
	5'b10100: seg_out<=8'b10011001;  //4
	5'b10101: seg_out<=8'b10010010;  //5
	5'b10110: seg_out<=8'b10000010;  //6
	5'b10111: seg_out<=8'b11111000;  //7
	5'b11000: seg_out<=8'b10000000;  //8
	5'b11001: seg_out<=8'b10010000;  //9
	
	5'b11111: seg_out<=8'b11111111;
	endcase
	end

	else begin
	case(data) 
	5'b00000: seg_out<=8'b11000000;  //O
	5'b00001: seg_out<=8'b11000111;  //L
	5'b00010: seg_out<=8'b11000111;  //L
	5'b00011: seg_out<=8'b10000110;  //E
	5'b00100: seg_out<=8'b10001001;  //H
	default:  seg_out<=8'b11111111;
	endcase
	end
	



end
	
endmodule
