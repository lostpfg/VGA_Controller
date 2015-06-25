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
  input   [2:0]   rgbEn;  /* Defines the color to be modified {Blue,Green,Red} */
  input           select; /* Defines the buss to be modified, charRGB(low) or bgRGB(high) */

  output  [8:0]   charRGB; /* Transfers the output color of the buss {Blue,Green,Red} */
  output  [8:0]   bgRGB;   /* Transfers the output color of the buss {Blue,Green,Red} */

  /*--------------------------------------------------------------------------*
  *  Use one copy of UpDownCounter3bit for every basic Color. The modifiable  *
  *  color is defined by the polarity of select signal and rgbEn buss.        *
  *---------------------------------------------------------------------------*/

  UpDownCounter3bit  charRedCnt   ( reset, ~select & rgbEn[0], charRGB[2:0] ); 
  UpDownCounter3bit  charGreenCnt ( reset, ~select & rgbEn[1], charRGB[5:3] ); 
  UpDownCounter3bit  charBlueCnt  ( reset, ~select & rgbEn[2], charRGB[8:6] ); 

  UpDownCounter3bit  bgRedCnt   ( reset, select & rgbEn[0], bgRGB[2:0] ); 
  UpDownCounter3bit  bgGreenCnt ( reset, select & rgbEn[1], bgRGB[5:3] ); 
  UpDownCounter3bit  bgBlueCnt  ( reset, select & rgbEn[2], bgRGB[8:6] ); 

endmodule
