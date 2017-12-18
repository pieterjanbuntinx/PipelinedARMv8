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