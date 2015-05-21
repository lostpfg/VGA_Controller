/*----- Module Overview --------------------------------------*
*                                                             *
*                      _________________                      *
*                                                             *
*                     |                 |                     * 
*  boardClk ------->  |                 | --/09--> vgaRGB     *
*  ps2Clk   ------->  |    topModule    | -------> vgaVsync   *
*  reset    ------->  |                 | -------> vgaHsync   *
*  ps2Data  ------->  |                 |                     * 
*                      _________________                      *
*                                                             *
*-------------------------------------------------------------*/

module topModule ( boardClk, reset, ps2Clk, ps2Data, vgaRGB, vgaHsync, vgaVsync );

  input           boardClk;
  input           reset;
  input           ps2Clk; 
  input           ps2Data;

  wire            pixelClk;  
  wire    [3:0]   addrOffset;
  wire    [7:0]   romByte;
  wire    [2:0]   userNum;  /* Tracks user Number input from keyboard */
  wire    [2:0]   charSize; /* Tracks user character size from keyboard */
  wire    [2:0]   rgbIncEn; /* Tracks user character color from keyboard */
  wire    [2:0]   upOffset; 
  wire    [2:0]   downOffset;
  wire    [2:0]   leftOffset;
  wire    [2:0]   rightOffset;
  wire    [8:0]   rgbDepth;
  wire            enFlash;
  
  output  [8:0]   vgaRGB;
  output          vgaHsync;
  output          vgaVsync;

  pixelClk          i0  ( boardClk, reset, pixelClk );
  kbdController     i1  ( pixelClk, reset, ps2Clk, ps2Data, ps2OutCode );
  inputDecode       i2  ( pixelClk, reset, ps2OutCode, userNum, charSize, rgbIncEn, upOffset, downOffset, leftOffset, rightOffset, enFlash );
  colorController   i3  ( reset, rgbIncEn, rgbDepth );
  dispController    i4  ( pixelClk, reset, rgbDepth, charSize, upOffset, downOffset, leftOffset, rightOffset, romByte, addrOffset, vgaRGB, vgaHsync, vgaVsync );
  charRom           i5  ( readEn, {userNum, addrOffset}, romByte );

endmodule
