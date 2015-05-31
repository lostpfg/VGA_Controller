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

`include "globalVariables.v"

module  offsetHandler  ( reset, charSize, OffsetFlag, posVerStart, posVerEnd , posHorStart, posHorEnd );
 
    input                      reset;
    input             [2:0]    charSize;     /* Defines size of character  */
    input             [3:0]    OffsetFlag;   /* Defines offset increament { Left, Right, Up, Down }  */

    reg         [8:0]    horOffset;
    reg         [8:0]    verOffset;

    output      [8:0]    posVerStart;  
    output      [8:0]    posVerEnd;
    output      [8:0]    posHorStart;  /* [0,640] */
    output      [8:0]    posHorEnd;    /* [0,640] */

  initial 
    begin
      posVerStart <= ( ( `VDR - `VAL*`CHM )/2 );
      posVerEnd   <= ( ( `VDR - `VAL*`CHM )/2 ) + ( `VAL*`CHM - 1 );
      posHorStart <= ( ( `HDR - `HAL*`CHM )/2 );
      posHorEnd   <= ( ( `HDR - `HAL*`CHM )/2 ) + ( `HAL*`CHM - 1 );
    end

  always @ ( posedge reset )
    begin
      posVerStart <= ( ( `VDR - `VAL*`CHM )/2 );
      posVerEnd   <= ( ( `VDR - `VAL*`CHM )/2 ) + ( `VAL*`CHM - 1 );
      posHorStart <= ( ( `HDR - `HAL*`CHM )/2 );
      posHorEnd   <= ( ( `HDR - `HAL*`CHM )/2 ) + ( `HAL*`CHM - 1 );
    end

  always @ ( posedge OffsetFlag[3] )
    if ( posHorStart >= `HAL*`CHM + 1 ) /* Character Horizontal Start Offset can shift without beading */
      begin
        posHorStart <= posHorStart - `HAL*`CHM; 
        posHorEnd   <= ( posHorEnd >= `HAL*`CHM + 1 ) ? ( posHorEnd - `HAL*`CHM ) : ( `HDR - `HAL*`CHM + posHorEnd );
      end
    else /* Shift Character Horizontal Start Offset to right edge */
      begin
        posHorStart <= `HDR - `HAL*`CHM + posHorStart;
        posHorEnd   <= ( posHorEnd == `HAL*`CHM ) ? `HDR : ( posHorEnd - `HAL*`CHM );
      end

  always @ ( posedge OffsetFlag[1] )
    if ( posHorStart >= `VAL*`CHM + 1 ) /* Character Vertical Start Offset can shift without beading */
      begin
        posHorStart <= posHorStart - `VAL*`CHM; 
        posHorEnd   <= ( posHorEnd >= `VAL*`CHM + 1 ) ? ( posHorEnd - `VAL*`CHM ) :  ( `VDR - `VAL*`CHM + posHorEnd );
      end
    else /* Shift Character Vertical Start Offset to down edge */
      begin
        posHorStart <= `VDR - `VAL*`CHM + posHorStart;
        posHorEnd   <= ( posHorEnd == `VAL*`CHM ) ? `VDR : ( posHorEnd - `VAL*`CHM );
      end   

endmodule