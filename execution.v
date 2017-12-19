module execution(pc_out,sign_extend_out,read_data_1,read_data_2,add_out, zero, alu_result,write_data, 
					ALUSrc, ALUOp, instruction, forwardA, forwardB, EX_MEM_alu_result, WB_write_back);

input [63:0] pc_out, read_data_1,read_data_2, sign_extend_out, EX_MEM_alu_result, WB_write_back;
input ALUSrc;
input [1:0] ALUOp;
input [31:0] instruction;
input [1:0] forwardA, forwardB;
wire [3:0] alu_control_uit;

output [63:0] add_out, alu_result, write_data;
output zero;

wire [63:0] alu_mux_in_2, shift_left_2_out;

alu_add add_pc_met_4(pc_out,shift_left_2_out,add_out);

//mux tussen read data 2 en sign extend out
n_mux n_mux(read_data_2, sign_extend_out, alu_mux_in_2, ALUSrc);



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

alu alu(alu_in1,alu_in2,alu_result, zero, alu_control_uit);

shift_left_2 shift_left_2(sign_extend_out,shift_left_2_out);

alu_control alu_control(.alu_op(ALUOp),
						.instruction(instruction[31:21]),
						.out(alu_control_uit));

endmodule 