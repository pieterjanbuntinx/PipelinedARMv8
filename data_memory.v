
module data_memory(clock,address, write_data, MemWrite, MemRead, read_data);

	
	parameter words = 8192;    // default number of words
	parameter logwords = 14;   // default max address bit (log2(words)+1)

	input  clock, MemWrite, MemRead;
	input  [63:0] address, write_data;
	output [63:0] read_data;
	reg    [63:0] read_data;
	reg    [63:0] memory [0:words]; //Komt overeen met 13 bits
	
	
	
	always @(posedge clock) //begin
		if(MemWrite)
			memory[address[31:0]] <= write_data; 
				
	always @(address or write_data or MemWrite or MemRead)
		if(MemRead)
			read_data <= memory[address[31:0]];
		
endmodule 