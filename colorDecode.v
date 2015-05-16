/*----- Module Overview ----------------------------------------*
*																															  *
*                     	 _________________         	            *
*																	  													  *
*												|									|										  * 
*  reset    	------->	|   				  		|										  * 
*	 ps2InCode  --/08-->  |		colorDecode		|  --/03-->  outColr  *
*												|									|	  									* 
*                      	 _________________											*
*																			  			  								*
*---------------------------------------------------------------*/

module colorDecode ( reset, inCode, outColor );

	input   						reset;
	input 			[5:0] 	inCode;

	output reg	[2:0] 	outColor;

	always @ ( inCode or posedge reset ) begin
	    if ( reset )
	        outColor  <= 3'd0;
	    else
					case ( inCode[1:0] ) /* Check only 2 least significant bits */
						2'd1 : outColor <= 3'd1;
						2'd2 : outColor <= 3'd2;
						2'd3 : outColor <= 3'd4;
					endcase
	end

endmodule
