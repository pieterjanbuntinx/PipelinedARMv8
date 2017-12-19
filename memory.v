module memory(clock, alu_result,write_data,read_data, MemWrite,Branch,MemRead,alu_result_out);

input MemWrite, MemRead, Uncondbranch,Branch,clock;
input [63:0] alu_result, write_data;

output [63:0] read_data, alu_result_out;
assign alu_result_out = alu_result;

data_memory data_memory(clock,alu_result,write_data,MemWrite,MemRead,read_data);

endmodule