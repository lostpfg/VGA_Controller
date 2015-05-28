/*----- Module Overview ------------------------------------------------*
*                                                                       *
*                         ________________________                      *
*                                                                       *
*                        |                        |                     * 
*  reset       ------->  |                        |                     * 
*  charSize    ------->  |                        | -------> readEn     *
*  OffsetFlag  --/04-->  |                        | -------> rowCnt     *
*                        |      offsetHandler     | -------> colCnt     * 
*                        |                        | --/09--> vgaRGB     *
*                        |                        |                     *
*                        |                        |                     *  
*                         ________________________                      *
*                                                                       *
*                                                                       *
*-----------------------------------------------------------------------*/

module  offsetHandler  ( reset, charSize, OffsetFlag, posVerStart, posVerEnd , posHorStart, posHorEnd );
 
    input                     reset;
    input         [2:0]       charSize;     /* Defines size of character  */
    input         [3:0]       OffsetFlag;   /* Defines offset increament { Right, Left, Down, Up }  */

    reg     signed   [8:0]    horOffset;
    reg     signed   [8:0]    verOffset;

    output           [8:0]    posVerStart;
    output           [8:0]    posVerEnd;
    output           [8:0]    posHorStart;
    output           [8:0]    posHorEnd;

  /* Active Display Region -- Center of the Screen @ sizeof 16x8 */

  localparam HDT = 640;  /* Horizontal Display Time */
  localparam HAL = 8;    /* Horizontal Active Region Lenght */

  localparam VDT = 400;   /* Vertical Display Time */
  localparam VAL = 16;    /* Vertical Active Region Lenght */
  
  localparam CHM = 1;     /* Character Magnify */
   
  assign   posVerStart = ( ( VDT - VAL*CHM )/2 ) + verOffset;
  assign   posVerEnd   = posVerStart + VAL*CHM;
  assign   posHorStart = ( ( HDT - HAL*CHM )/2 ) + horOffset;
  assign   posHorEnd   = posHorStart + HAL*CHM;

  always @ ( posedge reset )
    begin
      horOffset <= 9'd0;
      verOffset <= 9'd0;
    end

  always @ ( posedge OffsetFlag[0] )
    if ( posHorStart >=  HAL*CHM )
      horOffset <= horOffset - HAL*CHM;
   
  always @ ( posedge OffsetFlag[1] ) begin
    if ( posHorEnd <=  ( ( HDT  - HAL*CHM ) - 1 ) ) 
      horOffset <= horOffset + HAL*CHM;
  end

  always @ ( posedge OffsetFlag[2] ) begin
    if ( posVerStart >=  VAL*CHM )
      verOffset <= verOffset - VAL*CHM;
  end

  always @ ( posedge OffsetFlag[3] ) begin
    if ( posVerEnd <=  ( ( VDT  - VAL*CHM ) - 1 ) ) 
      verOffset <= verOffset + VAL*CHM;
  end
   

  
endmodule
