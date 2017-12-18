module instruction_memory(address, data_out);

parameter words = 256;    // default number of words
parameter logwords = 9;   // default max address bit (log2(words)+1)
parameter size = 32;      // default number of bits per instruction word
parameter addr_size = 64; // default address size
input  [addr_size-1:0] address;
output [size-1:0] data_out;
reg    [size-1:0] memory [0:words];
wire   [size-1:0] data_out;


assign data_out = memory[address[logwords:2]];

endmodule



