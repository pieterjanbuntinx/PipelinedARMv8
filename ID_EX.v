module ID_EX(	write_register_in,write_register_out,clock, reset, PC_out_in, read_data1_in, read_data2_in, 
				sign_extended_in, PC_out_out, sign_extended_out,read_data2_out, read_data1_out,Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, Uncondbranch,
						Branchreg, not_zero,instruction_in,instruction_out,Branch_out, MemRead_out, MemtoReg_out, ALUOp_out, MemWrite_out, ALUSrc_out, Uncondbranch_out,
						Branchreg_out, not_zero_out, RegWrite_in, RegWrite_out, read_register1_in, read_register2_in, read_register1_out, read_register2_out);

input clock, reset, Branch,MemRead,MemtoReg,MemWrite,ALUSrc,Uncondbranch,Branchreg,not_zero;
input [1:0] ALUOp;
input [31:0] instruction_in;
input [63:0] PC_out_in, read_data1_in, read_data2_in, sign_extended_in;
input [4:0] write_register_in, read_register1_in, read_register2_in;
input RegWrite_in;

output [4:0] write_register_out, read_register1_out, read_register2_out;
output [31:0] instruction_out;
output [63:0] PC_out_out, read_data1_out, read_data2_out, sign_extended_out;
output Branch_out, MemRead_out, MemtoReg_out,MemWrite_out,ALUSrc_out,Uncondbranch_out,Branchreg_out,
		not_zero_out,RegWrite_out;
output [1:0] ALUOp_out ;
reg [1:0] ALUOp_out;
reg [31:0] instruction_out;
reg [63:0] PC_out_out, read_data1_out, read_data2_out, sign_extended_out;
reg [4:0] write_register_out, read_register1_out, read_register2_out;
reg Branch_out, MemRead_out, MemtoReg_out,MemWrite_out,ALUSrc_out,Uncondbranch_out,Branchreg_out,not_zero_out,RegWrite_out;

always @(posedge clock) begin
	if (reset) begin
		PC_out_out <= 64'b0;
		sign_extended_out <= 64'b0;
		read_data1_out <= 64'b0;
		read_data2_out <= 64'b0;
		write_register_out <= 5'b0;
		Branch_out <= 0;
		MemRead_out <= 0;
		MemtoReg_out <= 0;
		ALUOp_out <= 0;
		MemWrite_out <= 0;
		ALUSrc_out <= 0;
		Uncondbranch_out <= 0;
		Branchreg_out <= 0;
		not_zero_out <= 0;
		RegWrite_out <= 0;
		read_register1_out <= 0;
		read_register2_out <= 0;
		instruction_out <= 0;
	end else begin
		PC_out_out <= PC_out_in;
		sign_extended_out <= sign_extended_in;
		read_data1_out <= read_data1_in;
		read_data2_out <= read_data2_in;
		write_register_out <= write_register_in;
		Branch_out <= Branch;
		MemRead_out <= MemRead;
		MemtoReg_out <= MemtoReg;
		ALUOp_out <= ALUOp;
		MemWrite_out <= MemWrite;
		ALUSrc_out <= ALUSrc;
		Uncondbranch_out <= Uncondbranch;
		Branchreg_out <= Branchreg;
		not_zero_out <= not_zero;
		RegWrite_out <= RegWrite_in;
		read_register1_out <= read_register1_in;
		read_register2_out <= read_register2_in;
 		instruction_out <= instruction_in;
	end
end

endmodule