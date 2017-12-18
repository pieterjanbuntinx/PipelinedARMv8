module test_singlecycleprocessor(clock);


//getest: ADD

input clock;
reg reset;

wire uitgang;
SingleCycleProcessor scp(clock,reset,uitgang);
clockGenerator clk(clock);


/**
Instruction register: 
X16 = 20, X18 = 6;

ADD X2, X16, X18; X2 = 20+6 = 26 
SUB X2, X16, X18; X2 = 20-6 = 14
AND X2, X16, X18; X2 = 20 AND 6 = 4
ORR X2, X16, X18; X2 = 20 OR 6 = 22
EOR X2, X16, X18; X2 = 20 EOR 6 = 18
LSL X2, X16, #3;  X2 = 20 * 2^3 = 160
LSR X2, X16, #3;  X2 = 20 / 2^3 = 2.5
BR X17; X17 = 8;


*/

initial begin	
	$readmemh("register_file_R_type_test.hex",test_singlecycleprocessor.scp.registers.regfile);
	 $readmemh("instruction_memory_R_type_test.txt",test_singlecycleprocessor.scp.instruction_memory.memory);
	$display("Instruction	  	  X2				  Read_data1		  Read_data2		PC_out	 instruction code");
	$monitor(test_singlecycleprocessor.scp.registers.regfile[2],
			test_singlecycleprocessor.scp.registers.Read_data_1,
			test_singlecycleprocessor.scp.registers.Read_data_2,
			test_singlecycleprocessor.scp.pc.out, "      ",					
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