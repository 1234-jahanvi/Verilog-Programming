//Assume the full adder shown below.
//Write a test bench to test it
`timescale 1ns/1ps
module Full_Adder(D1,D2,Cin,Sum_out,Cout); 
	input D1, D2, Cin;
	output Sum_out, Cout;
	wire a1, a2, a3;    

	xor u1(a1,D1,D2);
	and u2(a2,D1,D2);
	and u3(a3,a1,Cin);
	or u4(Cout,a2,a3);
	xor u5(Sum_out,a1,Cin); 

endmodule  

module tb_fulladder;

	reg IN0;
	reg IN1;
	reg CIN;
	wire SUM;
	wire COUT;

	Full_Adder uut(IN0,IN1,CIN,SUM,COUT);

	initial
	begin
	
	$dumpfile ("fulladder_out.vcd"); 
	$dumpvars(0, tb_fulladder);

	IN0=0;
	IN1=0;
	CIN=0;
	#10
	
	IN0= 0;      IN1= 0;      CIN= 1;      #10;
	IN0= 0;      IN1= 1;      CIN= 0;      #10;
	IN0= 0;      IN1= 1;      CIN= 1;      #10;
	IN0= 1;      IN1= 0;      CIN= 0;      #10;
	IN0= 1;      IN1= 0;      CIN= 1;      #10;
	IN0= 1;      IN1= 1;      CIN= 0;      #10;
	IN0= 1;      IN1= 1;      CIN= 1;      #10;
        end

endmodule
