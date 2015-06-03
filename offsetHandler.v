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
 
    input                reset;
    input       [2:0]    charSize;     /* Defines size of character  */
    input       [3:0]    OffsetFlag;   /* Defines offset increament { Right, Left, Down, Up }  */
   
    output  reg    [8:0]    posVerStart;  
    output  reg    [8:0]    posVerEnd;
    output  reg    [9:0]    posHorStart;  /* [0,640] */
    output  reg    [9:0]    posHorEnd;    /* [0,640] */

  /* Initialize @ Center */
  initial 
    begin
      posVerStart <= ( ( `VDR - `VAL*`CHM )/2 );
      posVerEnd   <= ( ( `VDR - `VAL*`CHM )/2 ) + ( `VAL*`CHM - 1 );
      posHorStart <= ( ( `HDR - `HAL*`CHM )/2 );
      posHorEnd   <= ( ( `HDR - `HAL*`CHM )/2 ) + ( `HAL*`CHM - 1 );
    end

  always @ ( posedge OffsetFlag[0] or posedge reset )
   if ( reset )
    begin /* Reset to Center */ 
      posVerStart <= ( ( `VDR - `VAL*`CHM )/2 );
      posVerEnd   <= ( ( `VDR - `VAL*`CHM )/2 ) + ( `VAL*`CHM - 1 );
    end
  else if ( OffsetFlag[0] )
    begin 
      if ( posVerStart >= `VAL*`CHM + 1 ) 
        /* Character Vertical Start Offset can shift up without beading */
        begin
          posVerStart <= posVerStart - `VAL*`CHM; 
          posVerEnd   <= posVerEnd - `VAL*`CHM;
        end
      else /* Shift Character Vertical Start Offset to right edge */
        begin
          posVerStart <= `VDR - ( `VAL*`CHM - posVerStart );
          posVerEnd   <= ( posVerEnd == `VAL*`CHM )  ? `VDR ): ( posVerEnd - `VAL*`CHM );
        end
    end  

  always @ ( posedge OffsetFlag[2] or posedge reset )
   if ( reset )
    begin /* Reset to Center */ 
      posHorStart <= ( ( `HDR - `HAL*`CHM )/2 );
      posHorEnd   <= ( ( `HDR - `HAL*`CHM )/2 ) + ( `HAL*`CHM - 1 );
    end
  else if ( OffsetFlag[2] )
    begin 
      if ( posHorStart >= `HAL*`CHM + 1 ) 
        /* Character Horizontal Start Offset can shift left without beading */
        begin
          posHorStart <= posHorStart - `HAL*`CHM; 
          posHorEnd   <= ( posHorEnd <= `HAL*`CHM )  ? (`HDR - ( `HAL*`CHM - posHorEnd ) ) : posHorEnd - `HAL*`CHM;
        end
      else /* Shift Character Horizontal Start Offset to right edge */
        begin
          posHorStart <= `HDR - ( `HAL*`CHM - posHorStart );
          posHorEnd   <= ( posHorEnd == `HAL*`CHM )  ? `HDR ): ( posHorEnd - `VAL*`CHM );
        end
    end

endmodule
