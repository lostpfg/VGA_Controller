/*----- Module Overview ---------------------------------------------*
*                                                                    *
*                         _____________________                      *
*                                                                    *
*                        |                     |                     * 
*  clock       ------->  |                     | --/09--> vgaRGB     *
*  reset       ------->  |                     | -------> vgaHsync   *
*  charRGB     --/09-->  |                     | -------> vgaVsync   *
*  bgRGB       --/09-->  |   dispController    | --/04--> addOffset  *
*  flashClk    ------->  |                     |                     *
*  charSize    --/04-->  |                     |                     *
*  charOffset  --/04-->  |                     |                     *
*  romByte     --/08-->  |                     |                     *
*                        |                     |                     * 
*                         _____________________                      *
*                                                                    *
*--------------------------------------------------------------------*/

`include "globalVariables.v"

module  dispController  ( clock, 
                          reset,
                          charRGB,
                          bgRGB,
                          flashClk,
                          charSize,
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
  input         [8:0]     charRGB;
  input         [8:0]     bgRGB;
  input         [3:0]     charSize;
  input         [3:0]     charOffset;
  input         [7:0]     romByte;
  
  output        [3:0]     addOffset;
  output                  readEn;
  output  reg             vgaVsync;
  output  reg             vgaHsync;
  output  reg   [8:0]     vgaRGB;

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
  wire          [8:0]     posHorStart;
  wire          [8:0]     posHorEnd;
  
  assign bitDisp = romByte[ ( `HAL*CHM - 1 ) - byteOffset ];
  
  vgaHandler    i0  ( clock, reset, hSync, pixelCnt, vSync, lineCnt, compBlank );
  charHandler   i1  ( clock, reset, pixelCnt, lineCnt, charRGB, bgRGB, flashClk, posVerStart, posVerEnd , posHorStart, posHorEnd, bitDisp, readEn, addOffset, byteOffset, outRGB );
  offsetHandler i2  ( clock, reset, charSize, charOffset, posVerStart, posVerEnd , posHorStart, posHorEnd );

 always @ ( posedge clock or posedge reset ) begin
    if ( reset ) 
      vgaRGB  <= 9'd0; /* Clear Local Register */
    else 
      if ( compBlank ) /* Make Screen Black */
        begin
          vgaHsync  <=  hSync;
          vgaVsync  <=  vSync;      
          vgaRGB    <=  9'd0; /* Clear Local Register */
        end
      else
        begin
          vgaHsync  <=  hSync;
          vgaVsync  <=  vSync;
          vgaRGB    <=  outRGB;
        end
  end

endmodule