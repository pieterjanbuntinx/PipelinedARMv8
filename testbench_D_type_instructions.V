module test_singlecycleprocessor(clock);

input clock;
reg reset;
reg [17:0] switches;

wire [26:0] leds;
wire uitgang;
PipelinedARMv8 scp(clock,reset,switches, leds);
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
  			test_singlecycleprocessor.scp.instruction_fetch.PC_in_write, " ",
			test_singlecycleprocessor.scp.execution.alu_result, "     ",
			test_singlecycleprocessor.scp.memory.data_memory.memory[20],
			test_singlecycleprocessor.scp.memory.data_memory.memory[35],
			test_singlecycleprocessor.scp.memory.data_memory.address, "  ",
			test_singlecycleprocessor.scp.memory.data_memory.leds, "  ",
			," 		",clock); 


reset = 1;
#15 reset = 0;
#15 switches <= 'h30;
#50 switches <= 'h15;
#100 switches <= 'h20;
	
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