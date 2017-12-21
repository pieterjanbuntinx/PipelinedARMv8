module hazard_detection_unit (ID_EX_MemRead, ID_EX_RegisterRd, IF_ID_RegisterRn1, IF_ID_RegisterRm2, stall);
input [4:0] ID_EX_RegisterRd, IF_ID_RegisterRn1, IF_ID_RegisterRm2;
input ID_EX_MemRead;

output stall;
reg stall;

always @(ID_EX_MemRead or IF_ID_RegisterRn1 or ID_EX_RegisterRd or IF_ID_RegisterRm2)
begin

	if (ID_EX_MemRead && ((ID_EX_RegisterRd == IF_ID_RegisterRn1) || (ID_EX_RegisterRd == IF_ID_RegisterRm2)))begin
		stall <= 1;
		$display("gay");end
	else stall <= 0;	
end

endmodule