module op_bord(iCLK_50, iKEY, iSW, oLED_R, oLED_G);

input iCLK_50;
input [17:0] iSW;
input [3:0] iKEY;

output [18:0] oLED_R;
output [7:0] oLED_G;

PipelinedARMv8 cpu(.clock(iCLK_50),
				   .reset(iKEY[0]),
				   .switches(iSW),
				   .leds({{oLED_R},{oLED_G}}));
				   
endmodule 