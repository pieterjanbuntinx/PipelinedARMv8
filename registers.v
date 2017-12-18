module registers(Read_register_1, Read_register_2, Write_register, Write_data, RegWrite, Read_data_1, Read_data_2, clock, reset);

input  [4:0] Read_register_1, Read_register_2, Write_register;
input  [63:0] Write_data;
input  RegWrite, clock, reset;

output [63:0] Read_data_1, Read_data_2;

reg [63:0] regfile [0:31]; 

wire [63:0] Read_data_1, Read_data_2;

integer i;

assign Read_data_1 = regfile[Read_register_1];
assign Read_data_2 = regfile[Read_register_2];
always@(posedge clock) begin
	if (reset)
		for (i = 0; i < 32; i = i + 1) regfile[i] <= 64'b0;
	else begin
		if (RegWrite) 
			regfile[Write_register] <= Write_data;
			
		end
	end
endmodule 
