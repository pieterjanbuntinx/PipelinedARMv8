module instruction_decode(	write_register,clock, reset,Reg2Loc, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Uncondbranch,
						Branchlink, Branchreg, not_zero, instruction, write_back, PC_branch_link_in, read_data1, read_data2, sign_extend_out);
input clock, reset;
input [31:0] instruction;
input [4:0] write_register;
input [63:0] write_back, PC_branch_link_in;

output [63:0] sign_extend_out, read_data1, read_data2,Reg2Loc, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Uncondbranch, Branchlink, Branchreg, not_zero;

//mux met Rd (instr[4:0]) en Rm (instr[20:16]) geschakeld door Reg2Loc
reg [4:0] read_register_2;


n_mux mux2(.in1(instruction[20:16]),.in2(instruction[4:0]),.out(read_register_2),.select(Reg2Loc));

//mux met write_back van MEM/WB pipeline register en PC_branch_link_in
//geschakeld door Branchlink
reg [63:0] write_data;

n_mux mux1(.in1(write_back),.in2(PC_branch_link_in),.out(write_data),.select(Branchlink));

control control(.clock(clock), 
				.instruction(instruction[31:21]), 
				.Reg2Loc(Reg2Loc), 
				.Branch(Branch), 
				.MemRead(MemRead), 
				.MemtoReg(MemtoReg), 
				.ALUOp(ALUOp), 
				.MemWrite(MemWrite), 
				.ALUSrc(ALUSrc), 
				.RegWrite(RegWrite), 
				.Uncondbranch(Uncondbranch), 
				.Branchlink(Branchlink), 
				.Branchreg(Branchreg), 
				.not_zero(not_zero));
registers registers(.Read_register_1(instruction[9:5]), 
					.Read_register_2(read_register_2), 
					.Write_register(write_register), 
					.Write_data(write_data), 
					.RegWrite(RegWrite), 
					.Read_data_1(read_data1), 
					.Read_data_2(read_data2), 
					.clock(clock), 
					.reset(reset));

//bepaalde delen van de instructies sign extenden naar 64 bits
sign_extend sign_extend(.in(instruction),.out(sign_extend_out));

endmodule