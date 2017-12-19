module ID_EX(	write_register_in,write_register_out,clock, reset, wren, PC_out_in, read_data1_in, read_data2_in, 
				sign_extended_in, PC_out_out, sign_extended_out,read_data2_out, read_data1_out,Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Uncondbranch,
						Branchreg, not_zero,Branch_out, MemRead_out, MemtoReg_out, ALUOp_out, MemWrite_out, ALUSrc_out, RegWrite_out, Uncondbranch_out,
						Branchreg_out, not_zero_out);
input clock, reset, wren,Branch,MemRead,MemtoReg,ALUOp,MemWrite,ALUSrc,RegWrite,Uncondbranch,Branchreg,not_zero;
input [63:0] PC_out_in, read_data1_in, read_data2_in, sign_extended_in;
input [4:0] write_register_in;


output [4:0] write_register_out;
output [63:0] PC_out_out, read_data1_out, read_data2_out, sign_extended_out;
output Branch_out, MemRead_out, MemtoReg_out,ALUOp_out,MemWrite_out,ALUSrc_out,RegWrite_out,Uncondbranch_out,Branchreg_out,not_zero_out;
reg [63:0] PC_out_out, read_data1_out, read_data2_out, sign_extended_out;
reg [4:0] write_register_out;
reg Branch_out, MemRead_out, MemtoReg_out,ALUOp_out,MemWrite_out,ALUSrc_out,RegWrite_out,Uncondbranch_out,Branchreg_out,not_zero_out;

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
		RegWrite_out <= 0;
		Uncondbranch_out <= 0;
		Branchreg_out <= 0;
		not_zero_out <= 0;
	end else begin
		if (wren) begin
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
			RegWrite_out <= RegWrite;
			Uncondbranch_out <= Uncondbranch;
			Branchreg_out <= Branchreg;
			not_zero_out <= not_zero;
		end
	end
end

endmodule