/*----- Module Overview ------------------------------------------------*
*                                                                       *
*                         ________________________                      *
*                                                                       *
*                        |                        |                     * 
*  clock       ------->  |                        |                     * 
*  reset       ------->  |                        |                     * 
*  pixelCnt    --/10-->  |                        | -------> readEn     *
*  lineCnt     --/09-->  |                        | -------> rowCnt     *
*  rgbDepth    --/09-->  |      charHandler       | -------> colCnt     * 
*  charSize    ------->  |                        | --/09--> vgaRGB     *
*  upOffset    ------->  |                        |                     * 
*  downOffset  ------->  |                        |                     * 
*  leftOffset  ------->  |                        |                     * 
*  rightOffset ------->  |                        |                     * 
*  bitDisp     ------->  |                        |                     *
*                         ________________________                      *
*                                                                       *
*                                                                       *
*-----------------------------------------------------------------------*/

`include "globalVariables.v"


module  charHandler  ( clock, reset, pixelCnt, lineCnt, charRGB, bgRGB, flashClk, posVerStart, posVerEnd , posHorStart,posHorEnd, bitDisp, readEn, rowCnt, colCnt, vgaRGB );

    input                     clock;
    input                     reset;
    input                     flashClk;   /* Tracks the flash clock edge */
    input         [9:0]       pixelCnt;   /* Counter of pixels in a line of the active region */
    input         [8:0]       lineCnt;    /* Counter of lines in a frame of active region */
    input         [8:0]       charRGB;    /* Tracks the depth of each Color of the drawable object */
    input         [8:0]       bgRGB;      /* Tracks the depth of each Color of the background */
    input                     bitDisp;    /* Tracks wether a bit of the drawable object is displayed or not */
    input         [8:0]       posVerStart;
    input         [8:0]       posVerEnd;
    input         [9:0]       posHorStart;
    input         [9:0]       posHorEnd;

    reg                       colEn;        /* ......  */
    reg                       rowEn;        /* ......  */
    reg                       reqRow;       /* ......  */
    reg                       reqCol;       /* ......  */
   
    output reg    [8:0]       vgaRGB;       /* ......  */
    output                    readEn;       /* ......  */
    output reg    [3:0]       rowCnt;       /* Counter of lines in active Region */
    output reg    [2:0]       colCnt;       /* Counter of pixels in active Region */
  

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
          begin
            rowCnt  <= 4'd0;
            rowEn   <= 1'b0;
          end
        else if ( posVerStart < posVerEnd )
         begin
          if ( lineCnt == posVerEnd ) 
           begin
            rowCnt  <= 4'd0;    
            rowEn   <= 1'b0;  
           end
          else if ( ( lineCnt >= ( posVerStart -  1 ) ) && ( lineCnt <= ( posVerEnd - 1 ) ) )
           begin
            rowCnt  <=  lineCnt - ( posVerStart - 1 );
            rowEn   <=  1'b1;
           end
        end
       else
        begin
          if ( lineCnt == posVerEnd || lineCnt == `VDR ) /* Reached the last pixel of Active Region, so reset the counter */
              rowEn   <= 1'b0;
          else if ( ( pixelCnt <= posVerEnd - 1 ) || ( lineCnt >= posVerStart - 1 ) )/* Did not reach the pixel line, so increase the counter */
            begin
              rowCnt  <=  ( lineCnt <= posVerEnd - 1 ) ? ( `VDR - posVerEnd + lineCnt ) : ( lineCnt - ( posVerStart - 1 ) ) ;
              rowEn   <=  1'b1;
            end
          if ( pixelCnt == `VDR )
            rowCnt  <= 4'd0;
        end
    end
    
    always @ ( posedge clock or posedge reset ) begin
      if ( reset )
        begin
          colCnt  <= 3'd0;
          colEn   <= 1'b0;
        end
      else if  ( pixelCnt == posHorEnd || pixelCnt == `HDR )
        colEn   <= 1'b0;
      else if ( posHorStart < posHorEnd ) /* Displayed region is inside Active region bound */
        begin
          if ( pixelCnt == posHorEnd ) /* Reached the last pixel of Active Region, so reset the counter */
            colCnt  <= 3'd0;
          else if ( ( pixelCnt >= posHorStart - 1 ) && ( pixelCnt <= posHorEnd - 1 ) ) /* Did not reach the pixel line, so increase the counter */
            begin
              colCnt  <=  pixelCnt - ( posHorStart - 1 );
              colEn   <=  1'b1;
            end
        end
      else /* Displayed region needs beading */
        begin
          if ( pixelCnt == `HDR )
            colCnt  <= 3'd0;
          else if ( ( pixelCnt <= posHorEnd - 1 ) || ( pixelCnt >= posHorStart - 1 ) )
            begin
              colCnt  <=  ( pixelCnt <= posHorEnd - 1 ) ? ( `HDR - posHorEnd + pixelCnt ) : ( pixelCnt - ( posHorStart - 1 ) ) ;
              colEn   <=  1'b1;
            end
        end
    end

    always @ ( posedge clock or posedge reset ) begin
      if ( reset )
        reqRow   <= 1'b0;
      else if ( posVerStart < posVerEnd )
        reqRow <= ( lineCnt == posVerStart - 2 ) ? 1'b1 : 1'b0 ;
      else
        reqRow <= ( lineCnt == `VDR - 2 ) ? 1'b1 : 1'b0 ;
    end

    always @ ( posedge clock or posedge reset ) begin
      if ( reset )
        reqCol   <= 1'b0;
      else if ( posHorStart < posHorEnd )
        reqCol <= ( pixelCnt == posHorStart - 2 ) ? 1'b1 : 1'b0 ;
      else
        reqCol <= ( pixelCnt == `HDR - 2 ) ? 1'b1 : 1'b0 ;
    end
   
    assign readEn = reqCol && reqRow;

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
          vgaRGB <=  9'd0; /* Clear RGB Buffer */
        else if ( rowEn && colEn && bitDisp && ~flashClk ) /* Inside Active Region and Have a pixel to display */
          vgaRGB  <= { 3'd7, 3'd0, 3'd7 }; /* Pass each color's depth to output's buffer */
        else 
          vgaRGB <=  { 3'd7, 3'd7, 3'd7 };   /* Outside Display Region everything is black and nothing to display */
    end

endmodule
