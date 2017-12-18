module memory(clock, zero,alu_result,write_data,read_data, MemWrite, MemRead,alu_result_out)

input zero, MemWrite, MemRead;
input [63:0] alu_result, write_data;

output [63:0] read_data, alu_result_out;

assign alu_result_out = alu_result;

data_memory data_memory(clock,alu_result,write_data,MemWrite,MemRead,read_data);

endmodule;