`timescale 1ns / 100ps
/*******************************************************************************
*         (c) Copyright 1997,  National Semiconductor Corporation
*                           ALL RIGHTS RESERVED
********************************************************************************
*                   NATIONAL SEMICONDUCTOR CONFIDENTIAL
********************************************************************************
* *$Id: template_hdl.v,v 1.1 1998/07/09 22:49:34 clk Exp $
* *Name: nor2_gea1
*===============================================================================
* *History: $Id$
*    Oct 14, 95 | <yakov@tasu9a>:  V1.00 First edit.
*    Sep 28, 00 | <martin@enigma>: V1.01 changed site id
*    Nov, 14 00 | <marcello@enigma>: V1.02 adapted syntax to SPYGLASS rules 
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

// reuse-pragma startSub [InsertComponentPrefix %subText 7]
module nor2_gea1 (y, a, b);
   output y; // output
   input a; // first input
   input b; // second input
 
  assign y = ~(a | b);

endmodule // of nor2_gea1
