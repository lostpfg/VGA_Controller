/*----- Module Overview ------------------------------------------*
*																																	*
*                      _____________________                      *
*																																	*
*											|											|											* 
*  clock ------->	|											| --/09--> vgaRGB     *
*  reset    ------->	|   dispController   	| -------> vgaVsync   *
*	 rgbIn  	--/03--> 	|											| -------> vgaHsync   *
*											|											|											* 
*                      _____________________                      *
*																																	*
*-----------------------------------------------------------------*/

module  dispController	(	clock,	reset, rgbIn, vgaRGB, vgaHsync, vgaVsync );

input								clock;
input								reset;
input 			[2:0]  	rgbIn;

wire				[9:0]		pixelCnt;
wire				[8:0]		lineCnt;
wire								compBlank;
wire								hSync;
wire								vSync;
wire 				[8:0]		charRGB;
wire								rowEn;
wire								colEn;
wire								outBit;

output							vgaVsync;
output							vgaHsync;
output	reg	[8:0]		vgaRGB;

vgaHandler 			dc0  ( clock, reset, hSync, pixelCnt, vSync, lineCnt, compBlank  );
charController	dc1	 ( clock, reset, pixelCnt, lineCnt, rgbIn, outBit, colEn, rowEn, charRGB	);
charParsser			dc2	 ( clock, reset, colEn, rowEn, outBit ) ; 


always @ ( posedge clock or posedge reset ) begin
	if ( reset ) 
		begin 
			vgaRGB	<= 9'd0; /* Clear Local Buffer */
		end
	else 
		if ( compBlank ) /* Make Screen Black */
			begin
				vgaHsync  <=	hSync;
				vgaVsync  <=	vSync;			
				vgaRGB		<=	9'd0; /* Clear Local Buffer */
			end
		else
			begin
				vgaHsync  <=	hSync;
				vgaVsync  <=	vSync;
				vgaRGB		<= 	charRGB;
			end
end

endmodule