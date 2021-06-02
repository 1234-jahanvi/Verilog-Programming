`timescale 1ns/1ps

module dff(q,d,reset,clk);

	output q;
	input d,reset,clk;
	reg q;

	always @(posedge clk or posedge reset)
	begin
	if(reset==1)
		q=0;
	else
		q=d;
	end
endmodule

module testbench();

reg d;
reg clk;
reg reset;
wire q;
dff uut(q,d,reset,clk);

initial begin

$dumpfile ("async_dff_out.vcd"); 
$dumpvars(0,testbench);
clk=0;
end

always
#10 clk=~clk;

initial begin
reset=1;
d=1;
#100;
reset=0;
d=1;
#100
d=0;
#100
d=1;
reset=1;
end
endmodule
