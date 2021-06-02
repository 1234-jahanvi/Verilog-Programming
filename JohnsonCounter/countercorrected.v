//This is a Johnson counter
//0, 1, 3, 7, F, E, C, 8, 0, repeat

//This the corrected code which stimulates correctly.

module dff(q,d,clk,reset);
output q;
input d,clk,reset;
reg q;

always@(posedge clk or reset)
begin
	if (reset==1) q<=0;
	else q<=d;
end
endmodule


module counter(q,reset,clk);
output [3:0]q;		
input clk,reset;
wire w;				 

not n1 (w,q[3]);		
dff f1(q[0],w,clk,reset);	
dff f2(q[1],q[0],clk,reset);	
dff f3(q[2],q[1],clk,reset);	
dff f4(q[3],q[2],clk,reset);
endmodule

`timescale 10ns/1ps
module tb_johnson;
    reg clock;
    reg r;
    wire [3:0]Count_out;	

counter uut (Count_out,r,clock);

initial begin

$dumpfile ("counter.vcd"); 
$dumpvars(0,tb_johnson);

clock = 0;
r=1;
#50 r=0;  
end

always 
#3 clock=~clock;


//initial #300 $finish;

endmodule


