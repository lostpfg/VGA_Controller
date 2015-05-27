/*----- Module Overview ------------------------------------------*
*                                                                 *
*                      _______________                            *
*                                                                 *
*                     |                  |                        * 
*  reset  ------->    |                  |                        * 
*  rgbEn  ------->    |   colorHandler   |  ------->  rgbDepth    *
*                     |                  |                        * 
*                      _______________                            *
*                                                                 *
*-----------------------------------------------------------------*/
module colorHandler ( reset, enable, rgbEn, charRgbDepth, bckRgbDepth  );

  input           reset;
  input   [2:0]   rgbEn;
  input           enable;
  
  output  [8:0]   charRgbDepth;
  output  [8:0]   bckRgbDepth;

  UpDownCounter3bit  frRedCnt   ( reset, ~enable & rgbEn[0], charRgbDepth[2:0] ); 
  UpDownCounter3bit  frGreenCnt ( reset, ~enable & rgbEn[1], charRgbDepth[5:3] ); 
  UpDownCounter3bit  frBlueCnt  ( reset, ~enable & rgbEn[2], charRgbDepth[8:6] ); 

  UpDownCounter3bit  bkRedCnt   ( reset, enable & rgbEn[0], bckRgbDepth[2:0] ); 
  UpDownCounter3bit  bkGreenCnt ( reset, enable & rgbEn[1], bckRgbDepth[5:3] ); 
  UpDownCounter3bit  bkBlueCnt  ( reset, enable & rgbEn[2], bckRgbDepth[8:6] ); 


endmodule
