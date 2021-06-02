//Cache size: 256kB
//Number of index bits = 16
//Number of tag bits = 14
//Byte offset bits = 2

module dm();

reg [0:46]cache[0:65535];						//Allocating a cache of 2^(16) rows with 47bits in each row (1bit for valid bit + 14 tag bits + 32bits for data)

reg[1000:0] line;
reg[31:0]address;							//For storing the requested memory location
integer index;
reg[7:0]cmd;
integer file;
integer r;
integer i;
integer miss;
integer hits;

initial begin

miss=0;
hits=0;

for(i=0; i<65536; i=i+1)
begin
	cache[i][0]=0;							//Setting all valid bits to 0, initially
end

file = $fopen("gcc.trace","r");						//Opening the trace file

while(!$feof(file))
begin
	line="";
	if($fgets(line,file))
	begin
		r = $sscanf(line, "%s 0x%h",cmd,address);
		index = address[17:2];
		if(cache[index][0]==0)					//Checking the valid bit
		begin
			cache[index][0]=1;				//Updating the valid bit to 1
			cache[index][1:14] = address[31:18];		//Updating the cache (updating the tag bits)
			miss = miss + 1;
		end
		else if(cache[index][0]==1)
		begin
			if(address[31:18]==cache[index][1:14])		//Now, the valid bit is 1, so checking for a Tag match, if yes then it's a hit or else it's a miss
			begin
				hits = hits + 1;
			end
			else
			begin
				cache[index][1:14] = address[31:18];	//Evicting that index location (updating the tag bits)
				miss = miss + 1;
			end
		end
		
	end
end

$fclose(file);
$display("Misses   : %0d",miss);					//Displaying the total misses
$display("Hits     : %0d",hits);					//Displaying the total hits
$display("Miss Rate: %0f",(miss*100.0)/(miss+hits));			//Displaying the Miss rate
$display("Hit Rate : %0f",(hits*100.0)/(miss+hits));			//Displaying the Hit Rate

end
endmodule
