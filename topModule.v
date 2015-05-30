/*----- Module Overview --------------------------------------*
*                                                             *
*                      _________________                      *
*                                                             *
*                     |                 |                     * 
*  clock    ------->  |                 | --/09--> vgaRGB     *
*  ps2Clk   ------->  |    topModule    | -------> vgaVsync   *
*  reset    ------->  |                 | -------> vgaHsync   *
*  ps2Data  ------->  |                 |                     * 
*                      _________________                      *
*                                                             *
*-------------------------------------------------------------*/

module topModule ( clock, reset, ps2Clk, ps2Data, vgaRGB, vgaHsync, vgaVsync );

  input           clock;
  input           reset;
  input           ps2Clk; 
  input           ps2Data;

  wire            pixelClk;
  wire    [3:0]   ps2OutCode;
  wire    [3:0]   addrOffset;
  wire    [7:0]   romByte;
  wire    [2:0]   userNum;
  wire    [2:0]   charSize;
  wire    [3:0]	  charOffset; 
  wire    [8:0]   charRGB;
  wire    [8:0]   bgRGB;
  wire            flashClk;
  wire 				    readEn;

  output  [8:0]   vgaRGB;
  output          vgaHsync;
  output          vgaVsync;
  
  pixelClk          i0  ( clock, reset, pixelClk );
  kbdController     i1  ( pixelClk, reset, ps2Clk, ps2Data, ps2OutCode );
  inputDecode       i2  ( pixelClk, reset, ps2OutCode, userNum, charSize, charRGB, bgRGB, upOffset, downOffset, leftOffset, rightOffset, flashClk );
  dispController    i3  ( pixelClk, reset, charRGB, bgRGB, flashClk, charSize, upOffset, downOffset, leftOffset, rightOffset, romByte, readEn, addrOffset, vgaRGB, vgaHsync, vgaVsync );
  romController     i4  ( reset, readEn, userNum, addrOffset, romByte ) ; 

endmodule
