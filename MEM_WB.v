module MEM_WB(write_register_in, write_register_out,read_data_in, read_data_uit, clock, reset, alu_result_in, alu_result_uit);

input clock, reset;
input [63:0] read_data_in, alu_result_in;
input [4:0] write_register_in;

output [63:0] read_data_uit, alu_result_uit;
output [4:0] write_register_out;
reg [4:0] write_register_out;
reg [63:0] read_data_uit, alu_result_uit;

always @(posedge clock)begin
	if(reset)begin
		read_data_uit <= 64'b0;
		alu_result_uit <= 64'b0;
		write_register_out <= 5'b0;
	end
	else begin
		read_data_uit <= read_data_in;
		alu_result_uit <= alu_result_in;
		write_register_out <= write_register_in;
	end 
end
endmodule 