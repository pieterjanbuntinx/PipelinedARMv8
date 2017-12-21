module PipelinedARMv8(clock, reset,switches,leds);

input clock, reset;
input [17:0] switches;

output [26:0] leds;


wire Branch, MemRead,MemtoReg,MemWrite,ALUSrc,Uncondbranch,not_zero;
wire [1:0] ALUOp;

//instruction fetch en IF_ID pipeline register
wire Branchreg, IF_ID_Flush;
wire [31:0] instruction, instruction_IF_ID, instruction_ID_EX;
wire [63:0] PC_out, PC_out_IF_ID, PC_branch, PC_branch_link, PC_branch_link_IF_ID,read_data_1_EX_MEM;

wire RegWrite_ID, Reg2Loc, Branchlink, stall;
wire [63:0] read_data1, read_data2, sign_extended, read_data1_ID_EX, 
			read_data2_ID_EX, sign_extended_ID_EX,write_back, add_pc,alu_in2_EX_MEM;
wire [4:0] write_register_ID_EX, read_register1_ID, read_register2_ID;

wire Branch_ID_EX, MemRead_ID_EX,  MemWrite_ID_EX, ALUSrc_ID_EX,Uncondbranch_ID_EX, Branchreg_ID_EX, not_zero_ID_EX, MemtoReg_ID_EX, ID_EX_RegWrite;
wire [1:0] ALUOp_ID_EX;
wire [4:0] read_register1_ID_EX, read_register2_ID_EX;

wire [63:0] add_pc_met_4_out, alu_result,alu_in2_execution,read_data_data_memory_MEM_WB,alu_result_out_memory_MEM_WB,pc_out_ID_EX,
				add_pc_EX_MEM,alu_result_EX_MEM,read_data_2_EX_MEM,read_data_data_memory,alu_result_out_memory,PC_inc_fetch,PC_inc_IF_ID;
wire [4:0] write_register_EX_MEM, write_register_MEM_WB;
wire zero,zero_EX_MEM, EX_MEM_RegWrite;
wire [1:0] ForwardA, ForwardB;

wire Branch_EX_MEM, MemRead_EX_MEM, MemtoReg_EX_MEM,MemWrite_EX_MEM, Uncondbranch_EX_MEM, Branchreg_EX_MEM,not_zero_EX_MEM;

wire or_out, MemtoReg_MEM_WB, MEM_WB_RegWrite;
					
instruction_fetch instruction_fetch(.clock(clock), 
									.reset(reset), 
									.Branchreg(Branchreg), 
									.add_pc(add_pc),
									.read_data_1(read_data1),
									.instruction_out(instruction),
									.PC_out(PC_out),
									.PC_branch_link_out(PC_branch_link),
									.PCWrite(!stall),
									.PC_inc_out(PC_inc_fetch),
									.or_out(or_out));								
IF_ID IF_ID_pipeline_register(	.clock(clock), 
								.reset(reset),
								.PC_inc_in(PC_inc_fetch),
								.PC_inc_out(PC_inc_IF_ID),
								.PC_out_in(PC_out),
								.instruction_in(instruction), 
								.PC_branch_link_in(PC_branch_link),
								.instruction_out(instruction_IF_ID), 
								.PC_out_out(PC_out_IF_ID),
								.PC_branch_link_out(PC_branch_link_IF_ID),
								.IF_ID_Write(!stall),
								.IF_ID_Flush(IF_ID_Flush));
											
instruction_decode instruction_decode(	.clock(clock),
										.IF_ID_Flush(IF_IS_Flush),
										.reset(reset),
										.instruction(instruction_IF_ID),
										.write_back(write_back), //afkomstig van MEM/WB
										.PC_branch_link_in(PC_branch_link_IF_ID),
										.read_data1(read_data1),
										.read_data2(read_data2),
										.write_register(write_register_MEM_WB),
										.MemRead(MemRead), 
										.MemtoReg(MemtoReg), 
										.ALUOp(ALUOp), 
										.MemWrite(MemWrite), 
										.ALUSrc(ALUSrc), 
										.Branchreg(Branchreg), 
										.RegWrite_in(MEM_WB_RegWrite),
										.RegWrite_out(RegWrite_ID),
										.read_register1_out(read_register1_ID),
										.read_register2_out(read_register2_ID),
										.stall(stall),
										.PC_CB(add_pc),
										.PC_out_IF_ID(PC_out_IF_ID),
										.sign_extend_out(sign_extended),
										.or_out(or_out),
										.zero_in(zero_EX));
										
hazard_detection_unit hazard_detection_unit(.ID_EX_MemRead(MemRead_ID_EX), 
											.ID_EX_RegisterRd(write_register_ID_EX), 
											.IF_ID_RegisterRn1(read_register1_ID), 
											.IF_ID_RegisterRm2(read_register2_ID), 
											.stall(stall));										

ID_EX ID_EX_pipeline_register(	.clock(clock),
								.reset(reset), 
								.PC_out_in(PC_out_IF_ID), 
								.read_data1_in(read_data1), 
								.read_data2_in(read_data2),
								.read_data1_out(read_data1_ID_EX),
								.read_data2_out(read_data2_ID_EX),
								.sign_extended_in(sign_extended), 
								.PC_out_out(pc_out_ID_EX), 
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
								.write_register_in(instruction_IF_ID[4:0]),
								.write_register_out(write_register_ID_EX),
								.RegWrite_in(RegWrite_ID),
								.RegWrite_out(ID_EX_RegWrite),
								.read_register1_in(read_register1_ID),
								.read_register2_in(read_register2_ID),
								.read_register1_out(read_register1_ID_EX),
								.read_register2_out(read_register2_ID_EX),
								.instruction_in(instruction_IF_ID),
								.instruction_out(instruction_ID_EX));
						
//Execution en EX/MEM pipeline register
execution execution(.pc_out(pc_out_ID_EX),
					.instruction(instruction_ID_EX),
					.sign_extend_in(sign_extended_ID_EX),
					.read_data_1(read_data1_ID_EX),
					.read_data_2(read_data2_ID_EX),
					.EX_MEM_alu_result(alu_result_EX_MEM),
					.WB_write_back(write_back),
					.alu_result(alu_result),
					.alu_in2_out(alu_in2_execution),
					.ALUSrc(ALUSrc_ID_EX),			
					.ALUOp(ALUOp_ID_EX),
					.forwardA(ForwardA),
					.forwardB(ForwardB),
					.zero(zero_EX));
					
forwarding_unit forwarding_unit(.EX_MEM_RegWrite(EX_MEM_RegWrite), 
								.EX_MEM_RegisterRd(write_register_EX_MEM), 
								.ID_EX_RegisterRn1(read_register1_ID_EX),
								.ID_EX_RegisterRm2(read_register2_ID_EX),
								.MEM_WB_RegWrite(MEM_WB_RegWrite), 
								.MEM_WB_RegisterRd(write_register_MEM_WB), 
								.ForwardA(ForwardA), 
								.ForwardB(ForwardB));					
					
EX_MEM EX_MEM(.clock(clock),
			  .reset(reset),
			  .pc_in(add_pc),
			  .pc_out(add_pc_EX_MEM),
			  .zero_in(zero_EX),
			  .zero_out(zero_EX_MEM),
			  .alu_result_in(alu_result),
			  .alu_result_out(alu_result_EX_MEM),
			  .alu_in2_in(alu_in2_execution),
			  .alu_in2_out(alu_in2_EX_MEM),
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
			  .not_zero_out(not_zero_EX_MEM),
			  .RegWrite_in(ID_EX_RegWrite),
			  .RegWrite_out(EX_MEM_RegWrite));
			  
memory memory(.clock(clock),
			  .alu_result(alu_result_EX_MEM),
			  .write_data(alu_in2_EX_MEM),
			  .read_data(read_data_data_memory),
			  .alu_result_out(alu_result_out_memory),
			  .MemWrite(MemWrite_EX_MEM),
			  .MemRead(MemRead_EX_MEM),
			  .switches(switches),
			  .leds(leds));
			  			  
MEM_WB MEM_WB(.read_data_in(read_data_data_memory),
			  .read_data_uit(read_data_data_memory_MEM_WB),
			  .clock(clock),
			  .reset(reset),
			  .alu_result_in(alu_result_out_memory),
			  .alu_result_uit(alu_result_out_memory_MEM_WB),
			  .write_register_in(write_register_EX_MEM),
			  .write_register_out(write_register_MEM_WB),
			  .MemtoReg(MemtoReg_EX_MEM),
			  .MemtoReg_out(MemtoReg_MEM_WB),
			  .RegWrite_in(EX_MEM_RegWrite),
			  .RegWrite_out(MEM_WB_RegWrite));
						
				
//instruction decode en ID_EX pipeline register
n_mux n_mux_na_MEM_WB(.in1(alu_result_out_memory_MEM_WB),.in2(read_data_data_memory_MEM_WB),.out(write_back),.select(MemtoReg_MEM_WB));
	

endmodule

