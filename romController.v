/*----- Module Overview --------------------------------------------------------*
*                                                                               *
*                             ____________________                              *
*                                                                               *
*                            |                    |                             *
*   clock           -------> |                    |                             *
*   reset           -------> |                    | -------> outBit             *
*   highAddrOffset  --/03--> |   romController    |                             *
*   lowAddrOffset   --/04--> |                    |                             *
*                            |                    |                             *
*                             ____________________                              *
*                                                                               *
*-------------------------------------------------------------------------------*/

module  romController ( clock, reset, enable, highAddrOffset, lowAddrOffset, outByte ) ; 

  input                   reset;
  input                   enable;
  input          [2:0]    highAddrOffset;
  input          [3:0]    lowAddrOffset;

  wire           [5:0]    reqAdrr;
  wire           [7:0]    reqByte;
  output  reg    [7:0]    outByte;
  
  assign  readEn = ( ~highAddrOffset[2] ) && enable;
  assign  reqAdrr = { highAddrOffset[1:0], lowAddrOffset };
  
  charRom charByte ( reqAdrr, reqByte );
  
  always @ ( posedge clock or posedge reset )
    if ( reset )
      outByte <= 8'h00;
    else if ( readEn )
      outByte <= reqByte;
    
endmodule
