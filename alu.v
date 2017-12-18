module alu(in1, in2, out, zero, control);
	
	input [63:0] in1, in2;
	input [3:0] control;

	output [63:0] out;
	output zero;
	
	reg zero;
	reg [63:0] out;
	
	integer i;
	
	always @(in1 or in2 or control) begin
		case (control)   
			4'b0000 : out = in1 & in2;    // and
			4'b0001 : out = in1 | in2;    // or
			4'b0010 : out = in1 + in2;    // add
			4'b0110 : out = in1 -	in2;    // subtract
			4'b0111 : out = in2;  // pass input b
			4'b1001 : out = in1 ^ in2; // eor					  
			4'b1011 : out = in1 >> in2[31:0]; //LSR in2 = shamt
			4'b0011 : out = in1 << in2[31:0]; //LSL in2 = shamt


			default : out = 0; 
		endcase
		zero = (out == 32'b0);
		end   
	
endmodule 