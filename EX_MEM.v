module EX_MEM(clock,reset,pc_in,pc_out,zero_in,zero_out,alu_result_in,alu_result_out,read_data_2_in,read_data_2_out);

input [63:0] pc_in,alu_result_in, read_data_2_in;
input clock, reset,zero_in;

output[63:0] pc_out,read_data_2_out,alu_result_out;
output zero_out;
reg [63:0] pc_out,read_data_2_out,alu_result_out;
reg zero_out;

always @(posedge clock)
	if(reset)begin
		pc_out <= 'b{64[0]};
		read_data_2_out <= 'b{64[0]};
		alu_result_out <= 'b{64[0]};
	end
	else begin
		pc_out <= pc_in;
		read_data_2_out <= read_data_2_in;
		alu_result_out <= alu_result_in;
	end
	
end
endmodule 