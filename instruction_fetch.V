module instruction_fetch(clock,reset, Branchreg, add_pc,read_data_1,
						instruction_out, PC_out, PC_branch_link_out, PCWrite);
input clock, Branchreg,reset, PCWrite;
input [63:0] read_data_1, add_pc;
output [31:0] instruction_out;
output [63:0] PC_out, PC_branch_link_out;
wire [63:0] PC_out, PC_in, PC_inc, PC_in_write;
wire [31:0] instruction_out;
wire mux_pc_is_wat_out;
assign PC_branch_link_out = PC_inc;

n_mux n_mux_PCWrite(.in1(PC_out), .in2(PC_in), .out(PC_in_write), .select(PCWrite));
pc pc(.clock(clock),.reset(reset),.in(PC_in_write),.out(PC_out));

alu_add add_pc_met_4(.in1(PC_out),.in2(64'b100),.out(PC_inc));

instruction_memory instruction_memory(.address(PC_out),.data_out(instruction_out));

n_mux mux_met_branchreg(.in1(read_data_1),.in2(add_pc),.out(PC_in),.select(Branchreg));

endmodule