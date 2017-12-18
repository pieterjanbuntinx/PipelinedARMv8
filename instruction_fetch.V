module instruction_fetch(clock, reset, Branchreg, PC_branch, instruction, PC_out);
input clock, reset, Branchreg;
input [63:0] PC_branch;
output [31:0] instruction;
output [63:0] PC_out;

wire [63:0] PC_out, PC_inc, PC_inc;
wire [31:0] instruction;

pc pc(.clock(clock),.reset(reset),.in(PC_in),.out(PC_out));

alu_add add_pc_met_4(.in1(PC_out),.in2(4),.out(PC_inc));

instruction_memory instruction_memory(.address(pc_out),.data_out(instruction));

always @(PC_inc, PC_branch, Branchreg) begin
	if (Branchreg) PC_in <= PC_branch;
	else PC_in <= PC_inc;
end

endmodule

module IF_ID(clock, reset, wren, PC_inc_in, instruction_in, instruction_out, PC_inc_out);
input clock, reset, wren;
input [63:0] PC_inc_in;
input [31:0] instruction_in;
output [31:0] instruction_out;
output [63:0] PC_inc_out;
reg [31:0] instruction_out;
reg [63:0] PC_inc_out;

always @(posedge clock) begin
	if (reset) begin
		instruction_out <= 32'b0;
		PC_inc_out <= 64'b0;
	end else begin
		if (wren) begin
			instruction_out <= instruction_in;
			PC_inc_out <= PC_inc_in;
		end
	end
end

endmodule