`timescale 1ns\1ps

module dff(q,d,clk);

	output q;
	input d,clk;
	reg q;

	always @(posedge clk)
	q=d;

endmodule

module testbench();

reg d;
reg clk;
wire q;
dff uut(q,d,clk);

initial begin

$dumpfile ("dff_out.vcd"); 
$dumpvars(0,testbench);

d=0;
clk=0;

end

always
#3 clk=~clk;

always
#5 d=1
#5 d=0

endmodule
