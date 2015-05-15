module vgaTest ( boardClk, reset, vgaRGB, vgaHsync, vgaVsync );

input						boardClk;
input   				reset;
input        		ps2Clk, 
input 					ps2Data;

wire 						pixelClk;
wire		[7:0] 	ps2Code;
wire		[5:0] 	ps2OutCode;
wire		[2:0] 	outColor;

output	[8:0]  	vgaRGB;
output 		    	vgaHsync;
output 		    	vgaVsync;

pixelClk				clk25MHz 	( boardClk, reset, pixelClk );
kbdController		kdbOv			(	boardClk,	reset, ps2Clk, ps2Data, ps2OutCode );
colorDecode 		clrDec 		( reset, 		ps2OutCode, outColor );
dispController	vgaOv    	(	pixelClk,	reset, outColr, vgaRGB, vgaHsync, vgaVsync );

endmodule
