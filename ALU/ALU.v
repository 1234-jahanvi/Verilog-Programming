//This the corrected code which stimulates correctly.

module alu (a,b,s,out,clk);
input [39:0]a,b;
input [4:0]s;
input clk;
output reg [39:0]out;

always @ (posedge clk)
begin
if (s==5'b00101)
out = a+b;
else if (s==5'b1000)
out= a*b;
else if (s==5'b00110)
out = a-b;
else if (s==5'b01011)
out = a/b;
end
endmodule


`timescale 1ns/1ps
module alu_test;
reg [39:0]a,b;
reg clk;
reg [4:0]select;
wire [39:0]out;
alu uut (a,b,select,out,clk);

initial
begin
$dumpfile("alua.vcd");
$dumpvars(0, alu_test);
a= 40'h000000000b;
b= 40'h0000000003;
clk=0;
select= 5'b00101;
end

always
begin
#3 clk=~clk;
end

always
begin

select= 5'b00111;
#10 select= 5'b00110;
#10 select= 5'b01000;
#10 select= 5'b01011;

end

endmodule

