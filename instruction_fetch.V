module instruction_fetch(clock,reset, Branchreg, add_pc,read_data_1,
						instruction_out, PC_out, PC_branch_link_out, PCWrite,PC_inc_out, or_out);
input clock, Branchreg,reset, PCWrite,or_out;
input [63:0] read_data_1, add_pc;
output [31:0] instruction_out;
output [63:0] PC_out, PC_branch_link_out,PC_inc_out;
wire [63:0] PC_out, PC_in, PC_inc, PC_in_write;
wire [31:0] instruction_out;
wire [63:0]PC_mux;
assign PC_branch_link_out = PC_inc;


pc pc(.clock(clock),.reset(reset),.in(PC_in_write),.out(PC_out)); //program counter



n_mux n_mux_PCWrite(.in1(PC_out), .in2(PC_in), .out(PC_in_write), .select(PCWrite)); //nieuwe waarde PC doorgeven of oude waarde
n_mux n_mux_PC_inc_CB(.in1(PC_inc), .in2(PC_CB), .out(PC_mux), .select(or_out));
n_mux mux_met_branchreg(.in1(PC_mux),.in2(read_data_1),.out(PC_in),.select(Branchreg));

alu_add adder(.in1(PC_out),.in2(4),.out(PC_inc));

instruction_memory instruction_memory(.address(PC_out),.data_out(instruction_out));



endmodule