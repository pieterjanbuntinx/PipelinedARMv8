module memory(clock, alu_result,write_data,read_data, MemWrite,MemRead,alu_result_out,switches, leds);

input MemWrite, MemRead,clock;
input [63:0] alu_result, write_data;
input [17:0] switches;

output [63:0] read_data, alu_result_out;
output [26:0] leds;

reg [26:0]leds;
reg [63:0] write_data_switches;
assign alu_result_out = alu_result;

always @(posedge clock) begin
	if(MemWrite && alu_result[31:15] == 0) write_data_switches <= write_data;
	if(MemWrite && alu_result[31:15] !== 0) write_data_switches <= switches;
	if(MemRead && alu_result[31:15] !== 0) leds <= read_data;
end

data_memory_aangemaakt data_memory_aangemaakt(alu_result,clock,write_data_switches,MemWrite,read_data);

endmodule 