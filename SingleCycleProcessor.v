module SingleCycleProcessor(clock, reset,uitgang);

input clock, reset;

output uitgang;
wire uitgang;
assign uitgang = clock;

wire Reg2Loc, Branch, Uncondbranch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite, or_out, alu_zero, Branchlink,Branchreg, zero_mux_out, not_zero;
wire [1:0] ALUOp;
wire [31:0] instruction;
wire [63:0] mux_rechts_van_add_out, pc_out, add_pc_met_4_out, read_data_1, read_data_2, sign_extended, mux_links_van_alu_uit, alu_uit, 
			shift_left_2_uit, and_poort_zero_branch_out, or_poort_zero_branch_out, read_data, mux_rechts_data_memory_out, add_pc_met_shift_left_2_out, pc_in, write_data_mux;
wire [4:0] mux_links_van_registers, mux_branch_register_links_van_registers, mux_branch_link_LR_out;
wire [3:0] alucontrol_uit;


pc pc(.clock(clock),.reset(reset),.in(pc_in),.out(pc_out));

alu_add add_pc_met_4(.in1(pc_out),.in2(4),.out(add_pc_met_4_out));

instruction_memory instruction_memory(.address(pc_out),.data_out(instruction));

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

registers registers(.Read_register_1(instruction[9:5]), 
					.Read_register_2(mux_links_van_registers), 
					.Write_register(mux_branch_link_LR_out), 
					.Write_data(write_data_mux), 
					.RegWrite(RegWrite), 
					.Read_data_1(read_data_1), 
					.Read_data_2(read_data_2), 
					.clock(clock), 
					.reset(reset));
					

					
n_mux #(5) mux_read_reg(.in1(instruction[20:16]),.in2(instruction[4:0]),.out(mux_links_van_registers),.select(Reg2Loc));

sign_extend sign_extend(.in(instruction),.out(sign_extended));

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

alu_add add_shift_left_2_met_pc(.in1(pc_out),.in2(shift_left_2_uit),.out(add_pc_met_shift_left_2_out));

n_mux mux_rechts_van_add_pc_met_shift_left_2(.in1(add_pc_met_4_out),.in2(add_pc_met_shift_left_2_out),.out(mux_rechts_van_add_out),.select(or_out));



wire test;
assign or_out = test | Uncondbranch;
assign test = Branch & zero_mux_out;

endmodule 