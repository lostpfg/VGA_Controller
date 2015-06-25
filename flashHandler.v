/*----- Module Overview ---------------------------------------*
*                                                              *
*                      _______________                         *
*                                                              *
*                     |               |                        * 
*  clock  ------->    |               |                        * 
*  enable ------->    | flashHandler  |  ------->  rgbDepth    *
*                     |               |                        * 
*                      _______________                         *
*                                                              *
*--------------------------------------------------------------*/
module flashHandler ( clock, reset, enable, flashClk );

  input           reset;
  input           clock;
  input           enable;

  wire		      flashCnt;

  output reg 	   flashClk;
  
  flashClk i0 ( reset, clock, flashCnt );
  
  always @ ( posedge clock )
	if ( flashCnt )
		flashClk <= enable && ( ~flashClk );

endmodule
