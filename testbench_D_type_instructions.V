module test_singlecycleprocessor(clock);

input clock;
reg reset;

wire uitgang;
PipelinedARMv8 scp(clock,reset,uitgang);
clockGenerator clk(clock);


/**
Instruction register: 
X16 = 20, X18 = 6, [X16, #0] = 35 [X16, #1] = 22;


LDUR X2, [X16, #0] => X2 = 35;
LDUR X2, [X16, #1] => X2 = 22;
ADD X16,X2,X3

STUR X18, [X16, #0] => [X16, #0] = 6;
STUR X18, [X16, #2] => [X16, #2] = 6;



*/

initial begin	
	$readmemh("register_file_D_type_test.hex",test_singlecycleprocessor.scp.instruction_decode.registers.regfile);
	$readmemh("instruction_memory_D_type_test.txt",test_singlecycleprocessor.scp.instruction_fetch.instruction_memory.memory);
	$readmemh("data_mem_D_type_test.hex",test_singlecycleprocessor.scp.memory.data_memory.memory);
	$display("Instruction	  	  X2				X3			X16  				 X18	 	instruction code   		mem[20]     	mem[21] 		mem[22]	  clock");
	
	/**$monitor(
			test_singlecycleprocessor.scp.instruction_decode.registers.regfile[2],
			test_singlecycleprocessor.scp.instruction_decode.registers.regfile[3],
			test_singlecycleprocessor.scp.instruction_decode.registers.regfile[16],	
			test_singlecycleprocessor.scp.instruction_decode.registers.regfile[18]," 		",
			test_singlecycleprocessor.scp.instruction,
			test_singlecycleprocessor.scp.memory.data_memory.memory[20],
			test_singlecycleprocessor.scp.memory.data_memory.memory[21],
			test_singlecycleprocessor.scp.memory.data_memory.memory[22],
			," 		",clock); */
			
	
	$monitor(
			test_singlecycleprocessor.scp.instruction_decode.registers.regfile[2],
			test_singlecycleprocessor.scp.instruction_decode.registers.regfile[3],
			test_singlecycleprocessor.scp.instruction_decode.registers.regfile[16],	
			test_singlecycleprocessor.scp.instruction_decode.registers.regfile[18]," 		",
			test_singlecycleprocessor.scp.instruction_IF_ID, " ",
			test_singlecycleprocessor.scp.PC_out, "   ",
			test_singlecycleprocessor.scp.write_back, "   ",
			test_singlecycleprocessor.scp.IF_ID_pipeline_register.IF_ID_Write, "  ",
  
			test_singlecycleprocessor.scp.execution.alu_result, "     ",
			test_singlecycleprocessor.scp.memory.data_memory.memory[20],
			test_singlecycleprocessor.scp.memory.data_memory.memory[22],
			," 		",clock); 


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