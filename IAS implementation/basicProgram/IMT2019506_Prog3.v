//If LHS or RHS instruction has 20'bx it means that there is no instruction to be fetched there
//Intially, PC is set to location 0
//The program implemented is mentioned in the pdf

module ias();

reg [0:39]mainMemory[0:999];	//1000 words of 40 bit each has been alloted for the MainMemory
reg [0:39]MBR;			//40 bit wide MBR
reg [0:19]IBR;			//20 bit wide IBR
reg [0:7]IR;			//8 bit wide IR
reg [0:11]MAR;			//12 bit wide MAR
reg [0:39]AC;			//40 bit wide Accumulator
reg [0:39]MQ;			//40 bit wide MQ
reg [0:11]PC;			//12 bit wide Program Counter

reg[0:7] opHALT;
reg[0:79] tempReg;		//A temporary register used for MUL M(X) instruction

integer location;
integer flag=1;			//when flag=0 means that all instructions have been executed and we need to HALT
integer nextRHS=0;		//tells if there is RHS instruction or not which needs to be executed next
integer jumpToRHS=0;		//Used to JUMP and take the instruction from right half of M(X), in the JUMP+M(X,20:39) instruction

initial begin

opHALT=8'b11111111;  		//opcode of HALT()

mainMemory[0]=40'b0000000100000000100000000110000000001001;
mainMemory[1]=40'b0001000000000000001000000101000000001001;
mainMemory[2]=40'b0000010100000000100100100001000000001010;
mainMemory[3]=40'bxxxxxxxxxxxxxxxxxxxx11111111000000000000;

mainMemory[8]=40'b1111;
mainMemory[9]=40'b10000;


PC=12'b0000000000;		//Initial PC is set

//FETCH phase starts
while(flag==1)
begin
 
if(nextRHS==1)
	begin
	IR=IBR[0:7];
	MAR=IBR[8:19];
	PC=PC-12'b1;
	nextRHS=0;
	end
else
begin
	MAR=PC;
	location=MAR;
	MBR=mainMemory[location];

	if(MBR[0:19]!==20'bx && jumpToRHS==0)
	begin
		if(MBR[20:39]!==20'bx) begin nextRHS=1; end
		else begin nextRHS=0; end

		IBR=MBR[20:39];
		IR=MBR[0:7];
		MAR=MBR[8:19];
	end
	else begin
		IR=MBR[20:27];
		MAR=MBR[28:39];
		jumpToRHS=0;
		end
end

//DECODING and EXECUTING phase
PC=PC+12'b1;
case(IR)
8'b00000001:begin			//LOAD M(X)
            location=MAR;
	    MBR=mainMemory[location];
	    AC=MBR;
	    end

8'b00000010:begin			//LOAD -M(X)
            location=MAR;
	    MBR=mainMemory[location];
	    AC=-MBR;
	    end

8'b00001010:begin			//LOAD MQ
            AC=MQ;
	    end

8'b00100001:begin			//STOR M(X)
	    location=MAR;
	    MBR=AC;
	    mainMemory[location]=MBR;
	    end


8'b00010000:begin			//JUMP + M(X,20:39)
	    if(AC[0]==0) begin		//Checking the sign bit
	    	PC=MAR;
		nextRHS=0;
		jumpToRHS=1;
	    	end
	    end

8'b00001111:begin			//JUMP + M(X,0:19)
	    if(AC[0]==0) begin		//Checking the sign bit
	    	PC=MAR;
		nextRHS=0;
	    	end
	    end

8'b00001101:begin			//JUMP M(X,0:19)
	    PC=MAR;
	    nextRHS=0;
	    end


8'b00000101:begin			//ADD M(X)
	    location=MAR;
	    MBR=mainMemory[location];
	    AC=AC+MBR;
	    end

8'b00000110:begin			//SUB M(X)
            location=MAR;
	    MBR=mainMemory[location];
	    AC=AC-MBR;
	    end

8'b00001011:begin			//MUL M(X)
	    location=MAR;
	    MBR=mainMemory[location];
	    tempReg=MQ*MBR;		//Multiplying M(X) with MQ
	    AC=tempReg[0:39];		//the MSB bits of result are put into the Accumulator AC
	    MQ=tempReg[40:79];		//the LSB bits of result are put into the MQ
	    end

8'b00001100:begin			//DIV M(X)
	    location=MAR;
	    MBR=mainMemory[location];
	    MQ=AC/MBR;			//Quotient of dividing AC by M(X) is stored in MQ
	    AC=AC%MBR;			//Remainder is stored in AC
	    end

8'b11111111:begin			//HALT()
	    flag=0;
	    end
default: begin
	 end
endcase
end
$display("The result is: %0d",mainMemory[10]);
$display("End");
end
endmodule
