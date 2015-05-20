/*----- Module Overview -----------------------------------------*
*																														   	 *
*                     	 _______________                       	 *
*																	  													 	 *
*												|								|											 	 * 
*  reset    	------->	|   				  	|											 	 * 
*	 ps2InCode  --/08-->  |		ps2Decode		|  --/06-->  ps2OutCode  *
*												|								|	  										 * 
*                      	 _______________ 												 *
*																			  		  									 *
*----------------------------------------------------------------*/

module ps2Decode ( reset, ps2InCode, ps2OutCode  );

	input   						reset;
	input 			[7:0] 	ps2InCode;

	output reg	[7:0] 	ps2OutCode;

	always @ ( * ) begin
	    if ( reset )
	      ps2OutCode  <= 4'hE;
	    else
				ps2OutCode  <= ( ps2InCode == 8'h16 ) ? 4'h0 : 					/* 1 */
											 ( ps2InCode == 8'h1E ) ? 4'h1 : 					/* 2 */
											 ( ps2InCode == 8'h26 ) ? 4'h2 : 					/* 3 */
											 ( ps2InCode == 8'h25 ) ? 4'h3 : 					/* 4 */
											 ( ps2InCode == 8'h2D ) ? 4'h4 : 					/* R */
											 ( ps2InCode == 8'h34 ) ? 4'h5 : 					/* G */
											 ( ps2InCode == 8'h32 ) ? 4'h6 : 					/* B */
											 ( ps2InCode == 8'h32 ) ? 4'h7 : 					/* Up */
											 ( ps2InCode == 8'h32 ) ? 4'h8 : 					/* Down */
											 ( ps2InCode == 8'h32 ) ? 4'h9 : 					/* Left */
											 ( ps2InCode == 8'h32 ) ? 4'hA : 					/* Right */
											 ( ps2InCode == 8'h79 ) ? 4'hB : 					/* + */
											 ( ps2InCode == 8'h7B ) ? 4'hC : 					/* - */
											 ( ps2InCode == 8'h6B ) ? 4'hD : 4'hE;		/* f / DC */
								 
								 
	end

endmodule
