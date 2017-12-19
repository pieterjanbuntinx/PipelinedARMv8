module hazard_detection_unit (clock, reset, ID_EX_MemRead, ID_EX_RegisterRd, IF_ID_RegisterRn1, IF_ID_RegisterRm2, stall);
input clock, reset;
input [4:0] ID_EX_RegisterRd, IF_ID_RegisterRn1, IF_ID_RegisterRm2;
input ID_EX_MemRead;

output stall;
reg stall;

always @(posedge clock)
begin
	if (reset) stall <= 0;
	else begin 
		if (ID_EX_MemRead && ((ID_EX_RegisterRd == IF_ID_RegisterRn1) || (ID_EX_RegisterRd == IF_ID_RegisterRm2)))
			stall <= 1;
		else stall <= 0;
	end
end

endmodule