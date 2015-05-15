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

	output reg	[5:0] 	ps2OutCode;

	always @ ( ps2InCode or posedge reset ) begin
	    if ( reset )
	        ps2OutCode  <= 6'hF0;
	    else
					ps2OutCode  <=  ( ps2InCode == 8'h16 ) ? 6'h00 :  				/* 1 */
             						  ( ps2InCode == 8'h1E ) ? 6'h10 :  				/* 2 */
              					  ( ps2InCode == 8'h26 ) ? 6'h20 :  				/* 3 */
              					  ( ps2InCode == 8'h25 ) ? 6'h30 :  				/* 4 */
              					  ( ps2InCode == 8'h2D ) ? 6'h01 :  				/* R */
              					  ( ps2InCode == 8'h34 ) ? 6'h02 :  				/* G */
              					  ( ps2InCode == 8'h32 ) ? 6'h03 : 6'hF0;   /* B / DC */
	end

endmodule
