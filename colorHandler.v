/*----- Module Overview ------------------------------------------*
*                                                                 *
*                      _______________                            *
*                                                                 *
*                     |                  |                        * 
*  reset  ------->    |                  |                        * 
*  rgbEn  ------->    | colorController  |  ------->  rgbDepth    *
*                     |                  |                        * 
*                      _______________                            *
*                                                                 *
*-----------------------------------------------------------------*/
module colorController ( reset, rgbEn, rgbDepth );

  input           clock;
  input   [2:0]   rgbEn;

  output  reg [8:0]   rgbDepth;
  
  UpDownCounter3bit  redCnt   (  reset, rgbEn[0], rgbDepth[2:0] ); 
  UpDownCounter3bit  greenCnt (  reset, rgbEn[1], rgbDepth[5:3] ); 
  UpDownCounter3bit  blueCnt  (  reset, rgbEn[2], rgbDepth[8:6] ); 

endmodule