/*----- Module Overview ------------------------------------------------*
*                                                                       *
*                      __________________                               *
*                                                                       *
*   clock     ------> |                   | -------> hSync              *
*   reset     ------> |                   | --/10--> pixelCnt           *
*                     |    vgaHandler     | -------> vSync              *
*                     |                   | --/09--> lineCnt            *
*                     |                   | -------> compBlank          *
*                      __________________                               *
*                                                                       *
* The vgaHandler module generates the horizontal sync signal, which     *
* specifies the time to traverse a row, and the vertical sync signal    *
* which specifies the time to scan an entire frame. Additionaly ...     *
*                                                                       *
*-----------------------------------------------------------------------*/

`include "globalVariables.v"

module vgaHandler ( clock, reset, hSync, pixelCnt, vSync, lineCnt, compBlank  );

    input               clock;
    input               reset;

    reg                 hBlank;             /* Register for the Horizontal blanking signal */
    reg                 vBlank;             /* Register for the Vertical blanking signal */

    output reg          hSync;              /* Horizontal Syncing Signal */
    output reg          vSync;              /* Vertical Syncing Signal */
    output reg  [9:0]   pixelCnt;           /* Counter of pixels in a line [0,( `HDR + `HFP + `HSP + `HBP ) - 1] */
    output reg  [8:0]   lineCnt;            /* Counter of lines in a frame [0,( `VDR + `VFP + `VSP + `VBP ) - 1]*/
    output reg          compBlank;          /* Tracks Composite ( Vertical or Horisontal ) Blanking Signal */
    

    /*----- Horizontal Pixel (Synchronous) Counter ------------------------*
    *   The horizontal counter increases by one when is exclusively        *
    *   less than the Horizontal Total display time, otherwise it resets   *
    *   to zero.                                                           *
    *----------------------------------------------------------------------*/
    
    always @ ( posedge clock or posedge reset ) begin
        if ( reset ) /* On reset clear pixel counter */
            pixelCnt <= 10'd0;
        else if (  pixelCnt == ( `HDR + `HFP + `HSP + `HBP ) - 1 ) /* Reached the last pixel in line, so reset the counter */
            pixelCnt <= 10'd0;
        else /* Did not reach the last pixel, so increase the counter */
            pixelCnt <=  pixelCnt + 1;
    end

    /*----- Vertical Line (Synchronous) Counter -------------------------- *
    *   The vertical counter increases by one when the horizontal counter  *
    *   resets to zero and the vertical counter is exclusively less than   *
    *   ( Vretical Total ), otherwise it resets to zero.                   *
    *----------------------------------------------------------------------*/

    always @ ( posedge clock or posedge reset ) begin
        if ( reset ) /* On reset clear pixel counter */
            lineCnt <= 9'd0;
        else if ( (  lineCnt == ( `VDT + `VFP + `VSP + `VBP )  - 1 ) && (  pixelCnt == ( `HDR + `HFP + `HSP + `HBP ) - 1 ) ) /* Reached the last pixel of the line and the whole frame, so reset the counter */
            lineCnt <= 9'd0;
        else if (  pixelCnt == ( `HDR + `HFP + `HSP + `HBP )  - 1 ) /* Reached last pixel but not in last line, so increase the counter */
            lineCnt <=  lineCnt + 1;
    end

    /*----- Horizontal Sync Signal Generator ------------------------------*
    *   The horizontal sync signal should be low when it's counter is      * 
    *   exclusively less than ( `HDR + `HFP + `HSP ) and greater than or   *
    *   equal to ( `HDR + `HFP), when others it is high.                   *
    *----------------------------------------------------------------------*/

    always @ ( posedge clock or posedge reset ) begin
        if ( reset ) /* Disable Syncing */
            hSync <= ~HPL;
        else if ( pixelCnt == ( `HDR + `HFP ) - 1 ) /* Enable Syncing after Front Porch & Display Time */
            hSync <= HPL;
        else if ( pixelCnt == ( `HDR + `HFP + `HSP ) - 1 ) /* Disable Syncing otherwise */
            hSync <= ~HPL;
    end

    /*----- Vertical Sync Signal Generator ---------------------------- *
    *   The vertical sync signal should be high when it's counter is    * 
    *   exclusively less than ( `VDT+ `VFP + `VSP ) and greater than or    *
    *   equal to ( `VDT + `VFP), when others it is low.                   *
    *-------------------------------------------------------------------*/

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
            vSync = ~VPL;
        else if ( ( lineCnt == ( `VDT + `VFP ) - 1 ) && ( pixelCnt == ( `HDR + `HFP + `HSP + `HBP ) - 1 ) )
            vSync = VPL;
        else if ( ( lineCnt == ( `VDT + `VFP + `VSP ) - 1 ) && ( pixelCnt == ( `HDR + `HFP + `HSP + `HBP ) - 1 ) )
            vSync = ~VPL;
    end
    
    /*----- Horizontal Blanking Signal Generator ----------------------------*
    *   The horizontal blanking singal should be high when it's counter is   *
    *   exclusively less than ( `HDR ) and must be seted to low after the     *
    *   ( Horizontal Total ) time.                                           *
    *------------------------------------------------------------------------*/

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
            hBlank <= 1'b0;
        else if ( pixelCnt == `HDR - 1 ) /*-Outside Display Region */
            hBlank <= 1'b1;
        else if ( pixelCnt == ( `HDR + `HFP + `HSP + `HBP ) - 1 )
            hBlank <= 1'b0;
    end

    /*----- Horizontal Blanking Signal Generator ----------------------------*
    *   The Vertical blanking singal should be high when it's counter is     *
    *   exclusively less than ( `VDT ) and must be seted to low after the     *
    *   ( Vretical Total ) time.                                             *
    *------------------------------------------------------------------------*/

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
            vBlank <= 1'b0;
        else if ( ( lineCnt == `VDT - 1 ) && ( pixelCnt == ( `HDR + `HFP + `HSP + `HBP ) - 1 ) ) /*-Outside Display Region */
            vBlank <= 1'b1;
        else if ( ( lineCnt == ( `VDT + `VFP + `VSP + `VBP ) - 1 ) && ( pixelCnt == ( `HDR + `HFP + `HSP + `HBP ) - 1 ) )
            vBlank <= 1'b0;
    end

    /*----- Composite Blanking Signal Generator ------------------------------------*
    *   The Composite blanking singal should be high either when the Horizontal     *
    *   or Vertical signal are high respectively. Otherwise it is seted to low      *
    *-------------------------------------------------------------------------------*/

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
            compBlank <= 1'b0;
        else if ( vBlank || hBlank ) /*-Outside Display Region */
            compBlank <= 1'b1;
        else
            compBlank <= 1'b0;
    end
     
endmodule
