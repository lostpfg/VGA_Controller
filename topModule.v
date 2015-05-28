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
  wire    [3:0]   ps2OutCode;
  wire    [3:0]   addrOffset;
  wire    [7:0]   romByte;
  wire    [2:0]   userNum;  /* Tracks user Number input from keyboard */
  wire    [2:0]   charSize; /* Tracks user character size from keyboard */
  
  wire       		upOffset; 
  wire       		downOffset;
  wire       		leftOffset;
  wire    		   rightOffset;
  
  wire    [8:0]   charRgbDepth;
  wire    [8:0]   BkRgbDepth;
  wire            flashClk;
  wire 				readEn;

  output  [8:0]   vgaRGB;
  output          vgaHsync;
  output          vgaVsync;
  
  pixelClk          i0  ( boardClk, reset, pixelClk );
  kbdController     i1  ( pixelClk, reset, ps2Clk, ps2Data, ps2OutCode );
  inputDecode       i2  ( pixelClk, reset, ps2OutCode, userNum, charSize, charRgbDepth, BkRgbDepth, upOffset, downOffset, leftOffset, rightOffset, flashClk );
  dispController    i3  ( pixelClk, reset, charRgbDepth, BkRgbDepth, flashClk, charSize, upOffset, downOffset, leftOffset, rightOffset, romByte, readEn, addrOffset, vgaRGB, vgaHsync, vgaVsync );
  romController     i4  ( reset, readEn, userNum, addrOffset, romByte ) ; 

endmodule
