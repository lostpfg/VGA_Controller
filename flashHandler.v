/*----- Module Overview ---------------------------------------*
*                                                              *
*                      ____________                            *
*                                                              *
*                     |               |                        * 
*  clock  ------->    |               |                        * 
*  enable ------->    | flashHandler  |  ------->  rgbDepth    *
*                     |               |                        * 
*                      ____________                            *
*                                                              *
*--------------------------------------------------------------*/
module flashHandler ( clock, reset, enable, flashClk );

  input           reset;
  input           clock;
  input           enable;

  wire				flashCnt;

  output reg 	      flashClk;
  
  flashClk i0 ( reset, clock, flashCnt );
  
  always @ ( posedge flashCnt )
	flashClk <= enable && ( ~flashClk );

endmodule