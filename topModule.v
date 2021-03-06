/*----- Module Overview --------------------------------------*
*                                                             *
*                      _________________                      *
*                                                             *
*                     |                 |                     *
*  clock    ------->  |                 | --/09--> vgaRGB     *
*  reset    ------->  |    topModule    | -------> vgaVsync   *
*  ps2Clk   ------->  |                 | -------> vgaHsync   *
*  ps2Data  ------->  |                 |                     *
*                     |                 |                     *
*                      _________________                      *
*                                                             *
*-------------------------------------------------------------*/

module topModule ( clock, reset, ps2Clk, ps2Data, vgaRGB, vgaHsync, vgaVsync );

  input           clock;
  input           reset;
  input           ps2Clk; 
  input           ps2Data;

  wire            pixelClk;  
  wire    [3:0]   opCode;
  wire    [3:0]   lowAddrOffset;
  wire    [7:0]   romByte;
  wire    [2:0]   highAddrOffset;
  wire    [2:0]   moveSpeed;
  wire    [3:0]   charOffset; 
  wire    [8:0]   charRGB;
  wire    [8:0]   bgRGB;
  wire            flashClk;
  wire            readEn;

  output  [8:0]   vgaRGB;
  output          vgaHsync;
  output          vgaVsync;
  
  pixelClk          i0  ( clock, reset, pixelClk );
  kbdController     i1  ( pixelClk, reset, ps2Clk, ps2Data, opCode );
  inputDecode       i2  ( pixelClk, reset, opCode, highAddrOffset, moveSpeed, charRGB, bgRGB, charOffset, flashClk );
  dispController    i3  ( pixelClk, reset, charRGB, bgRGB, flashClk, moveSpeed, charOffset, romByte, readEn, lowAddrOffset, vgaRGB, vgaHsync, vgaVsync );
  romController     i4  ( pixelClk, reset, readEn, highAddrOffset, lowAddrOffset, romByte ) ; 

endmodule
