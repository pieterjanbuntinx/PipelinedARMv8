module test_singlecycleprocessor(clock);

input clock;
reg reset;

wire uitgang;
SingleCycleProcessor scp(clock,reset,uitgang);
clockGenerator clk(clock);


/**
Instruction register: 
X16 = 20, X18 = 6, [X16, #1] = 21;


LDUR X2, [X16, #0] => X2 = 17;
LDUR X2, [X16, #1] => X2 = 21;

STUR X18, [X16, #0] => [X16, #0] = 6;

STUR X18, [X16, #2] => [X16, #2] = 6;



*/

initial begin	
	$readmemh("register_file_D_type_test.hex",test_singlecycleprocessor.scp.registers.regfile);
	$readmemh("instruction_memory_D_type_test.txt",test_singlecycleprocessor.scp.instruction_memory.memory);
	$readmemh("data_mem_D_type_test.hex",test_singlecycleprocessor.scp.data_memory.memory);
	$display("Instruction	  	  X2				Read_data2  		 PC_out	 	 data_memory[20] 		data_memory[22]		instruction code");
	$monitor(test_singlecycleprocessor.scp.registers.regfile[2],
			test_singlecycleprocessor.scp.registers.Read_data_2,
			test_singlecycleprocessor.scp.pc.out, 
			test_singlecycleprocessor.scp.data_memory.memory[20],
			test_singlecycleprocessor.scp.data_memory.memory[22], "                 ",								
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