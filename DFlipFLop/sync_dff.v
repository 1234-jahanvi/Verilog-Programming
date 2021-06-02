`timescale 1ns/1ps

module dff(q,d,reset,clk);

	output q;
	input d,reset,clk;
	reg q;

	always @(posedge clk)
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

$dumpfile ("sync_dff_out.vcd"); 
$dumpvars(0,testbench);

d=0;
clk=0;
reset=0;

end

always
#100 clk=~clk;

initial begin
#200 d=1;
reset=1;
#200 d=0;
reset=1;

#300
d=1;
reset=0;
#600 d=0;
#500 d=1;
#200 d=0;

end
endmodule
