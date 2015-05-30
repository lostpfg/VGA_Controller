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
 
    input                      reset;
    input             [2:0]    charSize;     /* Defines size of character  */
    input             [3:0]    OffsetFlag;   /* Defines offset increament { Left, Right, Up, Down }  */

    reg         [8:0]    horOffset;
    reg         [8:0]    verOffset;

    output      [8:0]    posVerStart;  
    output      [8:0]    posVerEnd;
    output      [8:0]    posHorStart;  /* [-6,640] */
    output      [8:0]    posHorEnd;    /* [2,648] */

  /* Active Display Region -- Center of the Screen @ sizeof 16x8 */

  localparam HDR = 640;  /* Horizontal Display Region */
  localparam HAL = 8;    /* Horizontal Active Region Lenght */

  localparam VDR = 400;   /* Vertical Display Region */
  localparam VAL = 16;    /* Vertical Active Region Lenght */
  
  localparam CHM = 1;     /* Character Magnify */
  
  initial 
    begin
      posVerStart <= ( ( VDR - VAL*CHM )/2 );
      posVerEnd   <= ( ( VDR - VAL*CHM )/2 ) + ( VAL*CHM - 1 );
      posHorStart <= ( ( HDR - HAL*CHM )/2 );
      posHorEnd   <= ( ( HDR - HAL*CHM )/2 ) + ( HAL*CHM - 1 );
    end

  always @ ( posedge reset )
    begin
      posVerStart <= ( ( VDR - VAL*CHM )/2 );
      posVerEnd   <= ( ( VDR - VAL*CHM )/2 ) + ( VAL*CHM - 1 );
      posHorStart <= ( ( HDR - HAL*CHM )/2 );
      posHorEnd   <= ( ( HDR - HAL*CHM )/2 ) + ( HAL*CHM - 1 );
    end

  always @ ( posedge OffsetFlag[0] )
    if ( posHorStart >= HAL*CHM + 1 ) /* Character Start can shift without beading */
      begin
        posHorStart <= posHorStart - HAL*CHM; 
        posHorEnd   <= ( posHorEnd >= HAL*CHM + 1 ) ? posHorEnd - HAL*CHM :  HDR - HAL*CHM + posHorEnd;
      end
    else /* Shift Character Start to right edge */
      begin
        posHorStart <= HDR - HAL*CHM + posHorStart;
        posHorEnd   <= ( posHorEnd == HAL*CHM ) ? HDR : posHorEnd - HAL*CHM );
      end
     
endmodule