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

  output  [2:0]  outNum; 

  reg     [2:0]  tmp; 
  reg            upDownFlag;

  always @ ( posedge enable or posedge reset ) begin 
      if ( reset ) 
        begin
          tmp        <= 3'd0;
          upDownFlag <= 1'b0;
        end 
      else if ( enable )
        begin
          tmp <= ( ~upDownFlag ) ? ( tmp + 1 ) : ( tmp - 1 );
          if ( tmp == 3'd6 )
            upDownFlag <= 1'b1;
          else if ( tmp == 3'd1 )
            upDownFlag <= 1'b0;
        end
  end 

  assign outNum = tmp; 
  
endmodule