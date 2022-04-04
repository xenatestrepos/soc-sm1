`timescale 100 ps/100 ps
/*******************************************************************************
*         (c) Copyright 2002,  National Semiconductor Corporation
*                           ALL RIGHTS RESERVED
********************************************************************************
*                   NATIONAL SEMICONDUCTOR CONFIDENTIAL
********************************************************************************
* *$Id: template_hdl.v,v 1.1 1998/07/09 22:49:34 clk Exp $
* *Name: mux_n4x1_aua0
*===============================================================================
* *History: $Id$
*   02 Aug 2002 - v1  sl      Initial Revision
*===============================================================================
* *Description:
*
* parent:  (Upward hierarchy) If known
* children:  (downward hierarchy)
*
* *endName
********************************************************************************
********************************************************************************
*        1         2         3         4         5         6         7         8
*2345678901234567890123456789012345678901234567890123456789012345678901234567890
*******************************************************************************/
 
module mux_n4x1_aua0 (
// OUTPUT
o,      // mux output

// INPUTs
i0,     // input 0 - if sel=00
i1,     // input 1 - if sel=01
i2,     // input 2 - if sel=10
i3,     // input 3 - if sel=11
   
sel0,   // select input 0
sel1   // select input 1 
   
);

// PARAMETERS
parameter WIDTH = 1;


// OUTPUT
output [WIDTH-1:0] o;      // mux output

reg [WIDTH-1:0] o; 

// INPUTs
input [WIDTH-1:0]  i0;     // input 0 - if sel=00
input [WIDTH-1:0]  i1;     // input 1 - if sel=01
input [WIDTH-1:0]  i2;     // input 2 - if sel=10
input [WIDTH-1:0]  i3;     // input 3 - if sel=11

input              sel0;    // select input 0
input              sel1;    // select input 1


// synopsys template

   always @(sel0 or sel1 or i0 or i1 or i2 or i3)
    casex({sel1,sel0}) //synopsys full_case parallel_case
      2'b00:  o = i0;
      2'b01:  o = i1;
      2'b10:  o = i2;
      2'b11:  o = i3;
    endcase

endmodule  //  End of 'module mux_n4x1_aua0 ()'
