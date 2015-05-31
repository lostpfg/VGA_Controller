/*----- Module Overview ------------------------------------------*
*                                                                 *
*                      __________________                         *
*                                                                 *
*                     |                  |                        * 
*  reset  ------->    |                  |  --/09-->  charRGB     *
*  select ------->    |   colorHandler   |  --/09-->  bgRGB       *
*  rgbEn  --/03-->    |                  |                        *
*                     |                  |                        *  
*                      __________________                         *
*                                                                 *
*-----------------------------------------------------------------*/
module colorHandler ( reset, select, rgbEn, charRGB, bgRGB  );

  input           reset;
  input   [2:0]   rgbEn;
  input           select;
  
  output  [8:0]   charRGB;
  output  [8:0]   bgRGB;

  UpDownCounter3bit  charRedCnt   ( reset, ~select & rgbEn[0], charRGB[2:0] ); 
  UpDownCounter3bit  charGreenCnt ( reset, ~select & rgbEn[1], charRGB[5:3] ); 
  UpDownCounter3bit  charBlueCnt  ( reset, ~select & rgbEn[2], charRGB[8:6] ); 

  UpDownCounter3bit  bgRedCnt   ( reset, select & rgbEn[0], bgRGB[2:0] ); 
  UpDownCounter3bit  bgGreenCnt ( reset, select & rgbEn[1], bgRGB[5:3] ); 
  UpDownCounter3bit  bgBlueCnt  ( reset, select & rgbEn[2], bgRGB[8:6] ); 


endmodule
