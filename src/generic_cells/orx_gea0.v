`timescale 100 ps/100 ps
/*******************************************************************************
*         (c) Copyright 1997,  National Semiconductor Corporation
*                           ALL RIGHTS RESERVED
********************************************************************************
*                   NATIONAL SEMICONDUCTOR CONFIDENTIAL
********************************************************************************
* *$Id: template_hdl.v,v 1.1 1998/07/09 22:49:34 clk Exp $
* *Name: orx_gea0
*===============================================================================
* *History: $Id$
*   Fri Jan 25 13:40:23 MET 2002 - v1  torsten      Initial Revision
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
module orx_gea0 (
   // OUTPUT
   y,      // or output

   // INPUT
   a       // input a
   );

parameter SIZE = 2;

// OUTPUT
output            y;      // or output

// INPUT
input [SIZE-1:0]  a;      // input a

// synopsys template

assign y = |a;
 
endmodule  //  End of 'module orx_gea0 ()'
