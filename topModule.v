/*----- Module Overview --------------------------------------*
*																															*
*                      _________________                      *
*																															*
*											|									|											* 
*  boardClk ------->	|									| --/09--> vgaRGB     *
*  reset    ------->	|    topModule   	| -------> vgaVsync   *
*											|									| -------> vgaHsync   *
*											|									|											* 
*                      _________________                      *
*																															*
*-------------------------------------------------------------*/

module topModule ( boardClk, reset, vgaRGB, vgaHsync, vgaVsync );

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
	kbdController		kdbOv			(	pixelClk,	reset, ps2Clk, ps2Data, ps2OutCode );
	colorDecode 		clrDec 		( reset, 		ps2OutCode, outColor );
	dispController	vgaOv    	(	pixelClk,	reset, outColor, vgaRGB, vgaHsync, vgaVsync );

endmodule
