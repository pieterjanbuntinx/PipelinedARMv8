module MEM_WB(read_data_in, read_data_uit, clock, reset, alu_result_in, alu_result_uit);

input clock, reset;
input [63:0] read_data_in, alu_result_in;

output [63:0] read_data_uit, alu_result_uit;

always @(posedge clock)begin
	if(reset)begin
		read_data_uit <= {'b{64[0]}};
		alu_result_uit <= {'b{64[0]}};
	end
	else begin
		read_data_uit <= read_data_in;
		alu_result_uit <= alu_result_in;
	end 
end
endmodule 