`timescale 1ns / 100ps
/*******************************************************************************
*         (c) Copyright 1997,  National Semiconductor Corporation
*                           ALL RIGHTS RESERVED
********************************************************************************
*                   NATIONAL SEMICONDUCTOR CONFIDENTIAL
********************************************************************************
* *$Id: template_hdl.v,v 1.1 1998/07/09 22:49:34 clk Exp $
* *Name: buf_gea1
*===============================================================================
* *History: $Id$
*    Jan 18, 96 | <yakov@tasu9a>:  V1.00 First edit.
*    Sep 28, 00 | <martin@enigma>: V1.01 changed site id
*    Nov 14, 00 | <marcello@enigma>: V1.02 changed according with SPYGLASS rules
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

module buf_gea1 (y, a); 
  output y; // output
  input  a; // input

  assign y = a;

endmodule // of buf_gea1
