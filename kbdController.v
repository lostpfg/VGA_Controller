/*----- Module Overview ------------------------------------------*
*																																	*
*                      _____________________                      *
*																																	*
*											|											|											* 
*  clock		------->	|											|											* 
*  reset    ------->	|    kbdController   	| --/06--> ps2OutCode *
*	 ps2Data  ------->  |											|											* 
*	 ps2Clk   ------->  |											|											*
*											|											|											*  
*                      _____________________                      *
*																																	*
*-----------------------------------------------------------------*/

module  kbdController	(	clock,	reset, ps2Clk, ps2Data, ps2OutCode );

	input								clock;
	input								ps2Clk;
	input								reset;
	input								ps2Data;

	wire				[7:0]		scanCode;

	output reg	[5:0] 	ps2OutCode; /* !!! Reg @ output may not be needed cause its already a register at sub module !!! */

	kbdHandler 	kdbOv ( reset, clock, ps2Clk, ps2Data, scanCode );
	ps2Decode 	ps2Ov	( reset, scanCode, ps2OutCode  );

endmodule