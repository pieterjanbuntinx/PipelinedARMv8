module test_singlecycleprocessor(clock);

input clock;
reg reset;
reg [17:0 ]switches;
wire [26:0] leds;

wire uitgang;
PipelinedARMv8 scp(clock,reset, switches, leds);
clockGenerator clk(clock);


/**
Instruction register: 
X16 = 20, X18 = 6, ;

B #24 => gaat naar Instructie 7
(...) 
ADD X2, X16, X18 => X2 = 20 + 6 = 26;
BL #8 => gaat naar instructie 10, X30 = PC + 4
(...)

ADD X2, X16, X18 => X2 = 20 + 6 = 26;




*/

initial begin	
	$readmemh("register_file_B_type_test.hex",test_singlecycleprocessor.scp.instruction_decode.registers.regfile);
	$readmemh("instruction_memory_B_type_test.txt",test_singlecycleprocessor.scp.instruction_fetch.instruction_memory.memory);
	$display("Instruction	  	  X2				X16  		   		X18 	 	 		X30(LR)	 			PC_out		instruction code		clock");
	$monitor(test_singlecycleprocessor.scp.instruction_decode.registers.regfile[2],
			test_singlecycleprocessor.scp.instruction_decode.registers.regfile[16],
			test_singlecycleprocessor.scp.instruction_decode.registers.regfile[18], 
			test_singlecycleprocessor.scp.instruction_decode.registers.regfile[30]," ",
			test_singlecycleprocessor.scp.PC_out, " 		",
			" %h",test_singlecycleprocessor.scp.instruction_IF_ID," 					",clock); 
	
			


reset = 1;
#15 reset = 0;
	
#250 $finish;		
	
end


endmodule 
module clockGenerator(clock);
output clock;
reg clock;
initial begin
	clock = 0;
end
always
	#10 clock = !clock;

endmodule 