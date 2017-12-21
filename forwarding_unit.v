module forwarding_unit(	EX_MEM_RegWrite, EX_MEM_RegisterRd, ID_EX_RegisterRn1, ID_EX_RegisterRm2,
						MEM_WB_RegWrite, MEM_WB_RegisterRd, ForwardA, ForwardB);
						
input [4:0] EX_MEM_RegisterRd, ID_EX_RegisterRn1, ID_EX_RegisterRm2, MEM_WB_RegisterRd;
input EX_MEM_RegWrite, MEM_WB_RegWrite;
output [1:0] ForwardA, ForwardB; 
reg [1:0] ForwardA, ForwardB;	



always @*
begin

	//EX hazard:
	if (EX_MEM_RegWrite && (EX_MEM_RegisterRd !== 31) && (EX_MEM_RegisterRd == ID_EX_RegisterRn1)) ForwardA = 2'b10;
	
	if (EX_MEM_RegWrite && (EX_MEM_RegisterRd !== 31) && (EX_MEM_RegisterRd == ID_EX_RegisterRm2)) ForwardB = 2'b10;
	
		
	//MEM hazard:
	if (MEM_WB_RegWrite && (MEM_WB_RegisterRd !== 31) 
		&& !(EX_MEM_RegWrite && (EX_MEM_RegisterRd !== 31) && (EX_MEM_RegisterRd == ID_EX_RegisterRn1))
		&& (MEM_WB_RegisterRd == ID_EX_RegisterRn1))
		ForwardA <= 2'b01; 
	
	if (MEM_WB_RegWrite && (MEM_WB_RegisterRd !== 31) && !(EX_MEM_RegWrite && (EX_MEM_RegisterRd !== 31) 
		&& (EX_MEM_RegisterRd == ID_EX_RegisterRm2)) && (MEM_WB_RegisterRd == ID_EX_RegisterRm2))
		ForwardB <= 2'b01; 	
	else begin ForwardB <= 'b00; ForwardA <= 'b00;
	end
end 

endmodule					
