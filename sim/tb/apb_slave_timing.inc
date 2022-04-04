//-----------------------------------------------------------------------
// (c) Copyright 1998-2001, National Semiconductor Coporation
//-----------------------------------------------------------------------
// National Semiconductor Confidential. All Rights Reserved.
//-----------------------------------------------------------------------
// *Name:	apb_slave_timing.inc
//
// *Module Description:  APB bus monitor/test bench timing information
//
//    Parent:	apb_tbench.v
//
//    Children:	
//
// *endName
//-----------------------------------------------------------------------
// *Modification History:
// 
//  01/21/02    Andy Chaggar        - Made timings dynamic for increased
//                                    frequency range.  
//  06/02/01 	Wolfgang Hoeld      - Created
//
//-----------------------------------------------------------------------

// System Clock
//-------------

`define TCLKL     (`PCLK/2)
`define TCLKH     (`PCLK/2)

// APB timing parameters
//----------------------

`define TISNRES   (`TCLKL*0.3)   // PRESETN setup to r.e.    pclk
`define TIHNRES   1              // PRESETN hold  after r.e. pclk

`define TISPEN    (`TCLKL*1.4)   // PENABLE setup to r.e.    pclk
`define TIHPEN    0              // PENABLE hold  after r.e. pclk
`define TISPSEL   (`TCLKL*1.4)   // PSEL    setup to r.e.    pclk
`define TIHPSEL   0              // PSEL    hold  after r.e. pclk
`define TISPA     (`TCLKL*1.4)   // PADDR   setup to r.e.    pclk
`define TIHPA     0              // PADDR   hold  after r.e. pclk
`define TISPW     (`TCLKL*1.4)   // PWRITE  setup to r.e.    pclk
`define TIHPW     0              // PWRITE  hold  after r.e. pclk
`define TISPWD    (`TCLKL*1.4)   // PWDATA  setup to r.e.    pclk
`define TIHPWD    0              // PWDATA  hold  after r.e. pclk

 // APB slave output setup/hold times

`define TOVPRD    (`TCLKL*0.4)   // PRDATA output valid after r.e. pclk
`define TOHPRD    0              // PRDATA hold

// after this time the interrupt must be stable

`define INT_CHECK  (`TCLKL*0.4)




