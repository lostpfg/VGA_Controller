
/*----- Timing Table of Horizontal and Vertical Signals ---------------*
*   Both the Horizontal and Vertical syncing signals capture the same  *
*   timing model, the only difference being the lengths of theirs      *
*   pulse width, front porch, back porch, display time, etc.           *
*----------------------------------------------------------------------*/

`define HDR 640;   /* Horizontal Display Region */
`define HFP 16;    /* Horizontal Front Porch */
`define HSP 96;    /* Horizontal Syncing Pulse (Retrace) */
`define HBP 48;    /* Horizontal Back Porch */
`define HPL 0;     /* Horizontal Sync Polarity */

/* --- Horizontal Total Time = ( HDR + HFP + HSP + HBP ) = 800 ------------*/

`define VDR 400;   /* Vertical Display Region */
`define VFP 12;    /* Vertical Front Porch */
`define VSP 2;     /* Vertical Syncing Pulse (Retrace) */
`define VBP 35;    /* Vertical Back Porch */
`define VPL 1;     /* Vertical Sync Polarity */

/* --- Vertical Total Time = ( VDR + VFP + VSP + VBP ) = 449 --------------*/

`define CHM 1;     /* Character Magnify */