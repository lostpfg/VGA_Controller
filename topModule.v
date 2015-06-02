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
  wire    [3:0]   opCode;
  wire    [3:0]   lowAddrOffset;
  wire    [7:0]   romByte;
  wire    [2:0]   userNum;  /* Tracks user Number input from keyboard */
  wire    [2:0]   charSize; /* Tracks user character size from keyboard */
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
  inputDecode       i2  ( pixelClk, reset, opCode, userNum, charSize, charRGB, bgRGB, charOffset, flashClk );
  dispController    i3  ( pixelClk, reset, charRGB, bgRGB, flashClk, charSize, charOffset, romByte, readEn, lowAddrOffset, vgaRGB, vgaHsync, vgaVsync );
  romController     i4  ( reset, readEn, userNum, lowAddrOffset, romByte ) ; 

endmodule
