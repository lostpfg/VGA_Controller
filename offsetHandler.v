/*----- Module Overview -----------------------------------------------------*
*                                                                            *
*                            ________________________                        *
*                                                                            *
*                           |                        |                       *
*  clock          ------->  |                        |                       * 
*  reset          ------->  |                        | --/09--> posVerStart  *
*  moveDirection  --/04-->  |     offsetHandler      | --/09--> posVerEnd    *
*  movemoveStep   --/03-->  |                        | --/10--> posHorStart  * 
*                           |                        | --/10--> posHorEnd    *
*                           |                        |                       *
*                            ________________________                        *
*                                                                            *
*                                                                            *
*----------------------------------------------------------------------------*/
   
`include "globalVariables.v"

module  offsetHandler  ( clock, reset, movemoveStep , moveDirection, posVerStart, posVerEnd , posHorStart, posHorEnd );
    
  input                   clock;   
  input                   reset;
  input          [3:0]    moveDirection;   /* Defines offset increament { Right, Left, Down, Up }  */
  input          [3:0]    movemoveStep;    /* Defines moving speed (default 1*CharDim)  */

  output  reg    [8:0]    posVerStart;
  output  reg    [8:0]    posVerEnd;
  output  reg    [9:0]    posHorStart;
  output  reg    [9:0]    posHorEnd;


  initial 
    begin
      posVerStart = ( ( `VDR - `VAL )/2 );
      posVerEnd   = posVerStart + ( `VAL - 1 );
      posHorStart = ( ( `HDR - `HAL )/2 );
      posHorEnd   = posHorStart + ( `HAL - 1 );
    end

  always @ ( posedge clock or posedge reset )
    if ( reset )
      begin /* Reset to Center */ 
        posVerStart = ( ( `VDR - `VAL )/2 );
        posVerEnd   = ( ( `VDR - `VAL )/2 ) + ( `VAL - 1 );
      end
    else if ( moveDirection[0] ) /* Drawable Region moves up */
      begin
        posVerStart = ( posVerStart >= `VAL*movemoveStep + 1 ) ? ( posVerStart - `VAL*movemoveStep ) : ( `VDR - `VAL*movemoveStep + posVerStart ); 
        posVerEnd   = ( posVerEnd > `VAL*movemoveStep - 1 ) ? ( posVerEnd - `VAL*movemoveStep ) : ( posVerStart + `VAL - 1 );
      end
    else if ( moveDirection[1] )/* Drawable Region moves down */
      begin
        posVerStart = ( posVerStart <= `VDR - `VAL*movemoveStep ) ? ( posVerStart + `VAL*movemoveStep ) : ( `VAL*movemoveStep - VDR + posVerStart );
        posVerEnd   = ( posVerEnd >=  `VDR - VAL*movemoveStep + 1 ) ? ( `VAL*movemoveStep - `VDR + posVerEnd ) : posVerStart + `VAL - 1;
      end

  always @ ( posedge clock or posedge reset )
    if ( reset )
      begin /* Reset to Center */ 
        posHorStart = ( ( `HDR - `HAL )/2 );
        posHorEnd   = ( ( `HDR - `HAL )/2 ) + ( `HAL - 1 );
      end
    else if ( moveDirection[2] ) /* Drawable Region moves left */
      begin
        posHorStart = ( posHorStart >= `HAL*movemoveStep + 1 ) ? ( posHorStart - `HAL*movemoveStep ) : ( `HDR - `HAL*movemoveStep + posHorStart ); 
        posHorEnd   = ( posHorEnd > `HAL*movemoveStep - 1 ) ? ( posHorEnd - `HAL*movemoveStep ) : ( posHorStart + `HAL - 1 );
      end
    else if ( moveDirection[3] )/* Drawable Region moves right */
      begin
        posHorStart = ( posHorStart <= `HDR - `HAL*movemoveStep ) ? ( posHorStart + `HAL*movemoveStep ) : ( `HAL*movemoveStep - HDR + posHorStart );
        posHorEnd   = ( posHorEnd >=  `HDR - HAL*movemoveStep + 1 ) ? ( `HAL*movemoveStep - `HDR + posHorEnd ) : posHorStart + `HAL - 1;
      end

endmodule
