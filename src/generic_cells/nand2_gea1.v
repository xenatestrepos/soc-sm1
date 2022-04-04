`timescale 100 ps/100 ps
/*******************************************************************************
*         (c) Copyright 1997,  National Semiconductor Corporation
*                           ALL RIGHTS RESERVED
********************************************************************************
*                   NATIONAL SEMICONDUCTOR CONFIDENTIAL
********************************************************************************
* *$Id: template_hdl.v,v 1.1 1998/07/09 22:49:34 clk Exp $
* *Name: nand2_gea1
*===============================================================================
* *History: $Id$
*   Mon Oct 16 11:09:03 MET DST 2000 - v1  marcello      Initial Revision
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
 
module nand2_gea1 (y,a,b);
   output y; // nand2's output
   input  a; // nand2's first input
   input  b; // nand2's second input
  
   
   assign y = ~(a & b);
   
   
endmodule  //  End of 'module nand2_gea1 ()'

