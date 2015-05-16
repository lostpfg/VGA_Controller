/*----- Module Overview ---------------------------------------*
*																													   	 *
*                      _______________                       	 *
*																  													 	 *
*											|								|											 	 * 
*  inClock  ------->	|   				  	|											 	 * 
*	 reset  	------->  |		pixelClk		|  ------->  ps2OutCode  *
*											|								|	  										 * 
*                      _______________ 												 *
*																		  		  									 *
*--------------------------------------------------------------*/
module pixelClk ( inClock, reset, outClock );

  input 					inClock;
  input 					reset;

  reg 		[1:0] 	cnt; /* 1 bit register */

  output 					outClock;
  
  assign outClock = ( cnt == 2'd3 ); /* We count at range 0-3 */

  always @ ( posedge inClock or posedge reset )
    if ( reset ) 
			cnt <= 0; /* Clear Counter */
    else 
			cnt <= cnt + 1;

endmodule