`timescale 1ns / 100ps
/*******************************************************************************
 *         (c) Copyright 1997,  National Semiconductor Corporation
 *                           ALL RIGHTS RESERVED
 ********************************************************************************
 *                   NATIONAL SEMICONDUCTOR CONFIDENTIAL
 *******************************************************************************
 * *$Id: template_hdl.v,v 1.1 1998/07/09 22:49:34 clk Exp $
 * *Name: delay_geb0
 *===============================================================================
 * *History: $Id$
 *     15, May 01 | <marcello@enigma>: V1.00 Created
 *     13, Dec 01 | <franz@enigma>   : V1.00 Added parameter DELAY
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
module delay_geb0 (y, a); 
   output y; // output
   input  a; // input

   parameter DELAY = 10; 

   assign #DELAY y = a;

endmodule // of delay_geb0
