module execution(pc_out,sign_extend_out,read_data_1,read_data_2,add_out, zero, alu_result,write_data, ALUSrc);

input [63:0] pc_out, read_data_1,read_data_2, sign_extend_out;
input ALUSrc;
input [3:0] alu_control_uit;

output [63:0] add_out, alu_result, write_data;
output zero;

wire [63:0] shift_left_2_out,alu_control_uit;

alu_add add_pc_met_4(pc_out,shift_left_2_out,add_out);

n_mux n_mux(read_data_2, sign_extend_out, mux_out, ALUSrc);

alu alu(read_data_1,mux_out,alu_result, zero, alu_control_uit);

shift_left_2 shift_left_2(sign_extend_out,shift_left_2_out);

endmodule 