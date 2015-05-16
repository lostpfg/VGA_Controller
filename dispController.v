/*----- Module Overview ------------------------------------------*
*																																	*
*                      _____________________                      *
*																																	*
*											|											|											* 
*  pixelClk ------->	|											| --/09--> vgaRGB     *
*  reset    ------->	|   dispController   	| -------> vgaVsync   *
*	 rgbIn  	--/03--> 	|											| -------> vgaHsync   *
*											|											|											* 
*                      _____________________                      *
*																																	*
*-----------------------------------------------------------------*/

module  dispController	(	pixelClk,	reset, rgbIn, vgaRGB, vgaHsync, vgaVsync );

input								pixelClk;
input								reset;
input 			[2:0]  	rgbIn;

wire				[9:0]		pixelCnt;
wire				[8:0]		lineCnt;
wire								compBlank;
wire								hSync;
wire								vSync;
wire 				[8:0]		charRGB;

output							vgaVsync;
output							vgaHsync;
output	reg	[8:0]		vgaRGB;

vgaHandler 			vgaPr 	( pixelClk, reset, hSync, pixelCnt, vSync, lineCnt, compBlank  );
charController	charPr	(	pixelClk,	reset, pixelCnt, lineCnt, charRGB	);

always @ ( posedge pixelClk or posedge reset ) begin
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