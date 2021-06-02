`timescale 1ns/1ps

module counter(out,reset,clk,upOrDown);

output reg [3:0] out;
input reset,clk,upOrDown;

always @(posedge clk)
begin
	if(reset==1)
		out=0;
	else
	begin
		if(upOrDown==1)
			if(out==15)
				out=0;
			else
				out=out+1;
		else
			if(out==0)
				out=15;
			else
				out=out-1;
	end
end
endmodule

module testbench();

reg clk,reset,upOrDown;
wire [3:0] out;

counter uut(out,reset,clk,upOrDown);

initial begin

$dumpfile ("count1.vcd"); 
$dumpvars(0,testbench);

clk=0;
reset=1;
#10
reset=0;
upOrDown=1;
#100
upOrDown=0;
end

always #5 clk=~clk;

endmodule
