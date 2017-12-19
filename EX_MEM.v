module EX_MEM(write_register_in, write_register_out,clock,reset,pc_in,pc_out,zero_in,zero_out,alu_result_in,alu_result_out,read_data_2_in,read_data_2_out,
				Branch, MemRead, MemtoReg,MemWrite, Uncondbranch, Branchreg,not_zero,Branch_out, MemRead_out, 
				MemtoReg_out,MemWrite_out,Uncondbranch_out,Branchreg_out,not_zero_out,read_data_1_in,read_data_1_out, RegWrite_in, RegWrite_out);

input [63:0] pc_in,alu_result_in, read_data_2_in,read_data_1_in;
input clock, reset,zero_in,Branch,MemRead,MemtoReg,MemWrite,Uncondbranch,Branchreg,not_zero, RegWrite_in;
input [4:0] write_register_in;

output[63:0] pc_out,read_data_2_out,alu_result_out,read_data_1_out;
output zero_out,Branch_out, MemRead_out, MemtoReg_out,MemWrite_out,Uncondbranch_out,Branchreg_out,not_zero_out, RegWrite_out;
output [4:0] write_register_out;
reg [63:0] pc_out,read_data_2_out,alu_result_out,read_data_1_out;
reg [4:0] write_register_out;

reg zero_out,Branch_out, MemRead_out, MemtoReg_out,MemWrite_out,Uncondbranch_out,Branchreg_out,not_zero_out, RegWrite_out;

always @(posedge clock)begin
	if(reset)begin
		pc_out <= 64'b0;
		read_data_2_out <=  64'b0;
		alu_result_out <= 64'b0;
		write_register_out <= 5'b0;
		zero_out <= 0;
		Branch_out <= 0;
		MemRead_out <= 0;
		MemtoReg_out <= 0;
		MemWrite_out <=0;
		Uncondbranch_out <= 0;
		Branchreg_out <= 0;
		not_zero_out <= 0;
		read_data_1_out <= 64'b0;
		RegWrite_out <= 0;
	end
	else begin
		pc_out <= pc_in;
		read_data_2_out <= read_data_2_in;
		alu_result_out <= alu_result_in;
		write_register_out <= write_register_in;
		zero_out <= zero_in;
		Branch_out <= Branch;
		MemRead_out <= MemRead;
		MemtoReg_out <= MemtoReg;
		MemWrite_out <= MemWrite;
		Uncondbranch_out <= Uncondbranch;
		Branchreg_out <= Branchreg;
		not_zero_out <= not_zero;
		read_data_1_out <= read_data_1_in;
		RegWrite_out <= RegWrite_in;
	end
	
end
endmodule 
