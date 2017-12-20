module control(clock, instruction, Reg2Loc, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Uncondbranch, Branchlink, Branchreg, not_zero);

output Reg2Loc, ALUSrc, MemtoReg, Branch, MemRead, MemWrite, RegWrite,Uncondbranch, Branchlink, Branchreg, not_zero;
reg Reg2Loc, ALUSrc, MemtoReg, Branch, MemRead, MemWrite, RegWrite, Uncondbranch, Branchlink,Branchreg, not_zero;
output [1:0] ALUOp;
reg [1:0] ALUOp;

input clock;
input [10:0] instruction;

always @(instruction) begin
	
	case(instruction) 
		11'b10001011000 : begin //ADD
		Reg2Loc = 0;
		ALUSrc = 0;
		MemtoReg = 0;
		RegWrite = 1;
		MemRead = 0;
		MemWrite = 0;
		Branch = 0;
		ALUOp[1] = 1;
		ALUOp[0] = 0;
		Uncondbranch = 0;
		Branchlink = 0;
		Branchreg = 0;
		not_zero = 0;
		$display("ADD");
		end
		
		11'b11001011000 : begin //SUB
		Reg2Loc = 0;
		ALUSrc = 0;
		MemtoReg = 0;
		RegWrite = 1;
		MemRead = 0;
		MemWrite = 0;
		Branch = 0;
		ALUOp[1] = 1;
		ALUOp[0] = 0;
		Uncondbranch = 0;
		Branchlink = 0;
		Branchreg = 0;
		not_zero = 0;
		$display("SUB");
		end
		
		11'b10001010000 : begin //AND
		Reg2Loc = 0;
		ALUSrc = 0;
		MemtoReg = 0;
		RegWrite = 1;
		MemRead = 0;
		MemWrite = 0;
		Branch = 0;
		ALUOp[1] = 1;
		ALUOp[0] = 0;
		Uncondbranch = 0;
		Branchlink = 0;
		Branchreg = 0;
		not_zero = 0;
		$display("AND");
		end
		
		11'b10101010000 : begin //ORR
		Reg2Loc = 0;
		ALUSrc = 0;
		MemtoReg = 0;
		RegWrite = 1;
		MemRead = 0;
		MemWrite = 0;
		Branch = 0;
		ALUOp[1] = 1;
		ALUOp[0] = 0;
		Uncondbranch = 0;
		Branchlink = 0;
		Branchreg = 0;
		not_zero = 0;
		$display("ORR");
		end
		
		11'b11001010000 : begin //EOR
		Reg2Loc = 0;
		ALUSrc = 0;
		MemtoReg = 0;
		RegWrite = 1;
		MemRead = 0;
		MemWrite = 0;
		Branch = 0;
		ALUOp[1] = 1;
		ALUOp[0] = 0;
		Uncondbranch = 0;
		Branchlink = 0;
		Branchreg = 0;
		not_zero = 0;
		$display("EOR");
		end
		
		11'b11111000010 : begin //LDUR
		ALUSrc = 1;
		MemtoReg = 1;
		RegWrite = 1;
		MemRead = 1;
		MemWrite = 0;
		Branch = 0;
		ALUOp[1] = 0;
		ALUOp[0] = 0;
		Uncondbranch = 0;
		Branchlink = 0;
		Branchreg = 0;
		not_zero = 0;
		$display("LDUR");
		end
		
		11'b11111000000 : begin //STUR
		Reg2Loc = 1;
		ALUSrc = 1;
		RegWrite = 0;
		MemRead = 0;
		MemWrite = 1;
		Branch = 0;
		ALUOp[1] = 0;
		ALUOp[0] = 0;
		Uncondbranch = 0;
		Branchlink = 0;
		Branchreg = 0;
		not_zero = 0;
		$display("STUR");
		end
		
		11'b11010011011 : begin //LSL
		Reg2Loc = 0;
		ALUSrc = 1;
		MemtoReg = 0;
		RegWrite = 1;
		MemRead = 0;
		MemWrite = 0;
		Branch = 0;
		ALUOp[1] = 1;
		ALUOp[0] = 0;
		Uncondbranch = 0;
		Branchlink = 0;
		Branchreg = 0;
		not_zero = 0;		
		$display("LSL");
		end
		
		11'b11010011010 : begin //LSR
		Reg2Loc = 0;
		ALUSrc = 1;
		MemtoReg = 0;
		RegWrite = 1;
		MemRead = 0;
		MemWrite = 0;
		Branch = 0;
		ALUOp[1] = 1;
		ALUOp[0] = 0;
		Uncondbranch = 0;
		Branchlink = 0;
		Branchreg = 0;
		not_zero = 0;
		$display("LSR");
		end
		
		11'b11010110000 : begin //BR
		Reg2Loc = 0;
		ALUSrc = 0;
		MemtoReg = 0;
		RegWrite = 1;
		MemRead = 0;
		MemWrite = 0;
		Branch = 0;
		ALUOp[1] = 1;
		ALUOp[0] = 0;
		Uncondbranch = 0;
		Branchlink = 0;
		Branchreg = 1;
		not_zero = 0;
		$display("BR");
		end
		default: begin Reg2Loc = 0; ALUSrc = 0; MemtoReg = 0; RegWrite = 0; MemRead = 0; MemWrite = 0; Branch = 0; ALUOp[1] = 1; ALUOp[0] = 1; Uncondbranch =0;Branchlink = 0;Branchreg = 0; end
		
	endcase 
	if(instruction[10:3] == 8'b10110100) begin //CBZ
		Reg2Loc = 1;
		ALUSrc = 0;
		RegWrite = 0;
		MemRead = 0;
		MemWrite = 0;
		Branch = 1;
		Uncondbranch = 0;
		ALUOp[1] = 0;
		Branchlink = 0;
		Branchreg = 0;
		ALUOp[0] = 1;
		not_zero = 0;
		$display("CBZ");
	end
	else if(instruction[10:3] == 8'b10110101) begin //CBNZ 
		Reg2Loc = 1;
		ALUSrc = 0;
		MemtoReg = 0;
		RegWrite = 0;
		MemRead = 0;
		MemWrite = 0;
		Branch = 1;
		Uncondbranch = 0;
		ALUOp[1] = 0;
		ALUOp[0] = 1;
		Branchlink = 0;
		Branchreg = 0;
		not_zero = 1;
		$display("CBNZ");
	end
	else if(instruction[10:5] == 6'b100101) begin //BL 
		Reg2Loc = 1;
		ALUSrc = 0;
		MemtoReg = 0;
		RegWrite = 1;
		MemRead = 0;
		MemWrite = 0;
		Branch = 0;
		Uncondbranch = 1;
		ALUOp[1] = 0;
		ALUOp[0] = 1;
		Branchlink = 1;
		Branchreg = 0;
		not_zero = 0;
		$display("BL");
	end
	else if(instruction[10:5] == 6'b000101) begin //B
		Reg2Loc = 0;
		ALUSrc = 0;
		MemtoReg = 0;
		RegWrite = 0;
		MemRead = 0;
		MemWrite = 0;
		Branch = 0;
		Uncondbranch = 1;
		ALUOp[1] = 0;
		ALUOp[0] = 1;
		Branchlink = 0;
		Branchreg = 0;
		not_zero = 0;
		$display("B");
	end
	
end

endmodule 