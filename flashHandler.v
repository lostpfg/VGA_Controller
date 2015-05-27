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
module flashHandler ( reset, enable, rgbDepth );

  input           clock;
  input           enable;

  output  reg     flashCnt;
  
  // ++++

endmodule