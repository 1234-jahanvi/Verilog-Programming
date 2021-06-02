//Cache size: 256kB
//Number of index bits = 14
//Number of tag bits = 16
//Byte offset bits = 2

module setCache();

reg[0:195]cache[0:16383];		//Allocating a cache of 2^(14) rows with 196bits in each row (Each row has 4-ways with each way of 49bits (1bit for valid bit + 16 tag bits + 32bits for data))

reg[1000:0] line;
reg[31:0]address;			//For storing the requested memory location
reg[15:0]tag;
reg[7:0]cmd;
integer index;
integer file;
integer r;
integer i;
integer w;
integer j;
integer instr;			

reg [32:0]recAccess[0:16383][0:3];	//a reference 2Darray to store latest instruction number that accessed a particular way at a particular index of the cache. Used for the LRU algorithm to get the least recently used way at that index.

integer min;
integer miss;
integer hits;
integer flag;

initial begin

miss=0;
hits=0;
instr=0;

for(i=0; i<16384; i=i+1)		//Setting all valid bits to 0, initially
begin
	cache[i][0]=0;
	cache[i][49]=0;
	cache[i][98]=0;
	cache[i][147]=0;
end

file = $fopen("gcc.trace","r");		//Opening the trace file

while(!$feof(file))
begin
	line="";
	if($fgets(line,file))
	begin
		instr = instr + 1;
		r = $sscanf(line, "%s 0x%h ",cmd,address);
		index = address[15:2];
		w=0;
		flag=0;
		while(w<196 && flag===0)
		begin
			if(cache[index][w]==0)				//Checking the valid bit
			begin
				cache[index][w]=1;			//Updating the valid bit to 1
				j=w+1;
				i=31;
				while(j<=(w+16))
				begin
					cache[index][j] = address[i];	//Updating the cache (updating the tag bits)
					j=j+1;
					i=i-1;
				end
				miss = miss + 1;
				recAccess[index][w/49]=instr;		//Updating the reference 2D array with the instruction number
				flag=1;
			end
			else
			begin
				j=w+1;
				i=15;
				while(j<=(w+16))
				begin
					tag[i]=cache[index][j];
					j=j+1;
					i=i-1;
				end
				if(address[31:16]==tag[15:0])		//Now, the valid bit is 1 so checking for a Tag match if yes, then it's a hit or else, we still keep on checking the other ways
				begin
					recAccess[index][w/49]=instr;	//Updating the reference 2D array with the instruction number
					hits = hits + 1;
					flag=1;
				end

			end
			w=w+49;
		end
		if(flag==0)							//Now, all the ways at that index in the cache are full and we need to evict one of these four ways
		begin
			min=0;							//Least-Recently-Used Algorithm applied, to find the least recently accessed way at that index
			for(i=1; i<4; i=i+1)
			begin
				if(recAccess[index][i] < recAccess[index][min])
				begin
					min=i;
				end
			end
			recAccess[index][min]=instr;
			w = min*49;
			j=w+1;
			i=31;
			while(j<=(w+16))
			begin
				cache[index][j] = address[i];			//Evicting the least recently accessed way of that index location (updating the tag bits)
				j=j+1;
				i=i-1;
			end
			miss = miss + 1;
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


