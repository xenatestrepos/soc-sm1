`timescale 1ns / 100ps
//----------------------------------------------------------------------------
// (c) Copyright 1998-2001, National Semiconductor Coporation
//----------------------------------------------------------------------------
// National Semiconductor Confidential. All Rights Reserved.
//----------------------------------------------------------------------------
// *Name: gpio_rdwr_regs.v
// 
// *Module Description:  Scaleable GPIO Module Design Verifications test
//	                  - check reset values
//	                  - apb_write and apb_read 8'h55 to all registers
//	                  - apb_write and apb_read 8'hAA to all registers
//	                  - apb_write and apb_read unique pattern
//	                  - set all registers to opposite reset values
//	                    and perform system reset
//	                  - check reset values
// 
//    Parent:            None
//
//    Children:          test_ck_gpio_xt_xxxx.v      
//
//
//----------------------------------------------------------------------------
// *History:
//
//    Feb 28, 01 | Wolfgang Hoeld        V1.0 Created from test_regset.v
//----------------------------------------------------------------------------
// *endName

module test_top;

// include the global definition file

`include "ck_gpio_xt_geh0_params.v"

// generate signalscan trn file

`ifdef SIGNALSCAN

initial
  begin
    $recordfile("gpio_rdwr_regs.trn");
    $recordvars("depth=0", test_top);
  end

`endif

//============================================================================
//  Parameter declarations
//============================================================================

// Parameter definitions

parameter  COMP_ALL    =  {`GPIO_CH{1'b1}};  //Compare mask - all bits compared

`ifdef STP_ERROR
parameter  ERRORSTOP   =  1'b1;      //Stop simulation upon error
`else
parameter  ERRORSTOP   =  1'b0;      //Continue simulation upon error
`endif
`ifdef PxALTS_RESET_VALUE
   
     parameter RESET_VALUE_ALT_A = {`PxALT_RESET_VALUE} & ~{`PxALTS_RESET_VALUE};
     parameter RESET_VALUE_ALT_B = {`PxALT_RESET_VALUE} & {`PxALTS_RESET_VALUE};

`endif
`ifdef PxWKPU_RESET_VALUE
   
     parameter RESET_VALUE_WKP_PULLUP   = {`PxWKPU_RESET_VALUE} & {`PxPDR_RESET_VALUE};
     parameter RESET_VALUE_WKP_PULLDOWN = {`PxWKPU_RESET_VALUE} & ~{`PxPDR_RESET_VALUE};

`endif
//============================================================================
//      Design Verification Tests
//============================================================================

// include the testbench / dut

`include "tb_ck_gpio_xt_geh0.v" 

initial
  begin

  apb_reset;         // Reset APB bus and DUT

  $display ("\n***************** TESTING RESET VALUES ********************\n");

  // -> check all reset values of module outputs
  // -> apb_read accesses after reset (note that DIN is not apb_read)

  if(out_en   != {`GPIO_CH{1'b0}}) Error("Output Enable", ERRORSTOP);
  if(tst_din  != {`GPIO_CH{1'b0}}) Error("Test Data In Output", ERRORSTOP);
  if(alt_dina != {`GPIO_CH{1'b0}}) Error("Data In PXALT A Output", ERRORSTOP);
  if(alt_dinb != {`GPIO_CH{1'b0}}) Error("Data In PXALT B Output", ERRORSTOP);
  if(gpio_int != 1'b0)             Error("gpio interrupt", ERRORSTOP);

`ifdef PxALTS_RESET_VALUE
     if(rd_en    != {`PxALT_RESET_VALUE}) Error("Read Enable Output", ERRORSTOP);
//     $display("PxALT_RESET_VALUE: %b ", `PxALT_RESET_VALUE, "\n\n\n");
//     $display("PxALTS_RESET_VALUE: %b ", `PxALTS_RESET_VALUE, "\n\n\n");
//     $display("RESET_VALUE_ALT_A: %b ", RESET_VALUE_ALT_A, "\n\n\n");
     if(alt_a_en != RESET_VALUE_ALT_A) Error("alt_a_en Output", ERRORSTOP);
     if(alt_b_en != RESET_VALUE_ALT_B) Error("alt_b_en Output", ERRORSTOP);

     apb_read (PXALTS, `PxALTS_RESET_VALUE, COMP_ALL, ERRORSTOP);
     apb_read (PXALT, `PxALT_RESET_VALUE,  COMP_ALL, ERRORSTOP);
`else

     if(rd_en    != {`GPIO_CH{1'b0}}) Error("Read Enable Output", ERRORSTOP);
     if(alt_a_en != {`GPIO_CH{1'b0}}) Error("alt_a_en Output", ERRORSTOP);
     if(alt_b_en != {`GPIO_CH{1'b0}}) Error("alt_b_en Output", ERRORSTOP);

     apb_read (PXALTS,     {`GPIO_CH{1'b0}}, COMP_ALL, ERRORSTOP);
     apb_read (PXALT,      {`GPIO_CH{1'b0}}, COMP_ALL, ERRORSTOP);

`endif 

`ifdef PxWKPU_RESET_VALUE
     if(wkpd_en != RESET_VALUE_WKP_PULLDOWN) Error("wkpd_en Output", ERRORSTOP);
     if(wkpu_en != RESET_VALUE_WKP_PULLUP)   Error("wkpu_en Output", ERRORSTOP);
     apb_read (PXWKPU, `PxWKPU_RESET_VALUE, COMP_ALL, ERRORSTOP);
     apb_read (PXPDR,  `PxPDR_RESET_VALUE, COMP_ALL, ERRORSTOP);
`else
     if(wkpd_en  != {`GPIO_CH{1'b0}}) Error("Weak Pull Down Output", ERRORSTOP);
     if(wkpu_en  != {`GPIO_CH{1'b0}}) Error("Weak Pull Up Output", ERRORSTOP);
     apb_read (PXWKPU,     {`GPIO_CH{1'b0}}, COMP_ALL, ERRORSTOP);
     apb_read (PXPDR,      {`GPIO_CH{1'b1}}, COMP_ALL, ERRORSTOP);
`endif
       
    
  apb_read (PXDIR,      {`GPIO_CH{1'b0}}, COMP_ALL, ERRORSTOP);
  apb_read (PXHDRV,     {`GPIO_CH{1'b0}}, COMP_ALL, ERRORSTOP);
  apb_read (PXIEN,      {`GPIO_CH{1'b0}}, COMP_ALL, ERRORSTOP);


  $display ("\n ************** TESTING  REGISTER WRITE/READ **************\n");

  // Write/Read 5555/AAAA

  apb_write_read (PXALT,    `GPIO_CH'h5555, `GPIO_CH'h5555, COMP_ALL, ERRORSTOP);
  apb_write_read (PXDIR,    `GPIO_CH'h5555, `GPIO_CH'h5555, COMP_ALL, ERRORSTOP);
  apb_write_read (PXDOUT,   `GPIO_CH'h5555, `GPIO_CH'h5555, COMP_ALL, ERRORSTOP);
  apb_write_read (PXWKPU,   `GPIO_CH'h5555, `GPIO_CH'h5555, COMP_ALL, ERRORSTOP);
  apb_write_read (PXALTS,   `GPIO_CH'h5555, `GPIO_CH'h5555, COMP_ALL, ERRORSTOP);
  apb_write_read (PXHDRV,   `GPIO_CH'h5555, `GPIO_CH'h5555, COMP_ALL, ERRORSTOP);
  apb_write_read (PXIEN,    `GPIO_CH'h5555, `GPIO_CH'h5555, COMP_ALL, ERRORSTOP);
  apb_write_read (PXPDR,    `GPIO_CH'h5555, `GPIO_CH'h5555, COMP_ALL, ERRORSTOP);


  drive_dinp (`GPIO_CH'h5555);
  apb_read (PXDIN,   `GPIO_CH'h5555, COMP_ALL, ERRORSTOP);

  apb_write_read (PXALT,    `GPIO_CH'hAAAA, `GPIO_CH'hAAAA, COMP_ALL, ERRORSTOP);
  apb_write_read (PXDIR,    `GPIO_CH'hAAAA, `GPIO_CH'hAAAA, COMP_ALL, ERRORSTOP);
  apb_write_read (PXDOUT,   `GPIO_CH'hAAAA, `GPIO_CH'hAAAA, COMP_ALL, ERRORSTOP);
  apb_write_read (PXWKPU,   `GPIO_CH'hAAAA, `GPIO_CH'hAAAA, COMP_ALL, ERRORSTOP);
  apb_write_read (PXALTS,   `GPIO_CH'hAAAA, `GPIO_CH'hAAAA, COMP_ALL, ERRORSTOP);
  apb_write_read (PXHDRV,   `GPIO_CH'hAAAA, `GPIO_CH'hAAAA, COMP_ALL, ERRORSTOP);
  apb_write_read (PXIEN,    `GPIO_CH'hAAAA, `GPIO_CH'hAAAA, COMP_ALL, ERRORSTOP);
  apb_write_read (PXPDR,    `GPIO_CH'hAAAA, `GPIO_CH'hAAAA, COMP_ALL, ERRORSTOP);

  drive_dinp (`GPIO_CH'hAAAA);
  apb_read (PXDIN,   `GPIO_CH'hAAAA, COMP_ALL, ERRORSTOP);

  // Write/Read Unique data

  apb_write_read (PXALT,    PXALT,  PXALT,  COMP_ALL, ERRORSTOP);
  apb_write_read (PXDIR,    PXDIR,  PXDIR,  COMP_ALL, ERRORSTOP);
  apb_write_read (PXDOUT,   PXDOUT, PXDOUT, COMP_ALL, ERRORSTOP);
  apb_write_read (PXWKPU,   PXWKPU, PXWKPU, COMP_ALL, ERRORSTOP);
  apb_write_read (PXALTS,   PXALTS, PXALTS, COMP_ALL, ERRORSTOP);
  apb_write_read (PXHDRV,   PXHDRV, PXHDRV, COMP_ALL, ERRORSTOP);
  apb_write_read (PXIEN,    PXIEN,  PXIEN,  COMP_ALL, ERRORSTOP);
  apb_write_read (PXPDR,    PXPDR,  PXPDR,  COMP_ALL, ERRORSTOP);

  // Write FFFF, perform reset, check reset value

  apb_write_read (PXALT,    {`GPIO_CH{1'b1}}, {`GPIO_CH{1'b1}}, COMP_ALL, ERRORSTOP);
  apb_write_read (PXDIR,    {`GPIO_CH{1'b1}}, {`GPIO_CH{1'b1}}, COMP_ALL, ERRORSTOP);
  apb_write_read (PXDOUT,   {`GPIO_CH{1'b1}}, {`GPIO_CH{1'b1}}, COMP_ALL, ERRORSTOP);
  apb_write_read (PXWKPU,   {`GPIO_CH{1'b1}}, {`GPIO_CH{1'b1}}, COMP_ALL, ERRORSTOP);
  apb_write_read (PXALTS,   {`GPIO_CH{1'b1}}, {`GPIO_CH{1'b1}}, COMP_ALL, ERRORSTOP);
  apb_write_read (PXHDRV,   {`GPIO_CH{1'b1}}, {`GPIO_CH{1'b1}}, COMP_ALL, ERRORSTOP);
  apb_write_read (PXIEN,    {`GPIO_CH{1'b1}}, {`GPIO_CH{1'b1}}, COMP_ALL, ERRORSTOP);
  apb_write_read (PXPDR,    {`GPIO_CH{1'b1}}, {`GPIO_CH{1'b1}}, COMP_ALL, ERRORSTOP);

  apb_reset;

  apb_read (PXDIR,      {`GPIO_CH{1'b0}}, COMP_ALL, ERRORSTOP);
  apb_read (PXHDRV,     {`GPIO_CH{1'b0}}, COMP_ALL, ERRORSTOP);
  apb_read (PXIEN,      {`GPIO_CH{1'b0}}, COMP_ALL, ERRORSTOP);
`ifdef PxALTS_RESET_VALUE
     apb_read (PXALTS, `PxALTS_RESET_VALUE, COMP_ALL, ERRORSTOP);
     apb_read (PXALT, `PxALT_RESET_VALUE,  COMP_ALL, ERRORSTOP);
`else
     apb_read (PXALTS,     {`GPIO_CH{1'b0}}, COMP_ALL, ERRORSTOP);
     apb_read (PXALT,      {`GPIO_CH{1'b0}}, COMP_ALL, ERRORSTOP);
`endif 
`ifdef PxWKPU_RESET_VALUE
     apb_read (PXWKPU, `PxWKPU_RESET_VALUE, COMP_ALL, ERRORSTOP);
     apb_read (PXPDR,  `PxPDR_RESET_VALUE, COMP_ALL, ERRORSTOP);
`else
     apb_read (PXWKPU,     {`GPIO_CH{1'b0}}, COMP_ALL, ERRORSTOP);
     apb_read (PXPDR,      {`GPIO_CH{1'b1}}, COMP_ALL, ERRORSTOP);
`endif

  // Report pass/fail / Finish simulation

  apb_end_test (fail);
	
end // of initial
		
endmodule //gpio_rdwr_regs.v





