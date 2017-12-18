module test_singlecycleprocessor(clock);

input clock;
reg reset;

wire uitgang;
SingleCycleProcessor scp(clock,reset,uitgang);
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
	$readmemh("register_file_B_type_test.hex",test_singlecycleprocessor.scp.registers.regfile);
	$readmemh("instruction_memory_B_type_test.txt",test_singlecycleprocessor.scp.instruction_memory.memory);
	$display("Instruction	  	  X2				Read_data2  		 PC_out	 	 		LR	 				instruction code");
	$monitor(test_singlecycleprocessor.scp.registers.regfile[2],
			test_singlecycleprocessor.scp.registers.Read_data_2,
			test_singlecycleprocessor.scp.pc.out, 
			test_singlecycleprocessor.scp.registers.regfile[30], "      ",								
			" %b",test_singlecycleprocessor.scp.instruction);
	
			


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