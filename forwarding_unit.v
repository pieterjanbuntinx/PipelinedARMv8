module forwarding_unit(	EX_MEM_RegWrite, EX_MEM_RegisterRd, ID_EX_RegisterRn1, ID_EX_RegisterRm2,
						MEM_WB_RegWrite, MEM_WB_RegisterRd, ForwardA, ForwardB);
						
input [4:0] EX_MEM_RegisterRd, ID_EX_RegisterRn1, ID_EX_RegisterRm2, MEM_WB_RegisterRd;
input EX_MEM_RegWrite, MEM_WB_RegWrite;
output [1:0] ForwardA, ForwardB; 
reg [1:0] ForwardA, ForwardB;	



always @(EX_MEM_RegWrite or MEM_WB_RegWrite or EX_MEM_RegisterRd or ID_EX_RegisterRn1 or
		ID_EX_RegisterRm2, MEM_WB_RegisterRd)
begin
	//EX hazard:
	if (EX_MEM_RegWrite && (EX_MEM_RegisterRd !== 31) && (EX_MEM_RegisterRd == ID_EX_RegisterRn1))
		ForwardA <= 2'b10;
	else ForwardA <= 2'b0;
	if (EX_MEM_RegWrite && (EX_MEM_RegisterRd !== 31) && (EX_MEM_RegisterRd == ID_EX_RegisterRm2))
		ForwardB <= 2'b10;
	else ForwardA <= 2'b0;
		
	//MEM hazard:
	if (MEM_WB_RegWrite && (MEM_WB_RegisterRd !== 31) && (MEM_WB_RegisterRd == ID_EX_RegisterRn1)
		&& !(EX_MEM_RegWrite && (EX_MEM_RegisterRd !== 31) && (EX_MEM_RegisterRd == ID_EX_RegisterRn1)))
		ForwardA <= 2'b01; 
	else ForwardB <= 2'b0;
	if (MEM_WB_RegWrite && (MEM_WB_RegisterRd !== 31) && (MEM_WB_RegisterRd == ID_EX_RegisterRm2)
		&& !(EX_MEM_RegWrite && (EX_MEM_RegisterRd !== 31) && (EX_MEM_RegisterRd == ID_EX_RegisterRm2)))
		ForwardB <= 2'b01; 	
	else ForwardB <= 2'b0;		
end 

endmodule					