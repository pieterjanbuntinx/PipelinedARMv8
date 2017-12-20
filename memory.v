module memory(clock, alu_result,write_data,read_data, MemWrite,MemRead,alu_result_out,switches, leds);

input MemWrite, MemRead,clock;
input [63:0] alu_result, write_data;
input [17:0] switches;

output [63:0] read_data, alu_result_out;
output [26:0] leds;
assign alu_result_out = alu_result;

data_memory data_memory(clock,alu_result,write_data,MemWrite,MemRead,read_data,switches,leds);

endmodule