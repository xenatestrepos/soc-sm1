`timescale 100 ps/100 ps
/*******************************************************************************
*         (c) Copyright 1997,  National Semiconductor Corporation
*                           ALL RIGHTS RESERVED
********************************************************************************
*                   NATIONAL SEMICONDUCTOR CONFIDENTIAL
********************************************************************************
* *$Id: template_hdl.v,v 1.1 1998/07/09 22:49:34 clk Exp $
* *Name: mux_n2x1_gea0
*===============================================================================
* *History: $Id$
*   Mon Nov 20 16:59:23 MET 2000 - v1  angelo      Initial Revision
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
 
module mux_n2x1_gea0 (
   // OUTPUT
   o,      // mux output

   // INPUTs
   i0,     // input 0 - if sel=0
   i1,     // input 1 - if sel=1
   sel     // select input 
   );

parameter WIDTH = 1;

// OUTPUT
output [WIDTH-1:0] o;      // mux output

// INPUTs
input [WIDTH-1:0]  i0;     // input 0 - if sel=0
input [WIDTH-1:0]  i1;     // input 1 - if sel=1
input              sel;    // select input

// synopsys template

assign o = (sel) ? i1 : i0;
 
endmodule  //  End of 'module mux_n2x1_gea0 ()'
