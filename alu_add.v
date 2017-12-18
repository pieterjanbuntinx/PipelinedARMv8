module alu_add(in1,in2,out);

input [63:0] in1, in2;

output [63:0] out;

assign out = in1 + in2;

endmodule 