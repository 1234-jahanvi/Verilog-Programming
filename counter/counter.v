`timescale 1ns\1ps

module counter(out,reset,enable,clk);

output reg [3:0] out;
input reset,enable,clk;

always @(posedge clk)
if(reset) begin
out=4'b0;
end
else if(enable) begin
out=out+1;
end

endmodule

module testbench();

reg clk,reset,enable;
wire [3:0] out;

counter uut(out,reset,enable,clk);

initial begin

$dumpfile ("count.vcd"); 
$dumpvars(0,testbench);

clk=0;
reset=1;
enable=0;

#20
reset=0;
enable=1;

end

always 
#5 clk=~clk;

endmodule
