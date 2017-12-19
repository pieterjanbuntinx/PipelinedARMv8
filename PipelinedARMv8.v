module PipelinedARMv8(clock, reset,uitgang);

input clock, reset;
output uitgang;


wire Branch, MemRead,MemtoReg,MemWrite,ALUSrc,Uncondbranch,not_zero;
wire [1:0] ALUOp;

//instruction fetch en IF_ID pipeline register
wire Branchreg;
wire [31:0] instruction, instruction_IF_ID;
wire [63:0] PC_out, PC_out_IF_ID, PC_branch, PC_branch_link, PC_branch_link_IF_ID,read_data_1_EX_MEM;
					
instruction_fetch instruction_fetch(.clock(clock), 
									.reset(reset), 
									.Branchreg(Branchreg_EX_MEM), 
									.alu_result(alu_result_EX_MEM),
									.read_data_1(read_data_1_EX_MEM),
									.instruction_out(instruction),
									.PC_out(PC_out),
									.PC_branch_link_out(PC_branch_link),
									.or_out(or_out));
									
IF_ID IF_ID_pipeline_register(	.clock(clock), 
								.reset(reset),
								.PC_out_in(PC_out),
								.instruction_in(instruction), 
								.PC_branch_link_in(PC_branch_link),
								.instruction_out(instruction_IF_ID), 
								.PC_out_out(PC_out_IF_ID),
								.PC_branch_link_out(PC_branch_link_IF_ID));
									
//instruction decode en ID_EX pipeline register
wire RegWrite, Reg2Loc, Branchlink;
wire [63:0] read_data1, read_data2, sign_extended, read_data1_ID_EX, 
			read_data2_ID_EX, PC_out_ID_EX, sign_extended_ID_EX,write_back;
wire [4:0] write_register_ID_EX;

n_mux n_mux_na_MEM_WB(.in1(read_data_data_memory_MEM_WB),.in2(alu_result_out_memory_MEM_WB),.out(write_back),.select(MemtoReg));
			
instruction_decode instruction_decode(	.clock(clock),
										.reset(reset),
										.instruction(instruction_IF_ID),
										.write_back(write_back), //afkomstig van MEM/WB
										.PC_branch_link_in(PC_branch_link_IF_ID),
										.read_data1(read_data1),
										.read_data2(read_data2),
										.sign_extend_out(sign_extended),
										.write_register(write_register_MEM_WB),
										.Branch(Branch), 
										.MemRead(MemRead), 
										.MemtoReg(MemtoReg), 
										.ALUOp(ALUOp), 
										.MemWrite(MemWrite), 
										.ALUSrc(ALUSrc), 
										.Uncondbranch(Uncondbranch), 
										.Branchreg(Branchreg), 
										.not_zero(not_zero));

wire Branch_ID_EX, MemRead_ID_EX,  MemWrite_ID_EX, ALUSrc_ID_EX,Uncondbranch_ID_EX, Branchreg_ID_EX, not_zero_ID_EX, MemtoReg_ID_EX;
wire [1:0] ALUOp_ID_EX;

ID_EX ID_EX_pipeline_register(	.clock(clock),
								.reset(reset), 
								.PC_out_in(PC_out_IF_ID), 
								.read_data1_in(read_data1), 
								.read_data2_in(read_data2),
								.read_data1_out(read_data1_ID_EX),
								.read_data2_out(read_data2_ID_EX),
								.sign_extended_in(sign_extended), 
								.PC_out_out(PC_out_ID_EX), 
								.Branch(Branch), 
								.MemRead(MemRead), 
								.MemtoReg(MemtoReg), 
								.ALUOp(ALUOp), 
								.MemWrite(MemWrite), 
								.ALUSrc(ALUSrc), 
								.Uncondbranch(Uncondbranch), 
								.Branchreg(Branchreg), 
								.not_zero(not_zero),
								.Branch_out(Branch_ID_EX), 
								.MemRead_out(MemRead_ID_EX), 
								.MemtoReg_out(MemtoReg_ID_EX), 
								.ALUOp_out(ALUOp_ID_EX), 
								.MemWrite_out(MemWrite_ID_EX), 
								.ALUSrc_out(ALUSrc_ID_EX), 
								.Uncondbranch_out(Uncondbranch_ID_EX), 
								.Branchreg_out(Branchreg_ID_EX), 
								.not_zero_out(not_zero_ID_EX),
								.sign_extended_out(sign_extended_ID_EX),
								.write_register_in(instruction[4:0]),
								.write_register_out(write_register_ID_EX));
								

//Execution en EX/MEM pipeline register
wire [63:0] add_pc_met_4_out, alu_result, write_data,read_data_data_memory_MEM_WB,alu_result_out_memory_MEM_WB,pc_out_ID_EX,add_pc,
				add_pc_EX_MEM,alu_result_EX_MEM,read_data_2_EX_MEM,read_data_data_memory,alu_result_out_memory;
wire [4:0] write_register_EX_MEM, write_register_MEM_WB;
wire zero,zero_EX_MEM;

execution execution(.pc_out(pc_out_ID_EX),
					.instruction(instruction),
					.sign_extend_out(sign_extended_ID_EX),
					.read_data_1(read_data1_ID_EX),
					.read_data_2(read_data2_ID_EX),
					.add_out(add_pc),
					.zero(zero),
					.alu_result(alu_result),
					.write_data(write_data),
					.ALUSrc(ALUSrc_ID_EX),			
					.ALUOp(ALUOp_ID_EX));
					
wire Branch_EX_MEM, MemRead_EX_MEM, MemtoReg_EX_MEM,MemWrite_EX_MEM, Uncondbranch_EX_MEM, Branchreg_EX_MEM,not_zero_EX_MEM;
EX_MEM EX_MEM(.clock(clock),
			  .reset(reset),
			  .pc_in(add_pc),
			  .pc_out(add_pc_EX_MEM),
			  .zero_in(zero),
			  .zero_out(zero_EX_MEM),
			  .alu_result_in(alu_result),
			  .alu_result_out(alu_result_EX_MEM),
			  .read_data_1_in(read_data1_ID_EX),
			  .read_data_1_out(read_data_1_EX_MEM),
			  .read_data_2_in(read_data2_ID_EX),
			  .read_data_2_out(read_data_2_EX_MEM),
			  .write_register_in(write_register_ID_EX),
			  .write_register_out(write_register_EX_MEM),
			  .Branch(Branch_ID_EX), 
			  .MemRead(MemRead_ID_EX), 
			  .MemtoReg(MemtoReg_ID_EX), 
			  .MemWrite(MemWrite_ID_EX), 
			  .Uncondbranch(Uncondbranch_ID_EX), 
			  .Branchreg(Branchreg_ID_EX), 
			  .not_zero(not_zero_ID_EX),
			  .Branch_out(Branch_EX_MEM), 
			  .MemRead_out(MemRead_EX_MEM), 
			  .MemtoReg_out(MemtoReg_EX_MEM), 
			  .MemWrite_out(MemWrite_EX_MEM), 
			  .Uncondbranch_out(Uncondbranch_EX_MEM), 
			  .Branchreg_out(Branchreg_EX_MEM), 
			  .not_zero_out(not_zero_EX_MEM));
			  
wire or_out,MemtoReg_MEM_WB;
			  
memory memory(.clock(clock),
			  .zero(zero_EX_MEM),
			  .alu_result(alu_result_EX_MEM),
			  .write_data(read_data_2_EX_MEM),
			  .read_data(read_data_data_memory),
			  .MemWrite(MemWrite),
			  .MemRead(MemRead),
			  .alu_result_out(alu_result_out_memory),
			  .MemWrite(MemWrite_EX_MEM),
			  .MemRead(MemRead_EX_MEM),
			  .not_zero(not_zero_EX_MEM),
			  .zero(zero_EX_MEM),
			  .Uncondbranch(Uncondbranch_EX_MEM),
			  .Branch(Branch_EX_MEM),
			  .or_out(or_out));
			  
MEM_WB MEM_WB(.read_data_in(read_data_data_memory),
			  .read_data_uit(read_data_data_memory_MEM_WB),
			  .clock(clock),
			  .reset(reset),
			  .alu_result_in(alu_result_out_memory),
			  .alu_result_uit(alu_result_out_memory_MEM_WB),
			  .write_register_in(write_register_EX_MEM),
			  .write_register_out(write_register_MEM_WB),
			  .MemtoReg(MemtoReg_EX_MEM),
			  .MemtoReg_out(MemtoReg_MEM_WB));
						
					

endmodule

