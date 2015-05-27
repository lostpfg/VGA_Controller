/*----- Module Overview ----------------------------------------------------*
*                                                                           *
*                         ____________________                              *
*                                                                           *
*                        |                    |                             *
*   clock       -------> |                    |                             *
*   reset       -------> |                    | -------> outBit             *
*   inNum       --/03--> |   romController    |                             *
*   addrOffset  --/04--> |                    |                             *
*                        |                    |                             *
*                         ____________________                              *
*                                                                           *
*---------------------------------------------------------------------------*/

module  romController ( reset, enable, inNum, addrOffset, outByte ) ; 

  input                   reset;
  input                   enable;
  input       [3:0]       addrOffset;
  input		  [2:0]		  inNum;
  
  wire        [5:0]       reqAdrr;
  wire 		  [7:0]	     reqByte;
  output reg  [7:0] 	     outByte;
	
  assign  readEn = enable && ( ~inNum[2] ) ;
  assign  reqAdrr = { inNum[1:0], addrOffset };
  
  charRom charByte ( reqAdrr, reqByte );
  
  always @ ( posedge readEn or posedge reset )
    if ( reset )
      outByte <= 8'h00;
    else
      outByte <= reqByte;
		
endmodule
