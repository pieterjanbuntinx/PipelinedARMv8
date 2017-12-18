module ID_EX(	clock, reset, wren, PC_out_in, read_data1_in, read_data2_in, 
				sign_extended_in, PC_out_out, sign_extended_out);
input clock, reset, wren;
input [63:0] PC_out_in, read_data1_in, read_data2_in, sign_extended_in;

output [63:0] PC_out_out, read_data1_out, read_data2_out, sign_extended_out;
reg [63:0] PC_out_out, read_data1_out, read_data2_out, sign_extended_out;

always @(posedge clock) begin
	if (reset) begin
		PC_out_out <= 64'b0;
		sign_extended_out <= 64'b0;
		read_data1_out <= 64'b0;
		read_data2_out <= 64'b0;
	end else begin
		if (wren) begin
			PC_out_out <= PC_out_in;
			sign_extended_out <= sign_extended_in;
			read_data1_out <= read_data1_in;
			read_data2_out <= read_data2_in;
		end
	end
end

endmodule