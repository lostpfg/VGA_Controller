/*----- Module Overview --------------------------------------------------*
*                                                                         *
*                      _____________________                              *
*                                                                         *
*                     |                     |                             *
*   clock     ------> |                     |                             *
*   reset     ------> |  UpDownCounter3bit  | --/03--> outNum             *
*   enable    ------> |                     |                             *
*                     |                     |                             *
*                      _____________________                              *
*                                                                         *
*-------------------------------------------------------------------------*/

module  UpDownCounter3bit  ( reset, enable, outNum ) ; 

  input          reset;
  input          enable;

  reg            upDownFlag;
  reg     [2:0]  temp; 

  output  [2:0]  outNum; 

  /*------------------------------------------------------------------------*
  *  The  counter modifies its vaule only when enable signal is high. The   *
  *  value increases by one when upDownFlag is high otherwise it decreases. *
  *  The polarity of upDownFlag signal changes internally when the counter  * 
  *  reaches bound values.                                                  *
  *-------------------------------------------------------------------------*/

  always @ ( posedge enable or posedge reset ) begin 
    if ( reset ) /* On reset clear both ounter value and count polarity */
      begin
        temp        <= 3'd0;
        upDownFlag  <= 1'b0;
      end 
    else
      begin
        temp <= ( ~upDownFlag ) ? ( temp + 1 ) : ( temp - 1 );
        if ( temp == 3'd6 ) /* Change value at max value - 1 cause of parallelism */
          upDownFlag <= 1'b1;
        else if ( temp == 3'd1 ) /* Change value at min value +1 cause of parallelism */
          upDownFlag <= 1'b0;
      end
  end 
  /* Pass counter value to the output of the module */
  assign outNum = temp; 
  
endmodule
