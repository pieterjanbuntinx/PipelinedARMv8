module PipelinedARMv8(clock, reset,uitgang);

input clock, reset;

output uitgang;
wire uitgang;
assign uitgang = clock;

wire Reg2Loc, Branch, Uncondbranch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, or_out, alu_zero, Branchlink, zero_mux_out, not_zero;
wire [1:0] ALUOp;
wire [31:0] instruction, instruction_IF_ID;
wire [63:0] mux_rechts_van_add_out, read_data_1, read_data_2, sign_extended, mux_links_van_alu_uit, alu_uit, 
			shift_left_2_uit, and_poort_zero_branch_out, or_poort_zero_branch_out, read_data, mux_rechts_data_memory_out, add_pc_met_shift_left_2_out, pc_in, write_data_mux;
wire [4:0] mux_links_van_registers, mux_branch_register_links_van_registers, mux_branch_link_LR_out;
wire [3:0] alucontrol_uit;

control control_path(.clock(clock),
				.instruction(instruction[31:21]),
				.Reg2Loc(Reg2Loc),
				.Branch(Branch),
				.MemRead(MemRead), 
				.MemtoReg(MemToReg), 
				.ALUOp(ALUOp), 
				.MemWrite(MemWrite),
				.ALUSrc(ALUSrc), 
				.RegWrite(RegWrite), 
				.Uncondbranch(Uncondbranch),
				.Branchlink(Branchlink),
				.Branchreg(Branchreg), .not_zero(not_zero));
					
//instruction fetch en IF_ID pipeline register
wire Branchreg, wren_IF_ID;
wire [31:0] instruction, instruction_IF_ID;
wire [63:0] PC_out, PC_out_IF_ID, PC_branch, PC_branch_link, PC_branch_link_IF_ID;
					
instruction_fetch instruction_fetch(.clock(clock), 
									.reset(reset), 
									.Branchreg(Branchreg), 
									.PC_branch_in(PC_branch),
									.instruction_out(instruction),
									.PC_out(PC_out)
									.PC_branch_link_out(PC_branch_link));
									
IF_ID IF_ID_pipeline_register(	.clock(clock), 
								.reset(reset),
								.wren(wren_IF_ID), 
								.PC_out_in(PC_out),
								.instruction_in(instruction), 
								.PC_branch_link_in(PC_branch_link),
								.instruction_out(instruction_IF_ID), 
								.PC_out_out(PC_out_IF_ID),
								.PC_branch_link_out(PC_branch_link_IF_ID));
									
//instruction decode en ID_EX pipeline register
wire RegWrite, Reg2Loc, Branchlink, wren_ID_EX;
wire [63:0] read_data1, read_data2, sign_extended, read_data1_ID_EX, 
			read_data2_ID_EX, PC_out_ID_EX, sign_extended_ID_EX;
			
instruction_decode instruction_decode(	.clock(clock),
										.reset(reset),
										.RegWrite(RegWrite),
										.Reg2Loc(Reg2Loc),
										.Branchlink(Branchlink),
										.instruction(instruction_IF_ID),
										.write_back(write_back), //afkomstig van MEM/WB
										.PC_branch_link_in(PC_branch_link_IF_ID),
										.read_data1(read_data1),
										.read_data2(read_data2),
										.sign_extend_out(sign_extended));
										
ID_EX ID_EX_pipeline_register(	.clock(clock),
								.reset(reset),
								.wren(wren_ID_EX), 
								.PC_out_in(PC_out_IF_ID), 
								.read_data1_in(read_data1), 
								.read_data2_in(read_data2),
								.read_data1_out(), read_data2_out 
								.sign_extended_in(sign_extended), 
								.PC_out_out(PC_out_ID_EX), 
								.sign_extended_out(sign_extended_ID_EX));

//Execution en EX/MEM pipeline register
								
										
									
									
	
						
					

					

n_mux mux_links_van_alu(.in1(read_data_2),.in2(sign_extended),.out(mux_links_van_alu_uit),.select(ALUSrc));

alu alu(.in1(read_data_1),.in2(mux_links_van_alu_uit),.out(alu_uit),.zero(alu_zero),.control(alucontrol_uit));

alu_control alu_control(.alu_op(ALUOp),.instruction(instruction[31:21]),.out(alucontrol_uit));

n_mux mux_not_zero(.in1(alu_zero), .in2(~alu_zero), .out(zero_mux_out), .select(not_zero));



n_mux mux_branch_reg_naar_pc(.in1(mux_rechts_van_add_out),.in2(read_data_1),.select(Branchreg), .out(pc_in));

data_memory data_memory(.address(alu_uit),.write_data(read_data_2),.read_data(read_data),.MemWrite(MemWrite),.MemRead(MemRead),.clock(clock));


n_mux mux_branch_link(.in1(mux_rechts_data_memory_out),.in2(add_pc_met_4_out),.out(write_data_mux),.select(Branchlink));

n_mux mux_branch_link_LR(.in1(instruction[4:0]), .in2(30), .out(mux_branch_link_LR_out), .select(Branchlink));

n_mux mux_rechts_van_data_memory(.in1(alu_uit),.in2(read_data),.out(mux_rechts_data_memory_out),.select(MemToReg));

shift_left_2 shift_left_2(.in(sign_extended),.out(shift_left_2_uit));

alu_add add_shift_left_2_met_pc(.in1(PC_out),.in2(shift_left_2_uit),.out(add_pc_met_shift_left_2_out));

n_mux mux_rechts_van_add_pc_met_shift_left_2(.in1(add_pc_met_4_out),.in2(add_pc_met_shift_left_2_out),.out(mux_rechts_van_add_out),.select(or_out));



wire test;
assign or_out = test | Uncondbranch;
assign test = Branch & zero_mux_out;

endmodule

