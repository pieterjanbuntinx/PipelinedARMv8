module shift_left_2(in, out);
	
	input [63:0] in;
	
	output [63:0] out;
	
	assign out[63:0]={in[61:0],2'b00};
	
endmodule 