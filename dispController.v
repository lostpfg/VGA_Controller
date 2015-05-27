/*----- Module Overview ---------------------------------------------*
*                                                                    *
*                         _____________________                      *
*                                                                    *
*                        |                     |                     * 
*  clock       ------->  |                     | --/09--> vgaRGB     *
*  reset       ------->  |   dispController    | -------> readEn     *
*  rgbDepth    --/09-->  |                     | -------> addOffset  *
*  charSize    --/09-->  |                     | -------> vgaHsync   *
*  upOffset    --/09-->  |                     | -------> vgaVsync   *
*  downOffset  --/09-->  |                     |                     *
*  leftOffset  --/09-->  |                     |                     *
*  rightOffset --/09-->  |                     |                     *
*  romByte     --/08-->  |                     |                     *
*                        |                     |                     *
*                         _____________________                      *
*                                                                    *
*--------------------------------------------------------------------*/

module  dispController  ( clock, 
                          reset,
                          charRgbDepth,
								          bkRgbDepth,
								          flashClk,
                          charSize,
                          upOffset,
                          downOffset,
                          leftOffset,
                          rightOffset,
                          romByte,
                          readEn,
                          addOffset,
                          vgaRGB, 
                          vgaHsync, 
                          vgaVsync 
                        );
  input                   clock;
  input                   reset;
  input                   flashClk;
  input         [8:0]     charRgbDepth;
  input         [8:0]     bkRgbDepth;
  input         [3:0]     charSize;
  input         [9:0]     upOffset;
  input         [2:0]     downOffset;
  input         [2:0]     leftOffset;
  input         [2:0]     rightOffset;
  input         [7:0]     romByte;

  wire                    bitDisp;
  wire                    hSync;
  wire                    vSync;
  wire          [9:0]     pixelCnt;
  wire          [8:0]     lineCnt;
  wire                    compBlank;
  wire			 [2:0]     byteOffset;
  wire 			 [8:0]     charRGB;
  
  output        [3:0]     addOffset;
  output                  readEn;
  output  reg             vgaVsync;
  output  reg             vgaHsync;
  output  reg   [8:0]     vgaRGB;

  assign bitDisp = romByte[7-byteOffset];
  
  vgaHandler         i0       ( clock, reset, hSync, pixelCnt, vSync, lineCnt, compBlank );
  charHandler        i1       ( clock, reset, pixelCnt, lineCnt, charRgbDepth, bkRgbDepth, flashClk, charSize, upOffset, bitDisp, readEn, addOffset, byteOffset, charRGB );

  always @ ( posedge clock or posedge reset ) begin
    if ( reset ) 
      vgaRGB  <= 9'd0; /* Clear Local Buffer */
    else 
      if ( compBlank ) /* Make Screen Black */
        begin
          vgaHsync  <=  hSync;
          vgaVsync  <=  vSync;      
          vgaRGB    <=  9'd0; /* Clear Local Buffer */
        end
      else
        begin
          vgaHsync  <=  hSync;
          vgaVsync  <=  vSync;
          vgaRGB    <=  charRGB;
        end
  end

endmodule