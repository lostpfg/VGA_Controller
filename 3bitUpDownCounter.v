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

module  UpDownCounter3bit  ( clock, reset, enable, outNum ) ; 

  input          clock;
  input          reset
  input          upDown; 
  input          enable;

  output  [2:0]  outNum; 

  reg     [2:0]  tmp; 
  reg     [2:0]  upDownFlag;

  always @ ( posedge clock or posedge reset ) begin 
      if ( reset ) 
        begin
          tmp        <= 3'd0;
          upDownFlag <= 1'b0;
        end 
      else if ( enable )
        begin
          tmp = ( ~upDown ) ? ( tmp + 1'b1 ) : ( tmp - 1'b1 );
          /*
          if ( ~upDown ) 
            tmp = tmp + 1'b1; 
          else 
            tmp = tmp - 1'b1;
          */
          if ( tmp == 3'b0 )
            upDownFlag = 1'b0;
          else if ( tmp == 3'b1 )
            upDownFlag = 1'b1;
        end
  end 

  assign outNum = tmp; 
  
endmodule