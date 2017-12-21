module test_singlecycleprocessor(clock);

input clock;
reg reset;

wire uitgang;
PipelinedARMv8 scp(clock,reset,uitgang);
clockGenerator clk(clock);


/**
Instruction register: 
X2 = 80; X16 = 2, X18 = 1

SUB X16, X16, X18; => X16 = 2 - 1 = 1
CBZ X16, #24; => branched niet, X16 != 0
SUB X16, X16, X18; => X16 = 1 - 1 = 0
CBZ X16, #16; => branched wel naar 3 instructies later
ADD X16, X16, X18 
(...)
ADD X16, X16, X2; => X16 = X16 + 80 = 80;

SUB X16, X16, #80; X16 = X16 - 80 = 0
CBNZ X16, #24 => branched niet want X16 = 0
ADD X16, X16, X18 => X16 = X16 +1 = 1;
CBNZ X16, #16 => branched wel want X16 != 0
00000000 (....)
ADD X16, X16, X18 
00000000
ADD X16, X16, X2 => X16 = X16 + 80

*/

initial begin	
	$readmemh("register_file_CB_type_test.hex",test_singlecycleprocessor.scp.instruction_decode.registers.regfile);
	$readmemh("instruction_memory_CB_type_test.txt",test_singlecycleprocessor.scp.instruction_fetch.instruction_memory.memory);
	$display("Instruction	  	  X2				X16  		   X18	 	 		LR	 				instruction code");
/**	$monitor(test_singlecycleprocessor.scp.instruction_decode.registers.regfile[2],
			test_singlecycleprocessor.scp.instruction_decode.registers.regfile[16],
			test_singlecycleprocessor.scp.instruction_decode.registers.regfile[18], 
			test_singlecycleprocessor.scp.write_back, "      ",	
			test_singlecycleprocessor.scp.instruction_fetch.PC_in_write, "      ",								
			" %b",test_singlecycleprocessor.scp.instruction," ",clock); */
			
			$monitor(test_singlecycleprocessor.scp.instruction_decode.registers.regfile[2],
				test_singlecycleprocessor.scp.instruction_decode.registers.regfile[16],
				test_singlecycleprocessor.scp.instruction_decode.registers.regfile[18], " ",
				test_singlecycleprocessor.scp.instruction_decode.read_data2, " ", 
				test_singlecycleprocessor.scp.instruction_decode.Branch, "      ",	
				test_singlecycleprocessor.scp.instruction_decode.and_out, "  ",
				test_singlecycleprocessor.scp.instruction_decode.or_out, "  ",
			 	test_singlecycleprocessor.scp.instruction_decode.zero_EX, " ",
			 	test_singlecycleprocessor.scp.instruction_decode.read_data2, " ",
				test_singlecycleprocessor.scp.instruction_decode.PC_CB, " ", 			 	
			 	test_singlecycleprocessor.scp.instruction_fetch.PC_in_write, " ",
				" %b",test_singlecycleprocessor.scp.instruction," ",clock); 
	


reset = 1;
#15 reset = 0;
	
#500 $finish;		
	
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