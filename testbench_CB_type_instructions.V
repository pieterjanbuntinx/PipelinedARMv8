module test_singlecycleprocessor(clock);

input clock;
reg reset;

wire uitgang;
SingleCycleProcessor scp(clock,reset,uitgang);
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
	$readmemh("register_file_CB_type_test.hex",test_singlecycleprocessor.scp.registers.regfile);
	$readmemh("instruction_memory_CB_type_test.txt",test_singlecycleprocessor.scp.instruction_memory.memory);
	$display("Instruction	  	  X16	  		 PC_out	 	 instruction code");
	$monitor(test_singlecycleprocessor.scp.registers.regfile[16],
			test_singlecycleprocessor.scp.pc_out, "                 ",								
			" %h",test_singlecycleprocessor.scp.instruction);


reset = 1;
#15 reset = 0;
	
#300 $finish;		
	
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