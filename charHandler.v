/*----- Module Overview ------------------------------------------------*
*                                                                       *
*                         ________________________                      *
*                                                                       *
*                        |                        |                     * 
*  clock       ------->  |                        |                     * 
*  reset       ------->  |                        |                     * 
*  pixelCnt    --/10-->  |                        | -------> readEn     *
*  lineCnt     --/09-->  |                        | --/04--> rowCnt     *
*  rgbDepth    --/09-->  |                        | --/03--> colCnt     * 
*  bgRGB       --/09-->  |                        | --/09--> vgaRGB     *
*  bgRGB       --/09-->  |      charHandler       |                     *
*  posVerStart --/10-->  |                        |                     *
*  posVerEnd   --/09-->  |                        |                     *
*  posHorStart --/09-->  |                        |                     *
*  posHorEnd   --/09-->  |                        |                     *
*  bitDisp     ------->  |                        |                     *
*                        |                        |                     * 
*                         ________________________                      *
*                                                                       *
*                                                                       *
*-----------------------------------------------------------------------*/

module  charHandler  (  clock, 
                        reset, 
                        pixelCnt, 
                        lineCnt, 
                        charRGB, 
                        bgRGB, 
                        flashClk, 
                        posVerStart, 
                        posVerEnd , 
                        posHorStart, 
                        posHorEnd, 
                        bitDisp, 
                        readEn, 
                        rowCnt, 
                        colCnt, 
                        vgaRGB 
                      );

    input                        clock;
    input                        reset;
    input                        flashClk;     /* Tracks the flash clock edge */
    input            [9:0]       pixelCnt;     /* Counter of pixels in a line of the active region */
    input            [8:0]       lineCnt;      /* Counter of lines in a frame of active region */
    input            [8:0]       charRGB;      /* Tracks the depth of each Color of the drawable object */
    input            [8:0]       bgRGB;        /* Tracks the depth of each Color of the background */
    input                        bitDisp;      /* Tracks wether a bit of the drawable object is displayed or not */
    input            [9:0]       posVerStart;
    input            [8:0]       posVerEnd;
    input            [8:0]       posHorStart;
    input            [8:0]       posHorEnd;
   
    output reg       [8:0]       vgaRGB;       /* !!! Posibly no need to be a Reg !!!  */
    output                       readEn;       /* ......  */
    output reg       [3:0]       rowCnt;       /* Counter of lines in active Region */
    output reg       [2:0]       colCnt;       /* Counter of pixels in active Region */

    reg                          colEn;        /* ......  */
    reg                          rowEn;        /* ......  */
    reg                          reqRow;       /* ......  */
    reg                          reqCol;       /* ......  */

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
          begin
            colCnt  <= 3'd0;
            colEn   <= 1'b0;
          end
        else if ( posHorStart < posHorEnd ) /* Displayed region is inside Active region bound */
          if ( pixelCnt == posHorEnd ) /* Reached the last pixel of Active Region, so reset the counter */
            begin
              colCnt  <= 3'd0;
              colEn   <= 1'b0;
            end
          else if ( ( pixelCnt >= ( posHorStart - 1 ) ) && ( pixelCnt <= ( posHorEnd - 1 ) ) ) /* Did not reach the pixel line, so increase the counter */
            begin
              colCnt  <=  pixelCnt - ( posHorStart - 1 );
              colEn   <=  1'b1;
            end
        else /* Displayed region needs beading */
          if ( pixelCnt == posHorStart ) /* Reached the last pixel of Active Region, so reset the counter */
            begin
              colCnt  <= 3'd0;
              colEn   <= 1'b0;
            end
          else if ( ( pixelCnt <= posHorEnd - 1 ) || ( pixelCnt >= posHorStart - 1 ) )/* Did not reach the pixel line, so increase the counter */
            begin
              colCnt  <=  ( pixelCnt <= posHorEnd - 1 ) ? ( pixelCnt - ( posHorStart + 1 ) ) : ( pixelCnt - ( posHorStart - 1 ) ) ;
              colEn   <=  1'b1;
            end
    end

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
          begin
            rowCnt  <= 4'd0;
            rowEn   <= 1'b0;
          end
        else if ( posVerStart < posVerEnd ) /* Displayed region is inside Active region bound */
          if ( lineCnt == posVerEnd ) /* Reached the last pixel of Active Region, so reset the counter */
            begin
              rowCnt  <= 4'd0;
              rowEn   <= 1'b0;
            end
          else if ( ( lineCnt >= ( posVerStart - 1 ) ) && ( lineCnt <= ( posVerEnd - 1 ) ) )/* Did not reach the pixel line, so increase the counter */
            begin
              rowCnt  <=  lineCnt - ( posVerStart - 1 );
              rowEn   <=  1'b1;
            end
        else /* Displayed region needs beading */
          if ( lineCnt == posVerStart ) /* Reached the last pixel of Active Region, so reset the counter */
            begin
              rowCnt  <= 4'd0;
              rowEn   <= 1'b0;
            end
          else if ( ( lineCnt <= posVerEnd - 1 ) || ( lineCnt >= posVerStart - 1 ) )/* Did not reach the pixel line, so increase the counter */
            begin
              rowCnt  <=  ( lineCnt <= posVerEnd - 1 ) ? ( lineCnt - ( posVerStart + 1 ) ) : ( lineCnt - ( posVerStart - 1 ) ) ;
              rowEn   <=  1'b1;
            end
    end

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
          reqRow   <= 1'b0;
        else if ( lineCnt == ( posVerStart - 1 ) )
          reqRow   <= 1'b0;
        else if ( lineCnt == ( posVerStart - 2 ) )
          reqRow   <= 1'b1;
    end

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
          reqCol   <= 1'b0;
        else if ( pixelCnt == ( posHorStart - 2 ) )
          reqCol   <= ~reqCol;
        else if ( pixelCnt == ( posHorStart - 1 ) )
          reqCol   <= ~reqCol;
    end
   
    assign readEn = reqCol && reqRow;

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
          vgaRGB <=  9'd0; /* Clear RGB Buffer */
        else if ( rowEn && colEn && bitDisp && ~flashClk ) /* Inside Active Region and Have a pixel to display */
          vgaRGB  <= { charRGB[8:6], charRGB[5:3], charRGB[2:0] }; /* Pass each color's depth to output's buffer */
        else 
          vgaRGB <=  { bgRGB[8:6], bgRGB[5:3], bgRGB[2:0] };   /* Outside Display Region everything is black and nothing to display */
    end

endmodule