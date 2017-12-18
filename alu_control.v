module alu_control(alu_op, instruction, out);
  
  input [1:0] alu_op; 
  input [10:0] instruction;
  output [3:0] out;
  reg [3:0] out;

  always @(alu_op or instruction) begin
    
    case (alu_op)
      2'b00 : out = 4'b0010; //LDUR and STUR
      2'b01 : out = 4'b0111; //CBZ CBNZ B and BL
      2'b10 : begin
       
				case (instruction)
				  11'b10001011000 : out = 4'b0010; //ADD
				  11'b11001011000 : out = 4'b0110; //SUB
				  11'b10001010000 : out = 4'b0000; //AND
				  11'b10101010000 : out = 4'b0001; //ORR
				  11'b11010011011 : out = 4'b0011; //LSL
				  11'b11010011010 : out = 4'b1011; //LSR
				  11'b11010110000 : out = 4'b0111; //BR
				  11'b11001010000 : out = 4'b1001; //EOR
				  default : out = 0;
				endcase
        
			  end
		default: out = 0;
    endcase
    
  end
  
endmodule 