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

module vgaHandler ( clock, reset, hSync, vSync, pixelCnt, lineCnt, compBlank );

    input               clock;           /* Pixel Clock */
    input               reset;              /* Reset */

    output reg          hSync;              /* Horizontal Syncing Signal */
    output reg          vSync;              /* Vertical Syncing Signal */
    output reg  [9:0]   pixelCnt;           /* Counter for pixels in a line */
    output reg  [8:0]   lineCnt;            /* Counter of  lines */
    output reg          compBlank;          /* Counter of  lines */
    
    reg                 hBlank;             /* Composite blanking signal */
    reg                 vBlank;             /* Composite blanking signal */

    /*----- Timing Table of Horizontal and Vertical Signals ---------------*
    *   Both the Horizontal and Vertical syncing signals capture the same  *
    *   timing model, the only difference being the lengths of theirs      *
    *   pulse width, front porch, back porch, display time, etc.           *
    *----------------------------------------------------------------------*/

    localparam HDT = 640;   /* Horizontal Display Time */
    localparam HFP = 16;    /* Horizontal Front Porch */
    localparam HSP = 96;    /* Horizontal Syncing Pulse */
    localparam HBP = 48;    /* Horizontal Back Porch */
    localparam HPL = 0;     /* Horizontal Sync Polarity */

    /* --- Horizontal Total = ( HDT + HFP + HSP + HBP ) = 800 ------------*/

    localparam VDT = 400;   /* Vertical Display Time */
    localparam VFP = 12;    /* Vertical Front Porch */
    localparam VSP = 2;     /* Vertical Syncing Pulse */
    localparam VBP = 35;    /* Vertical Back Porch */
    localparam VPL = 1;     /* Vertical Sync Polarity */

    /* --- Vertical Total = ( VDT + VFP + VSP + VBP ) = 449 --------------*/

    /* ---- Horizontal Pixel (Synchronous) Counter ----------------------- *
    *   The horizontal counter increases by one when is exclusively        *
    *   less than (  Horizontal Total ), otherwise it resets to zero.      *
    *----------------------------------------------------------------------*/
    
    always @ ( posedge clock or posedge reset ) begin
        if ( reset ) /* On reset set pixel counter to 0 */
            pixelCnt <= 10'd0;
        else if (  pixelCnt == ( HDT + HFP + HSP + HBP ) - 1 ) /* Reached the last pixel in line, so reset the counter */
            pixelCnt <= 10'd0;
        else /* Did not reach the last pixel, so increase the counter */
            pixelCnt <=  pixelCnt + 1;
    end

    /* ---- Vertical Line (Synchronous) Counter -------------------------- *
    *   The vertical counter increases by one when the horizontal counter  *
    *   resets to zero and the vertical counter is exclusively less than   *
    *   ( Vretical Total ), otherwise it resets to zero.                   *
    *----------------------------------------------------------------------*/

    always @ ( posedge clock or posedge reset ) begin
        if ( reset ) /* On reset set line counter to 0 */
            lineCnt <= 9'd0;
        else if ( (  lineCnt == ( VDT + VFP + VSP + VBP )  - 1 ) && (  pixelCnt == ( HDT + HFP + HSP + HBP ) - 1 ) ) /* Reached the last pixel of the line and the whole frame, so reset the counter */
            lineCnt <= 9'd0;
        else if (  pixelCnt == ( HDT + HFP + HSP + HBP )  - 1 ) /* Reached last pixel but not in last line, so increase the counter */
            lineCnt <=  lineCnt + 1;
    end

    /* ---- Horizontal Sync Signal Generator -------------------------- *
    *   The horizontal sync signal should be low when it's counter is   * 
    *   exclusively less than ( HDT + HFP + HSP ) and greater than or   *
    *   equal to ( HDT + HFP), when others it is high.                  *
    *-------------------------------------------------------------------*/

    always @ ( posedge clock or posedge reset ) begin
        if ( reset ) /* Disable Syncing */
            hSync <= ~HPL;
        else if ( pixelCnt == ( HDT + HFP ) - 1 ) /* Enable Syncing after Front Porch & Display Time */
            hSync <= HPL;
        else if ( pixelCnt == ( HDT + HFP + HSP ) - 1 ) /* Disable Syncing otherwise */
            hSync <= ~HPL;
    end

    /* ---- Vertical Sync Signal Generator ---------------------------- *
    *   The vertical sync signal should be high when it's counter is    * 
    *   exclusively less than ( VDT+ VFP + VSP ) and greater than or    *
    *   equal to ( VDT + VFP), when others it is low.                   *
    *-------------------------------------------------------------------*/

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
            vSync = ~VPL;
        else if ( lineCnt == ( VDT + VFP ) - 1 ) 
            vSync = VPL;
        else if ( lineCnt == ( VDT + VFP + VSP ) - 1  )
            vSync = ~VPL;
    end
    
    /* ---- Horizontal Blanking Signal Generator ----------------------------*
    *   The horizontal blanking singal should be high when it's counter is   *
    *   exclusively less than ( HDT ) and must be seted to low after the     *
    *   ( Horizontal Total ) time.                                           *
    *------------------------------------------------------------------------*/

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
            hBlank <= 1'b0;
        else if ( pixelCnt == HDT - 1 ) /* Outside Display Region */
            hBlank <= 1'b1;
        else if ( pixelCnt == ( HDT + HFP + HSP + HBP ) - 1 )
            hBlank <= 1'b0;
    end

    /* ---- Horizontal Blanking Signal Generator ----------------------------*
    *   The Vertical blanking singal should be high when it's counter is     *
    *   exclusively less than ( VDT ) and must be seted to low after the     *
    *   ( Vretical Total ) time.                                             *
    *------------------------------------------------------------------------*/

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
            vBlank <= 1'b0;
        else if ( lineCnt == VDT - 1 ) /* Outside Display Region */
            vBlank <= 1'b1;
        else if ( lineCnt == ( VDT + VFP + VSP + VBP ) - 1 )
            vBlank <= 1'b0;
    end

    /* ---- Composite Blanking Signal Generator ------------------------------------*
    *   The Composite blanking singal should be high either when the Horizontal     *
    *   or Vertical signal are high respectively. Otherwise it is seted to low      *
    *-------------------------------------------------------------------------------*/

    always @ ( posedge clock or posedge reset ) begin
        if ( reset )
            compBlank <= 1'b0;
        else if ( hBlank || vBlank )
            compBlank <= 1'b1;
        else
            compBlank <= 1'b0;
    end

endmodule
