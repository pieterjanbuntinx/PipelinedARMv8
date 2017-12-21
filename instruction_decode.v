module instruction_decode(	write_register, clock, reset,Reg2Loc, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc,
						Branchreg, instruction, write_back, PC_branch_link_in, read_data1, read_data2, PC_CB, or_out,
						RegWrite_in, IF_ID_Flush,RegWrite_out, read_register1_out, read_register2_out, stall, PC_out_IF_ID, sign_extend_out,
						Uncondbranch, zero_in);
input clock, reset, RegWrite_in, stall, zero_in;
input [31:0] instruction;
output IF_ID_Flush;
input [4:0] write_register;
input [63:0] write_back, PC_branch_link_in, PC_out_IF_ID;

output [63:0] 	read_data1, read_data2, sign_extend_out, PC_CB;
output RegWrite_out, Reg2Loc, MemRead, MemtoReg, MemWrite, ALUSrc, 
				Uncondbranch, Branchreg,or_out;
output [1:0] ALUOp;
output [4:0] read_register1_out, read_register2_out;

wire [63:0] write_data, write_register_in;


wire [4:0] read_register_2;

wire Reg2Loc_in, Branch_in, MemRead_in, MemtoReg_in, MemWrite_in, ALUSrc_in, Uncondbranch_in,
		Branchreg_in,Branchlink,Branch, RegWrite;	
		
wire not_zero, CB_instr,or_out;

wire [63:0] sign_extend_out, shift_left_2_out, PC_CB, PC_mux, PC_mux_link;

wire alu_zero;

assign IF_ID_Flush = CB_instr & or_out;

wire  and_out;

reg zero;

//mux met Rd (instr[4:0]) en Rm (instr[20:16]) geschakeld door Reg2Loc
n_mux #(5) mux2(.in1(instruction[20:16]),.in2(instruction[4:0]),.out(read_register_2),.select(Reg2Loc));

//mux met write_back van MEM/WB pipeline register en PC_branch_link_in
//geschakeld door Branchlink
n_mux mux1(.in1(write_back),.in2(PC_branch_link_in),.out(write_data),.select(Branchlink));

assign read_register1_out = instruction[9:5];
assign read_register2_out = read_register_2;

wire Regwrite_reg;


//mux's voor stall			
n_mux #(1) n_mux_Reg2Loc(.in1(Reg2Loc_in), .in2(1'b0), .out(Reg2Loc), .select(stall));
n_mux #(1) n_mux_Branch(.in1(Branch_in), .in2(1'b0), .out(Branch), .select(stall));
n_mux #(1) n_mux_MemRead(.in1(MemRead_in), .in2(1'b0), .out(MemRead), .select(stall));
n_mux #(1) n_mux_MemtoReg(.in1(MemtoReg_in), .in2(1'b0), .out(MemtoReg), .select(stall));
n_mux #(1) n_mux_MemWrite(.in1(MemWrite_in), .in2(1'b0), .out(MemWrite), .select(stall));
n_mux #(1) n_mux_ALUSrc(.in1(ALUSrc_in), .in2(1'b0), .out(ALUSrc), .select(stall));
n_mux #(1) n_mux_RegWrite(.in1(RegWrite), .in2(1'b0), .out(RegWrite_out), .select(stall));
n_mux #(1) n_mux_Uncondbranch(.in1(Uncondbranch_in), .in2(1'b0), .out(Uncondbranch), .select(stall));
//n_mux #(1) n_mux_Branchlink(.in1(Branchlink_in), .in2(1'b0), .out(Branchlink), .select(stall));
n_mux #(1) n_mux_Branchreg(.in1(Branchreg_in), .in2(1'b0), .out(Branchreg), .select(stall));
n_mux #(1) n_mux_RegWrite_BranchLink(.in1(RegWrite_in), .in2(RegWrite), .out(Regwrite_reg), .select(Branchlink));

control control(.clock(clock), 
				.instruction(instruction[31:21]), 
				.Reg2Loc(Reg2Loc_in), 
				.Branch(Branch_in), 
				.MemRead(MemRead_in), 
				.MemtoReg(MemtoReg_in), 
				.ALUOp(ALUOp), 
				.MemWrite(MemWrite_in), 
				.ALUSrc(ALUSrc_in), 
				.RegWrite(RegWrite), 
				.Uncondbranch(Uncondbranch_in), 
				.Branchlink(Branchlink), 
				.Branchreg(Branchreg_in), 
				.not_zero(not_zero),
				.CB_instr(CB_instr));
registers registers(.Read_register_1(instruction[9:5]), 
					.Read_register_2(read_register_2), 
					.Write_register(write_register_in),
					.Write_data(write_data), 
					.RegWrite(Regwrite_reg), 
					.Read_data_1(read_data1), 
					.Read_data_2(read_data2), 
					.clock(clock), 
					.reset(reset));
		
n_mux n_mux_BL_write_register(.in1(write_register), .in2(30), .out(write_register_in), .select(Branchlink));

//bepaalde delen van de instructies sign extenden naar 64 bits
sign_extend sign_extend(.in(instruction),.out(sign_extend_out));
shift_left_2 shift_left_2(sign_extend_out,shift_left_2_out);

//sign extended waarde offset optellen bij PC_out
alu_add add_pc_m(PC_out_IF_ID,shift_left_2_out,PC_CB);
								
n_mux #(1) mux_zero_not_zero(.in1(zero_in),.in2(!zero_in),.out(alu_zero),.select(not_zero));

assign or_out = and_out | Uncondbranch;
assign and_out = Branch & alu_zero;
//selecteren tussen PC_inc en PC_CB

endmodule