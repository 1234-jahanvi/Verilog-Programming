`timescale 1ns/1ps
module mux2 (in0, in1, select, out);

input in0,in1,select;  
output out;
wire s0,w0,w1; 

not n1 (s0, select);
and a1 (w0, s0, in0);
and a2 (w1, select, in1);
or g3	(out, w0, w1); 

endmodule

module mux4(D0,D1,D2,D3,S0,S1,Y);
	input D0,D1,D2,D3,S0,S1;
	output Y;
	wire wire1,wire2;

	mux2 m1(D0,D1,S0,wire1);
	mux2 m2(D2,D3,S0,wire2);
	mux2 m3(wire1,wire2,S1,Y);
endmodule

module tb_mux4;

	reg d0;
	reg d1;
	reg d2;
	reg d3;
	reg s0;
	reg s1;
	wire OUT;

	mux4 uut(d0,d1,d2,d3,s0,s1,OUT);

	initial 
	begin

	$dumpfile ("mux4_out.vcd"); 
	$dumpvars(0, tb_mux4);

	d0=1;
	d1=0;
	d2=0;
	d3=0;
	s0=0;
	s1=0;
	#10
	
	s1=0; s0=0; d0=0; d1=0; d2=0; d3=0;	#10;
	s1=0; s0=1; d0=0; d1=0; d2=0; d3=0;	#10;
	s1=0; s0=1; d0=0; d1=1; d2=0; d3=0;	#10;
	s1=1; s0=0; d0=0; d1=0; d2=0; d3=0;	#10;
	s1=1; s0=0; d0=0; d1=0; d2=1; d3=0;	#10;
	s1=1; s0=1; d0=0; d1=0; d2=0; d3=0;	#10;
	s1=1; s0=1; d0=0; d1=0; d2=0; d3=1;	#10;
	

	end

endmodule
	
	
	
