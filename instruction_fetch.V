module instruction_fetch(clock,reset, Branchreg, add_pc,read_data_1,
						instruction_out, PC_out, PC_branch_link_out, PCWrite, or_out);
input clock, Branchreg,reset, PCWrite,or_out;
input [63:0] read_data_1, add_pc;
output [31:0] instruction_out;
output [63:0] PC_out, PC_branch_link_out;
wire [63:0] PC_out, PC_in, PC_inc, PC_in_write;
wire [31:0] instruction_out;
wire [63:0]PC_mux;
assign PC_branch_link_out = PC_inc;


pc pc(.clock(clock),.reset(reset),.in(PC_in_write),.out(PC_out)); //program counter


alu_add adder(.in1(PC_out),.in2(64'b100),.out(PC_inc));
n_mux n_mux_PCWrite(.in1(PC_out), .in2(PC_in), .out(PC_in_write), .select(PCWrite)); //nieuwe waarde PC doorgeven of oude waarde
n_mux n_mux_PC_inc_CB(.in1(PC_inc), .in2(add_pc), .out(PC_mux), .select(or_out));
n_mux mux_met_branchreg(.in1(PC_mux),.in2(read_data_1),.out(PC_in),.select(Branchreg));

rom instruction_memory(PC_out[11:2],clock,instruction_out);



endmodule