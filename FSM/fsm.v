`timescale 1ns/1ps

module fsm(reset,out,inp,clk);
input inp,clk,reset;
output reg out;

reg [1:0] curr_state;
reg[1:0] next_state;

//States
parameter A =2'b00;
parameter B =2'b01;
parameter C =2'b10;

//Sequential Logic
always @(posedge clk or posedge reset)
begin
	if(reset==1)
		begin
		out=0;
		curr_state<=A;
		end
	else
		begin
		curr_state<=next_state;
		end
end

//Next State Logic and the Output Logic
//Mealy FSM-output depends on both inputs and current state
always @(curr_state or inp)
begin 
		if(clk==1) begin	
		case(curr_state)
		A:begin
			out<=0;
			if(inp==0) next_state <= B;
			else next_state <= C;
		end
		B:begin
			if(inp==0) begin 
			next_state <= B;
			out<=0;
			end
			else begin
			next_state <= C;
			out<=1;
			end
		end
		C:begin
			if(inp==0) begin
			next_state <= B;
			out<=1;
			end
			else begin
			next_state <= C;
			out<=0;
			end
		end
		default: begin 
			next_state <= A;
			out<=0;
			end
		endcase
		end
end
endmodule

//Testbench
module test_bench;

reg reset,clk,inp;
reg [15:0] inputs;
integer i;
wire out;
fsm uut(reset,out,inp,clk);


initial begin

$dumpfile ("fsm.vcd"); 
$dumpvars(0,test_bench);
clk=1;
end

always
#5 clk=~clk;

//Writing inputs so as to cover all the states and combinations
initial begin

reset=0;

//Covers all the states starting from A to B and then moves forward covering all possible states
inputs=8'b10111000;
inp=0;
for(i=0; i<=7 ;i=i+1)
begin
inp=inputs[i];
#10;
end

#20
reset=1;	//Setting reset=1 so we move back to state A by resetting to now consider all combinations starting from A to C
//Covers all the states starting from A to C and then moves forward covering all possible states
inputs=8'b11000111;
#10 reset=0;
for(i=0; i<=7 ;i=i+1)
begin
inp=inputs[i];
#10;
end

end 
endmodule




















