module IF_ID(clock, reset, PC_out_in,PC_branch_link_in,PC_branch_link_out, instruction_in, instruction_out, PC_out_out, IF_ID_Write);
input clock, reset, IF_ID_Write;
input [63:0] PC_out_in, PC_branch_link_in;
input [31:0] instruction_in;
output [31:0] instruction_out;
output [63:0] PC_out_out, PC_branch_link_out;
reg [31:0] instruction_out;
reg [63:0] PC_out_out;
reg [63:0] PC_branch_link_out;

always @(posedge clock) begin
	if (reset) begin
		instruction_out <= 32'b0;
		PC_out_out <= 64'b0;
		PC_branch_link_out <= 64'b0;
	end else begin	
		if (IF_ID_Write) begin
			instruction_out <= instruction_in;
			PC_out_out <= PC_out_in;
			PC_branch_link_out <=  PC_branch_link_in;
		end
	end
end

endmodule