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

module  charHandler  ( clock, reset, pixelCnt, lineCnt, rgbDepth, charSize, bitDisp, readEn, rowCnt, colCnt, vgaRGB );
    
    input                     clock;
    input                     reset;
    input           [9:0]     pixelCnt; /* Counter of pixels in a line */
    input           [8:0]     lineCnt;  /* Counter of lines per frame */
    input           [8:0]     rgbDepth; /* Depth of each Color */
    input           [2:0]     charSize; /* Defines size of character  */
    input                     bitDisp;

    output reg    [2:0]       rowCnt;    /* Counter of lines in active Region */
    output reg    [3:0]       colCnt;    /* Counter of pixels in active Region */

    reg                       colEn;
    reg                       rowEn;
    reg                       reqRow;  
    reg                       reqCol;

    output reg  [8:0]         vgaRGB;
    output reg                readEn;

    /* Active Display Regions -- Center of the Screen @ sizeof 16x8 */

    localparam HDT = 640;  /* Horizontal Display Time */
    localparam HAL = 8;    /* Horizontal Active Region Lenght */

    localparam VDT = 400;   /* Vertical Display Time */
    localparam VAL = 16;    /* Vertical Active Region Lenght */
    
    localparam CHM = 1;     /* Character Magnify */

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
          begin
            rowCnt  <= 3'd0;
            rowEn   <= 1'b0;
          end
        else if ( lineCnt == ( ( VDT - VAL*CHM )/2 ) + VAL*CHM  - 1 ) /* Reached the last line of Active Region, so reset the counter */
          begin
            rowCnt  <= 3'd0;    /* Clear Counter */
            rowEn   <= ~rowEn;  /* Set Flag to low */
          end
        else if ( ( lineCnt >= ( ( VDT - VAL*CHM )/2 ) -  1 ) && ( lineCnt < ( ( VDT - VAL*CHM )/2 ) + VAL*CHM - 1 ) ) /* Did not reach the last line, so increase the counter */
          begin
            rowCnt  <=  lineCnt - ( ( VDT - VAL*CHM )/2 - 1 );
            rowEn   <=  1'b1;
          end
    end

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
          reqRow   <= 1'b0;
        else if ( lineCnt == ( ( VDT - VAL*CHM )/2 ) + VAL*CHM - 2 )
          reqRow   <= ~reqRow;
        else if ( lineCnt == ( ( VDT - VAL*CHM )/2 ) -  2 )
          reqRow   <= ~reqRow;
    end

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
          begin
            colCnt  <= 2'd0;
            colEn   <= 1'b0;
          end
        else if ( pixelCnt == ( ( HDT - pos - HAL*CHM )/2 ) + HAL*CHM - 1 ) /* Reached the last pixel of Active Region, so reset the counter */
          begin
            colCnt  <= 2'd0;
            colEn   <= ~colEn;
          end
        else if ( ( pixelCnt >= ( ( HDT - pos - HAL*CHM )/2 ) - 1 ) && ( pixelCnt < ( ( HDT - pos - HAL*CHM )/2 ) + HAL*CHM - 1 ) )/* Did not reach the pixel line, so increase the counter */
          begin
            colCnt  <=  pixelCnt - ( ( HDT - HAL*CHM )/2 - 1 );
            colEn   <=  1'b1;
          end
    end

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
          reqCol   <= 1'b0;
        else if ( pixelCnt == ( ( HDT - HAL*CHM )/2 ) - 4 )
          reqCol   <= 1'b1;
        else
          reqCol   <= 1'b0;
    end

    assign readEn = reqRow && reqCol;

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
          vgaRGB <=  9'd0; /* Clear RGB Buffer */
        else if ( colEn && rowEn && bitDisp ) /* Inside Active Region and Have a pixel to display */
          vgaRGB  <= { rgbDepth[8:6], rgbDepth[5:3], rgbDepth[2:0] }; /* Pass each color's depth to output's buffer */
        else 
          vgaRGB <=  9'd0;   /* Outside Display Region everything is black and nothing to display */
    end

    
endmodule