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

`include "globalVariables.v"

module  dispController  ( clock, 
                          reset,
                          charRgbDepth,
                          bkRgbDepth,
                          flashClk,
                          moveSpeed,
                          charOffset,
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
  input         [3:0]     moveSpeed;
  input         [3:0]     charOffset;
  input         [7:0]     romByte;

  wire                    bitDisp;
  wire                    hSync;
  wire                    vSync;
  wire          [9:0]     pixelCnt;
  wire          [8:0]     lineCnt;
  wire                    compBlank;
  wire          [2:0]     byteOffset;
  wire          [8:0]     charRGB;
  wire          [8:0]     posVerStart;
  wire          [8:0]     posVerEnd;
  wire          [9:0]     posHorStart;
  wire          [9:0]     posHorEnd;
  
  output        [3:0]     addOffset;
  output                  readEn;
  output  reg             vgaVsync;
  output  reg             vgaHsync;
  output  reg   [8:0]     vgaRGB;
  
  assign bitDisp = romByte[( `HAL - 1 ) - byteOffset];
  
  vgaHandler     i0  ( clock, reset, hSync, pixelCnt, vSync, lineCnt, compBlank );
  charHandler    i1  ( clock, reset, pixelCnt, lineCnt, charRgbDepth, bkRgbDepth, flashClk, posVerStart, posVerEnd , posHorStart, posHorEnd, bitDisp, readEn, addOffset, byteOffset, charRGB );
  offsetHandler  i2  ( clock, reset, moveSpeed, charOffset, posVerStart, posVerEnd , posHorStart, posHorEnd );

 always @ ( posedge clock or posedge reset ) begin
    if ( reset ) 
      vgaRGB  <= 9'd0;
    else
      begin
        vgaHsync  <=  hSync;
        vgaVsync  <=  vSync;  
        vgaRGB    <=  ( compBlank ) ? 9'h0 : charRGB;
      end
  end

endmodule