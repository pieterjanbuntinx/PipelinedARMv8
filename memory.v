module memory(clock, zero,alu_result,write_data,read_data, MemWrite, Uncondbranch, Branch,MemRead,alu_result_out,not_zero,Uncondbranch,or_out);

input zero, MemWrite, MemRead,not_zero,Uncondbranch,Branch,clock;
input [63:0] alu_result, write_data;

output [63:0] read_data, alu_result_out;
output or_out;
wire alu_zero;
assign alu_result_out = alu_result;

data_memory data_memory(clock,alu_result,write_data,MemWrite,MemRead,read_data);

n_mux mux_zero_not_zero(.in1(zero),.in2(!zero),.out(alu_zero),.select(not_zero));

wire or_out, and_out;
assign or_out = and_out | Uncondbranch;
assign and_out = Branch & alu_zero;


endmodule