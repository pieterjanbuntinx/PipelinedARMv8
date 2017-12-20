module execution(pc_out,read_data_1,read_data_2,  alu_result,sign_extend_in,
					ALUSrc, ALUOp, instruction, forwardA, forwardB, EX_MEM_alu_result, WB_write_back,alu_in2_out);

input [63:0] pc_out, read_data_1,read_data_2, EX_MEM_alu_result, WB_write_back, sign_extend_in;
input ALUSrc;
input [1:0] ALUOp;
input [31:0] instruction;
input [1:0] forwardA, forwardB;
wire [3:0] alu_control_uit;

output [63:0] alu_result, alu_in2_out;
wire [63:0] alu_mux_in_2, shift_left_2_out;

assign alu_in2_out = alu_in2;
//mux tussen read data 2 en sign extend out
n_mux n_mux(read_data_2, sign_extend_in, alu_mux_in_2, ALUSrc);

// 3 way mux voor waarden pipeline registers naar input 1 ALU te brengen
reg [63:0] alu_in1; 
always @(read_data_1 or EX_MEM_alu_result or WB_write_back or forwardA) begin
	case (forwardA)
		00: alu_in1 <= read_data_1;
		10: alu_in1 <= EX_MEM_alu_result;
		01: alu_in1 <= WB_write_back;
		default: alu_in1 <= 64'b0;
	endcase
end

// 3 way mux voor waarden pipeline registers naar input 1 ALU te brengen
reg [63:0] alu_in2;
always @(alu_mux_in_2 or EX_MEM_alu_result or WB_write_back or forwardB) begin
	case (forwardB)
		00: alu_in2 <= alu_mux_in_2;
		10: alu_in2 <= EX_MEM_alu_result;
		01: alu_in2 <= WB_write_back;
		default: alu_in2 <= 64'b0;
	endcase
end

wire zero;

alu alu(alu_in1,alu_in2,alu_result, zero, alu_control_uit);

alu_control alu_control(.alu_op(ALUOp),
						.instruction(instruction[31:21]),
						.out(alu_control_uit));

endmodule 