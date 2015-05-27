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

module  charHandler  ( clock, reset, pixelCnt, lineCnt, charRgbDepth, bkRgbDepth, flashClk, charSize, upOffset, bitDisp, readEn, rowCnt, colCnt, vgaRGB );
 
    input                     clock;
    input                     reset;
	  input							        flashClk;
    input         [9:0]       pixelCnt; /* Counter of pixels in a line */
    input         [8:0]       lineCnt;  /* Counter of lines per frame */
    input         [8:0]       charRgbDepth; /* Depth of each Color */
	  input         [8:0]       bkRgbDepth; /* Depth of each Color */
    input         [2:0]       charSize; /* Defines size of character  */
    input                     bitDisp;
	  input         [9:0]       upOffset;

    reg                       colEn;
    reg                       rowEn;
    reg                       reqRow;  
    reg                       reqCol;

    output reg    [8:0]       vgaRGB;
    output                    readEn;
    output reg    [3:0]       rowCnt;    /* Counter of lines in active Region */
    output reg    [2:0]       colCnt;    /* Counter of pixels in active Region */

    /* Active Display Regions -- Center of the Screen @ sizeof 16x8 */

    localparam HDT = 640;  /* Horizontal Display Time */
    localparam HAL = 8;    /* Horizontal Active Region Lenght */

    localparam VDT = 400;   /* Vertical Display Time */
    localparam VAL = 16;    /* Vertical Active Region Lenght */
    
    localparam CHM = 1;     /* Character Magnify */

    assign posVerStart = ( ( VDT - VAL*CHM )/2 );
    assign posVerEnd   = ( ( VDT - VAL*CHM )/2 ) + VAL*CHM;

    assign posHorStart = ( ( VDT - VAL*CHM )/2 );
    assign posHorEnd   = ( ( VDT - VAL*CHM )/2 ) + VAL*CHM;

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
          begin
            rowCnt  <= 4'd0;
            rowEn   <= 1'b0;
          end
        else if ( lineCnt == posVerEnd - 1 ) /* Reached the last line of Active Region, so reset the counter */
          begin
            rowCnt  <= 4'd0;    /* Clear Counter */
            rowEn   <= ~rowEn;  /* Set Flag to low */
          end
        else if ( ( lineCnt >= ( posVerStart -  1 ) && ( lineCnt < ( posVerEnd - 1 ) /* Did not reach the last line, so increase the counter */
          begin
            rowCnt  <=  lineCnt - ( posVerStart - 1 );
            rowEn   <=  1'b1;
          end
    end

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
          begin
            colCnt  <= 3'd0;
            colEn   <= 1'b0;
          end
        else if ( pixelCnt == ( posHorEnd - 1 ) /* Reached the last pixel of Active Region, so reset the counter */
          begin
            colCnt  <= 3'd0;
            colEn   <= ~colEn;
          end
        else if ( ( pixelCnt >= ( posHorStart - 1 ) && ( pixelCnt < ( posHorEnd - 1 ) )/* Did not reach the pixel line, so increase the counter */
          begin
            colCnt  <=  pixelCnt - ( posHorStart - 1 );
            colEn   <=  1'b1;
          end
    end

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
          reqRow   <= 1'b0;
        else if ( lineCnt == ( posVerEnd - 1 )
          reqRow   <= ~reqRow;
        else if ( lineCnt == ( posVerStart - 2 )
          reqRow   <= ~reqRow;
    end

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
          reqCol   <= 1'b0;
        else if ( pixelCnt == ( posVerStart - 2 )
          reqCol   <= ~reqCol;
        else if ( pixelCnt == ( posVerStart - 1 )
          reqCol   <= ~reqCol;
    end

    assign readEn = reqCol && reqRow;

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
          vgaRGB <=  9'd0; /* Clear RGB Buffer */
        else if ( rowEn && colEn && bitDisp && ~flashClk ) /* Inside Active Region and Have a pixel to display */
          vgaRGB  <= { charRgbDepth[8:6], charRgbDepth[5:3], charRgbDepth[2:0] }; /* Pass each color's depth to output's buffer */
        else 
          vgaRGB <=  { bkRgbDepth[8:6], bkRgbDepth[5:3], bkRgbDepth[2:0] };   /* Outside Display Region everything is black and nothing to display */
    end

endmodule