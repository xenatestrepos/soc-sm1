`timescale 1ns / 100ps
//----------------------------------------------------------------------------
// (c) Copyright 1998-2001, National Semiconductor Coporation
//----------------------------------------------------------------------------
// National Semiconductor Confidential. All Rights Reserved.
//----------------------------------------------------------------------------
// *Name: gpio_func.v
// 
// *Module Description:  Scaleable GPIO Module Design Verifications test:
//                         -test path dinp to APB bus
//                         -test path dinp to tst_din
//                         -test path dinp to alt_dina
//                         -test path dinp to alt_dinb
//                         -test path dinp to gpio_int
//                         -test data direction for all combinations
//                         -test data output for all combinations
//                         -test weak pullup in normal and test mode
//                         -test read enable inactive
//                         -test read enable active for all input combinations
//                         -test high drive
//                         -test alt_a_en, alt_b_en
//                         -test gpio_int
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
//    Nov 16, 01 | Angelo Lo Cicero      updated for the module gpio_xt_gec0
//    Nov 18, 04 | Angelo Lo Cicero      updated for the module gpio_xt_geh0
//----------------------------------------------------------------------------
// *endName

module test_top;

// include the global definition file

`include "ck_gpio_xt_geh0_params.v"

// generate signalscan trn file

`ifdef SIGNALSCAN

initial
  begin
    $recordfile("gpio_func.trn");
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

//============================================================================
//      Design Verification Tests
//============================================================================

// include the testbench / dut

`include "tb_ck_gpio_xt_geh0.v"

initial
  begin

  apb_reset;         // Reset APB bus and DUT

  apb_write (PXALTS,  {`GPIO_CH{1'b0}});
  apb_write (PXALT,   {`GPIO_CH{1'b0}});
     
  $display ("\n***************** TESTING DATA INPUT PATH *****************\n");

  // -> test path dinp_b to apb bus

  drive_dinp  (`GPIO_CH'h5555 );
  apb_read (PXDIN, `GPIO_CH'h5555, COMP_ALL, ERRORSTOP);
  drive_dinp  (`GPIO_CH'hAAAA );
  apb_read (PXDIN, `GPIO_CH'hAAAA, COMP_ALL, ERRORSTOP);

  $display("\n Test path dinp to tst_din output");

  check_output(tst_din, {`GPIO_CH{1'b0}}, COMP_ALL, "DIN default", ERRORSTOP);

  drive_tst ( 1'b1 );
  check_output(tst_din, `GPIO_CH'hAAAA, COMP_ALL, "DIN not AAAA", ERRORSTOP);
  drive_dinp  ( `GPIO_CH'h5555 );
  check_output(tst_din, `GPIO_CH'h5555, COMP_ALL, "DIN not 5555", ERRORSTOP);
  drive_tst ( 1'b0 );
  check_output(tst_din, {`GPIO_CH{1'b0}}, COMP_ALL, "DIN default", ERRORSTOP);
  
  $display("\n Test path dinp to alt_dina output");

  //registers ALT and ALTS are 0 (reset state)
  drive_dinp  ( `GPIO_CH'h5555 );
  check_output(alt_dina, {`GPIO_CH{1'b0}}, COMP_ALL, "DIN default", ERRORSTOP);
  drive_dinp  ( `GPIO_CH'hAAAA );
  check_output(alt_dina, {`GPIO_CH{1'b0}}, COMP_ALL, "DIN default", ERRORSTOP);

  //registers ALT is 0 and ALTS is 1 // changing dinp_b
  apb_write (PXALTS,   {`GPIO_CH{1'b1}});
  check_output(alt_dina, {`GPIO_CH{1'b0}}, COMP_ALL, "DIN default", ERRORSTOP);
  drive_dinp  ( `GPIO_CH'h5555 );
  check_output(alt_dina, {`GPIO_CH{1'b0}}, COMP_ALL, "DIN default", ERRORSTOP);

  //registers ALT is 1 and ALTS is 1 // changing dinp_b
  apb_write (PXALT,   {`GPIO_CH{1'b1}});
  check_output(alt_dina, {`GPIO_CH{1'b0}}, COMP_ALL, "DIN default", ERRORSTOP);
  drive_dinp  ( `GPIO_CH'hAAAA );
  check_output(alt_dina, {`GPIO_CH{1'b0}}, COMP_ALL, "DIN default", ERRORSTOP);

  //registers ALT is 1 and ALTS is 0 // changing dinp_b
  apb_write (PXALTS,   {`GPIO_CH{1'b0}});
  check_output(alt_dina, `GPIO_CH'hAAAA, COMP_ALL, "alt_dina not AAAA", ERRORSTOP);
  drive_dinp  ( `GPIO_CH'h5555 );
  check_output(alt_dina, `GPIO_CH'h5555, COMP_ALL, "alt_dina not 5555", ERRORSTOP);

  $display("\n Test path dinp to alt_dinb output");

  //registers ALT is 1 and ALTS is 0 from prev. test
  drive_dinp  ( `GPIO_CH'h5555 );
  check_output(alt_dinb, {`GPIO_CH{1'b0}}, COMP_ALL, "DIN default", ERRORSTOP);
  drive_dinp  ( `GPIO_CH'hAAAA );
  check_output(alt_dinb, {`GPIO_CH{1'b0}}, COMP_ALL, "DIN default", ERRORSTOP);

  //registers ALT is 1 and ALTS is 1 // changing dinp_b
  apb_write (PXALTS,   {`GPIO_CH{1'b1}});
  check_output(alt_dinb, `GPIO_CH'hAAAA, COMP_ALL, "alt_dina not AAAA", ERRORSTOP);
  drive_dinp  ( `GPIO_CH'h5555 );
  check_output(alt_dinb, `GPIO_CH'h5555, COMP_ALL, "alt_dina not 5555", ERRORSTOP);

  //registers ALT is 0 and ALTS is 1 // changing dinp_b
  apb_write (PXALT,   {`GPIO_CH{1'b0}});
  check_output(alt_dinb, {`GPIO_CH{1'b0}}, COMP_ALL, "DIN default", ERRORSTOP);
  drive_dinp  ( `GPIO_CH'hAAAA );
  check_output(alt_dinb, {`GPIO_CH{1'b0}}, COMP_ALL, "DIN default", ERRORSTOP);

  //registers ALT is 0 and ALTS is 0 // changing dinp_b
  apb_write (PXALTS,   {`GPIO_CH{1'b0}});
  check_output(alt_dinb, {`GPIO_CH{1'b0}}, COMP_ALL, "DIN default", ERRORSTOP);
  drive_dinp  ( `GPIO_CH'h5555 );
  check_output(alt_dinb, {`GPIO_CH{1'b0}}, COMP_ALL, "DIN default", ERRORSTOP);

  $display("\n Test path dinp to gpio_int output");

  // dinp = 5555 pxdout =aaaa all interrupts enabled
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
  apb_write (PXDOUT,   `GPIO_CH'hAAAA);
  apb_write (PXIEN,    `GPIO_CH'hFFFF);
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
  apb_write (PXIEN,   {`GPIO_CH{1'b0}});
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     
  // dinp = 0000 pxdout = 0000 one interrupts enabled
  drive_dinp  ( {`GPIO_CH{1'b0}} );
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
  apb_write (PXDOUT,   {`GPIO_CH{1'b0}});
  apb_write (PXIEN,   `GPIO_CH'h0001);
     # `INT_CHECK
  if(gpio_int != 1'b1)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
  apb_write (PXIEN,   {`GPIO_CH{1'b0}});
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     
  // dinp = FFFF pxdout = 0001 one interrupts enabled
  drive_dinp  ( {`GPIO_CH{1'b1}} );
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
  apb_write (PXDOUT,   `GPIO_CH'h0001);
  apb_write (PXIEN,   `GPIO_CH'h0001);
     # `INT_CHECK
  if(gpio_int != 1'b1)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
  apb_write (PXIEN,   {`GPIO_CH{1'b0}});
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)

  // dinp = 0000 pxdout = 0000 all interrupts enabled
  drive_dinp  ( {`GPIO_CH{1'b0}} );
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
  apb_write (PXDOUT,   {`GPIO_CH{1'b0}});
  apb_write (PXIEN,   {`GPIO_CH{1'b1}});
     # `INT_CHECK
  if(gpio_int != 1'b1)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
  apb_write (PXIEN,   {`GPIO_CH{1'b0}});
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)

  // dinp = FFFF pxdout = FFFF all interrupts enabled
  drive_dinp  ( {`GPIO_CH{1'b1}} );
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
  apb_write (PXDOUT,   {`GPIO_CH{1'b1}});
  apb_write (PXIEN,   {`GPIO_CH{1'b1}});
     # `INT_CHECK
  if(gpio_int != 1'b1)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
  apb_write (PXIEN,   {`GPIO_CH{1'b0}});
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)

  $display ("\n***************** TESTING DATA DIRECTION *****************\n");

  // -> write unique pattern to all mux inputs
  // -> test all combination of mux select signals

  drive_tst_dir  ( `GPIO_CH'hAAAA );
  drive_alt_dira ( `GPIO_CH'h5555 );
  drive_alt_dirb ( {`GPIO_CH{1'b1}} );
  apb_write (PXDIR, {`GPIO_CH{1'b0}});

  // tst is 0, ALT is 0 and ALTS is 0
  drive_tst ( 1'b0 );
  apb_write (PXALT,    {`GPIO_CH{1'b0}});
  apb_write (PXALTS,   {`GPIO_CH{1'b0}});
  check_output(out_en, {`GPIO_CH{1'b0}}, COMP_ALL, "out_en default", ERRORSTOP);

  // tst is 0, ALT is 0 and ALTS is 1
  apb_write (PXALTS,   {`GPIO_CH{1'b1}});
  check_output(out_en, {`GPIO_CH{1'b0}}, COMP_ALL, "out_en default", ERRORSTOP);

  // tst is 0, ALT is 1 and ALTS is 1
  apb_write (PXALT,    {`GPIO_CH{1'b1}});
  check_output(out_en, {`GPIO_CH{1'b1}}, COMP_ALL, "out_en not alt_dirb", ERRORSTOP);

  // tst is 0, ALT is 1 and ALTS is 0
  apb_write (PXALTS,   {`GPIO_CH{1'b0}});
  check_output(out_en, `GPIO_CH'h5555, COMP_ALL, "out_en not alt_dira", ERRORSTOP);

  // tst is 1, ALT is 1 and ALTS is 0
  drive_tst ( 1'b1 );
  check_output(out_en, `GPIO_CH'hAAAA, COMP_ALL, "out_en not tst_dir", ERRORSTOP);

  // tst is 1, ALT is 1 and ALTS is 1
  apb_write (PXALTS,   {`GPIO_CH{1'b1}});
  check_output(out_en, `GPIO_CH'hAAAA, COMP_ALL, "out_en not tst_dir", ERRORSTOP);

  // tst is 1, ALT is 0 and ALTS is 1
  apb_write (PXALT,    {`GPIO_CH{1'b0}});
  check_output(out_en, `GPIO_CH'hAAAA, COMP_ALL, "out_en not tst_dir", ERRORSTOP);

  // tst is 1, ALT is 0 and ALTS is 0
  apb_write (PXALTS,   {`GPIO_CH{1'b0}});
  check_output(out_en, `GPIO_CH'hAAAA, COMP_ALL, "out_en not tst_dir", ERRORSTOP);

  // -> write inverted unique pattern to all mux inputs
  // -> test all combination of mux select signals

  drive_tst_dir  ( `GPIO_CH'h5555 );
  drive_alt_dira ( `GPIO_CH'hAAAA );
  drive_alt_dirb ( 16'b0000 );
  apb_write (PXDIR,  {`GPIO_CH{1'b1}});

  // tst is 0, ALT is 0 and ALTS is 0
  drive_tst ( 1'b0 );
  apb_write (PXALT,    {`GPIO_CH{1'b0}});
  apb_write (PXALTS,   {`GPIO_CH{1'b0}});
  check_output(out_en, {`GPIO_CH{1'b1}}, COMP_ALL, "out_en default", ERRORSTOP);

  // tst is 0, ALT is 0 and ALTS is 1
  apb_write (PXALTS,   {`GPIO_CH{1'b1}});
  check_output(out_en, {`GPIO_CH{1'b1}}, COMP_ALL, "out_en default", ERRORSTOP);

  // tst is 0, ALT is 1 and ALTS is 1
  apb_write (PXALT,    {`GPIO_CH{1'b1}});
  check_output(out_en,{`GPIO_CH{1'b0}},COMP_ALL,"out_en not altdirb",ERRORSTOP);

  // tst is 0, ALT is 1 and ALTS is 0
  apb_write (PXALTS,   {`GPIO_CH{1'b0}});
  check_output(out_en, `GPIO_CH'hAAAA, COMP_ALL, "out_en not altdira", ERRORSTOP);

  // tst is 1, ALT is 1 and ALTS is 0
  drive_tst ( 1'b1 );
  check_output(out_en, `GPIO_CH'h5555, COMP_ALL, "out_en not tst_dir", ERRORSTOP);

  // tst is 1, ALT is 1 and ALTS is 1
  apb_write (PXALTS,   {`GPIO_CH{1'b1}});
  check_output(out_en, `GPIO_CH'h5555, COMP_ALL, "out_en not tst_dir", ERRORSTOP);

  // tst is 1, ALT is 0 and ALTS is 1
  apb_write (PXALT,    {`GPIO_CH{1'b0}});
  check_output(out_en, `GPIO_CH'h5555, COMP_ALL, "out_en not tst_dir", ERRORSTOP);

  // tst is 1, ALT is 0 and ALTS is 0
  apb_write (PXALTS,   {`GPIO_CH{1'b0}});
  check_output(out_en, `GPIO_CH'h5555, COMP_ALL, "out_en not tst_dir", ERRORSTOP);

  //restore reset values
  drive_tst ( 1'b0 );
  drive_tst_dir  ( {`GPIO_CH{1'b0}} );
  drive_alt_dira ( {`GPIO_CH{1'b0}} );
  drive_alt_dirb ( 16'b0000 );
  apb_write (PXDIR,    {`GPIO_CH{1'b0}});
  apb_write (PXALT,    {`GPIO_CH{1'b0}});
  apb_write (PXALTS,   {`GPIO_CH{1'b0}});


  $display ("\n****************** TESTING DATA OUTPUT *******************\n");

  // -> write unique pattern to all mux inputs
  // -> check all mux selection combination

  drive_tst_dout  ( `GPIO_CH'hAAAA );
  drive_alt_douta ( `GPIO_CH'h5555 );
  drive_alt_doutb ( {`GPIO_CH{1'b1}} );
  apb_write (PXDOUT,    {`GPIO_CH{1'b0}});

  // tst is 0, ALT is 0 and ALTS is 0
  drive_tst ( 1'b0 );
  apb_write (PXALT,    {`GPIO_CH{1'b0}});
  apb_write (PXALTS,   {`GPIO_CH{1'b0}});
  check_output(doutp, {`GPIO_CH{1'b0}}, COMP_ALL, "doutp default", ERRORSTOP);

  // tst is 0, ALT is 0 and ALTS is 1
  apb_write (PXALTS,   {`GPIO_CH{1'b1}});
  check_output(doutp, {`GPIO_CH{1'b0}}, COMP_ALL, "doutp default", ERRORSTOP);

  // tst is 0, ALT is 1 and ALTS is 1
  apb_write (PXALT,    {`GPIO_CH{1'b1}});
  check_output(doutp, {`GPIO_CH{1'b1}}, COMP_ALL,"doutp not altdoutb",ERRORSTOP);

  // tst is 0, ALT is 1 and ALTS is 0
  apb_write (PXALTS,   {`GPIO_CH{1'b0}});
  check_output(doutp, `GPIO_CH'h5555, COMP_ALL, "doutp not altdouta", ERRORSTOP);

  // tst is 1, ALT is 1 and ALTS is 0
  drive_tst ( 1'b1 );
  check_output(doutp, `GPIO_CH'hAAAA, COMP_ALL, "doutp not tst_dout", ERRORSTOP);

  // tst is 1, ALT is 1 and ALTS is 1
  apb_write (PXALTS,   {`GPIO_CH{1'b1}});
  check_output(doutp, `GPIO_CH'hAAAA, COMP_ALL, "doutp not tst_dout", ERRORSTOP);

  // tst is 1, ALT is 0 and ALTS is 1
  apb_write (PXALT,    {`GPIO_CH{1'b0}});
  check_output(doutp, `GPIO_CH'hAAAA, COMP_ALL, "doutp not tst_dout", ERRORSTOP);

  // tst is 1, ALT is 0 and ALTS is 0
  apb_write (PXALTS,   {`GPIO_CH{1'b0}});
  check_output(doutp, `GPIO_CH'hAAAA, COMP_ALL, "doutp not tst_dout", ERRORSTOP);
   
  // -> write inverted unique pattern to all mux inputs
  // -> check all mux selection combination

  drive_tst_dout  ( `GPIO_CH'h5555 );
  drive_alt_douta ( `GPIO_CH'hAAAA );
  drive_alt_doutb ( {`GPIO_CH{1'b0}} );
  apb_write (PXDOUT,    {`GPIO_CH{1'b1}});

  // tst is 0, ALT is 0 and ALTS is 0
  drive_tst ( 1'b0 );
  apb_write (PXALT,    {`GPIO_CH{1'b0}});
  apb_write (PXALTS,   {`GPIO_CH{1'b0}});
  check_output(doutp, {`GPIO_CH{1'b1}}, COMP_ALL, "doutp default", ERRORSTOP);

  // tst is 0, ALT is 0 and ALTS is 1
  apb_write (PXALTS,   {`GPIO_CH{1'b1}});
  check_output(doutp, {`GPIO_CH{1'b1}}, COMP_ALL, "doutp default", ERRORSTOP);

  // tst is 0, ALT is 1 and ALTS is 1
  apb_write (PXALT,    {`GPIO_CH{1'b1}});
  check_output(doutp,{`GPIO_CH{1'b0}},COMP_ALL,"doutp not altdoutb",ERRORSTOP);

  // tst is 0, ALT is 1 and ALTS is 0
  apb_write (PXALTS,   {`GPIO_CH{1'b0}});
  check_output(doutp, `GPIO_CH'hAAAA, COMP_ALL,"doutp not altdoutb",ERRORSTOP);

  // tst is 1, ALT is 1 and ALTS is 0
  drive_tst ( 1'b1 );
  check_output(doutp, `GPIO_CH'h5555, COMP_ALL, "doutp not tst_dout", ERRORSTOP);

  // tst is 1, ALT is 1 and ALTS is 1
  apb_write (PXALTS,   {`GPIO_CH{1'b1}});
  check_output(doutp, `GPIO_CH'h5555, COMP_ALL, "doutp not tst_dout", ERRORSTOP);

  // tst is 1, ALT is 0 and ALTS is 1
  apb_write (PXALT,    {`GPIO_CH{1'b0}});
  check_output(doutp, `GPIO_CH'h5555, COMP_ALL, "doutp not tst_dout", ERRORSTOP);

  // tst is 1, ALT is 0 and ALTS is 0
  apb_write (PXALTS,   {`GPIO_CH{1'b0}});
  check_output(doutp, `GPIO_CH'h5555, COMP_ALL, "doutp not tst_dout", ERRORSTOP);

  //restore reset values
  drive_tst ( 1'b0 );
  drive_tst_dout  ( {`GPIO_CH{1'b0}} );
  drive_alt_douta ( {`GPIO_CH{1'b0}} );
  drive_alt_doutb ( {`GPIO_CH{1'b0}} );
  apb_write (PXDOUT,   {`GPIO_CH{1'b0}});
  apb_write (PXALT,    {`GPIO_CH{1'b0}});
  apb_write (PXALTS,   {`GPIO_CH{1'b0}});

  $display ("\n******************** TESTING WEAK-PULLUP/ PULLDOWN************\n");

  //    test wkpu_en_b while input tst* = 0
  // -> WKPU = 0x00, DIR = 0x00 and 0xFF
  // -> WKPU = 0xFF, DIR = 0x00 and 0xFF

  apb_write (PXWKPU,   {`GPIO_CH{1'b0}});
  apb_write (PXDIR,    {`GPIO_CH{1'b0}});
  check_output(wkpu_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpu_en default", ERRORSTOP);
  check_output(wkpd_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpd_en default", ERRORSTOP);
  apb_write (PXDIR,    {`GPIO_CH{1'b1}});
  check_output(wkpu_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpu_en default", ERRORSTOP);
  check_output(wkpd_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpu_en default", ERRORSTOP);
  apb_write (PXWKPU,   {`GPIO_CH{1'b1}});
  check_output(wkpu_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpu_en default", ERRORSTOP);
  check_output(wkpd_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpu_en default", ERRORSTOP);
  apb_write (PXDIR,    {`GPIO_CH{1'b0}});
  check_output(wkpu_en,{`GPIO_CH{1'b1}}, COMP_ALL,"wkpu_en not FFFF", ERRORSTOP);
  check_output(wkpd_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpu_en default", ERRORSTOP);

  apb_write (PXPDR,    {`GPIO_CH{1'b0}});
  apb_write (PXWKPU,   {`GPIO_CH{1'b0}});
  apb_write (PXDIR,    {`GPIO_CH{1'b0}});
  check_output(wkpu_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpu_en default", ERRORSTOP);
  check_output(wkpd_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpd_en default", ERRORSTOP);
  apb_write (PXDIR,    {`GPIO_CH{1'b1}});
  check_output(wkpu_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpu_en default", ERRORSTOP);
  check_output(wkpd_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpu_en default", ERRORSTOP);
  apb_write (PXWKPU,   {`GPIO_CH{1'b1}});
  check_output(wkpu_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpu_en default", ERRORSTOP);
  check_output(wkpd_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpu_en default", ERRORSTOP);
  apb_write (PXDIR,    {`GPIO_CH{1'b0}});
  check_output(wkpu_en,{`GPIO_CH{1'b0}}, COMP_ALL,"wkpu_en not FFFF", ERRORSTOP);
  check_output(wkpd_en,{`GPIO_CH{1'b1}},COMP_ALL,"wkpu_en default", ERRORSTOP);

  //    test wkpu_en_b with all logical combination of tst and tst_wkpu_en_b
  // 1 -> tst = 1, tst_dir = 0,  tst_wkpu_en_b = 0      WKPU = 8'h00 PXPDR='h00  
  // 2 -> tst = 1, tst_dir = 0,  tst_wkpu_en_b = 8'hff, WKPU = 8'h00 PXPDR='h00  
  // 3 -> tst = 1, tst_dir = 55, tst_wkpu_en_b = 8'hff, WKPU = 8'h00 PXPDR='h00  
  // 4 -> tst = 1, tst_dir = AA, tst_wkpu_en_b = 8'hff, WKPU = 8'h00 PXPDR='h00  
  // 5 -> tst = 1, tst_dir = 0,  tst_wkpu_en_b = 8'hff, WKPU = 8'hff PXPDR='h00  
  // 6 -> tst = 1, tst_dir = 0,  tst_wkpu_en_b = 8'hff, WKPU = 8'h00 PXPDR='h00  
  // 7 -> tst = 1, tst_dir = 0,  tst_wkpu_en_b = 0,     WKPU = 8'h00 PXPDR='h00  
  // 8 -> tst = 1, tst_dir = 0,  tst_wkpu_en_b = 0,     WKPU = 8'hff PXPDR='h00  
  // 9 -> tst = 1, tst_dir = 0,  tst_wkpu_en_b = 0,     WKPU = 8'hff PXPDR='hFF
  // 10-> tst = 0, tst_dir = 0,  tst_wkpu_en_b = 0,     WKPU = 8'h00 PXPDR='h00

  apb_write (PXWKPU,   {`GPIO_CH{1'b0}});
  drive_tst ( 1'b1 );
  $display ("\n****1 check*******\n");
  check_output(wkpu_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpu_en default", ERRORSTOP);
  check_output(wkpd_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpd_en default", ERRORSTOP);
     
  $display ("\n****2 check*******\n");
  drive_tst_wkpu ( {`GPIO_CH{1'b1}} );
  check_output(wkpu_en, {`GPIO_CH{1'b1}}, COMP_ALL,"wkpu_en not FFFF", ERRORSTOP);
  check_output(wkpd_en, {`GPIO_CH{1'b0}},COMP_ALL,"wkpd_en default", ERRORSTOP);
     
  $display ("\n****3 check*******\n");
  drive_tst_dir  ( `GPIO_CH'h55555555 );
  check_output(wkpu_en, {`GPIO_CH'hAAAAAAAA}, COMP_ALL,"wkpu_en not AAAA", ERRORSTOP);
  check_output(wkpd_en, {`GPIO_CH{1'b0}},COMP_ALL,"wkpd_en default", ERRORSTOP);
     
  $display ("\n****4 check*******\n");
  drive_tst_dir  ( `GPIO_CH'hAAAAAAAA );
  check_output(wkpu_en, {`GPIO_CH'h55555555}, COMP_ALL,"wkpu_en not 5555", ERRORSTOP);
  check_output(wkpd_en, {`GPIO_CH{1'b0}},COMP_ALL,"wkpd_en default", ERRORSTOP);
     
  $display ("\n****5 check*******\n");
  drive_tst_dir  ( {`GPIO_CH{1'b0}} );
  apb_write (PXWKPU,   {`GPIO_CH{1'b1}});
  check_output(wkpu_en, {`GPIO_CH{1'b1}}, COMP_ALL,"wkpu_en not FFFF", ERRORSTOP);
  check_output(wkpd_en, {`GPIO_CH{1'b0}},COMP_ALL,"wkpd_en default", ERRORSTOP);
     
  $display ("\n****6 check*******\n");
  apb_write (PXWKPU,   {`GPIO_CH{1'b0}});
  check_output(wkpu_en,{`GPIO_CH{1'b1}},COMP_ALL,"wkpu_en not FFFF", ERRORSTOP);
  check_output(wkpd_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpd_en not 0000", ERRORSTOP);
     
  $display ("\n****7 check*******\n");
  drive_tst_wkpu ( {`GPIO_CH{1'b0}} );
  check_output(wkpu_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpu_en default", ERRORSTOP);
  check_output(wkpd_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpd_en default", ERRORSTOP);
     
  $display ("\n****8 check*******\n");
  apb_write (PXWKPU,   {`GPIO_CH{1'b1}});
  check_output(wkpu_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpu_en default", ERRORSTOP);
  check_output(wkpd_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpd_en default", ERRORSTOP);
     
  $display ("\n****9 check*******\n");
  apb_write (PXPDR,   {`GPIO_CH{1'b1}});
  check_output(wkpu_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpu_en default", ERRORSTOP);
  check_output(wkpd_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpd_en default", ERRORSTOP);
     
  apb_write (PXWKPU,   {`GPIO_CH{1'b0}});
  apb_write (PXPDR,   {`GPIO_CH{1'b0}});

  $display ("\n****10 check*******\n");
  drive_tst_wkpu ( {`GPIO_CH{1'b0}} );
  drive_tst ( 1'b0 );
  check_output(wkpu_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpu_en not 0000", ERRORSTOP);
  check_output(wkpd_en,{`GPIO_CH{1'b0}},COMP_ALL,"wkpu_en not 0000", ERRORSTOP);

  $display ("\n******************** TESTING READ ENABLE *****************\n");
 
  // -> test all logical combination of inputs while not reading DIN

  // tst is 0, alt_reg_b is 0 and din_read is 0 and inten is 0(reset state)
  check_output(rd_en,{`GPIO_CH{1'b0}},COMP_ALL,"rd_en not 0000", ERRORSTOP);
 
  // tst is 1, alt_reg_b is 0 and din_read  is 0 and inten is 0
  drive_tst ( 1'b1 );
  check_output(rd_en, {`GPIO_CH{1'b1}}, COMP_ALL,"rd_en not FFFF", ERRORSTOP);
 
  // tst is 1, alt_reg_b is 1 and din_read is 0 and inten is 0
  apb_write (PXALT,   {`GPIO_CH{1'b1}});
  check_output(rd_en, {`GPIO_CH{1'b1}}, COMP_ALL,"rd_en not FFFF", ERRORSTOP);

  // tst is 0, alt_reg_b is 1 and din_read is 0 and inten is 0
  drive_tst ( 1'b0 );
  check_output(rd_en, {`GPIO_CH{1'b1}}, COMP_ALL,"rd_en not FFFF", ERRORSTOP);
 
  // tst is 0, alt_reg_b is 0 and din_read is 0 and inten is 0
  apb_write (PXALT,   {`GPIO_CH{1'b0}});
  check_output(rd_en,{`GPIO_CH{1'b0}},COMP_ALL,"rd_en not 0000", ERRORSTOP);

  // tst is 0, alt_reg_b is 0 and din_read is 0 and inten is 1
  apb_write (PXIEN,   {`GPIO_CH{1'b1}});
  check_output(rd_en,{`GPIO_CH{1'b1}},COMP_ALL,"rd_en not FFFF", ERRORSTOP);

  // tst is 0, alt_reg_b is 0 and din_read is 0 and inten is 0
  apb_write (PXIEN,   {`GPIO_CH{1'b0}});
  check_output(rd_en,{`GPIO_CH{1'b0}},COMP_ALL,"rd_en not 0000", ERRORSTOP);
     
  $display ("\n******************** TESTING HIGH DRIVE ******************\n");
  
  // high_drive programmed with 0x5555
  apb_write (PXHDRV,   `GPIO_CH'h5555);
  check_output(high_drive, `GPIO_CH'h5555, COMP_ALL,"high_drive not 5555", ERRORSTOP);

  // high_drive programmed with 0xaaaa
  apb_write (PXHDRV,   `GPIO_CH'haaaa);
  check_output(high_drive, `GPIO_CH'haaaa, COMP_ALL,"high_drive not aaaa", ERRORSTOP);

  $display ("\n******************** TESTING alt_a_en ******************\n");

  // alt 0 alts 0
  apb_write (PXALTS,   {`GPIO_CH{1'b0}});
  apb_write (PXALT,   {`GPIO_CH{1'b0}});
  check_output(alt_a_en,{`GPIO_CH{1'b0}},COMP_ALL,"alt_a_en not 0000", ERRORSTOP);
  check_output(alt_b_en,{`GPIO_CH{1'b0}},COMP_ALL,"alt_b_en not 0000", ERRORSTOP);
     
  // alt 1 alts 0
  apb_write (PXALT,   {`GPIO_CH{1'b1}});
  check_output(alt_a_en,{`GPIO_CH{1'b1}},COMP_ALL,"alt_a_en not FFFF", ERRORSTOP);
  check_output(alt_b_en,{`GPIO_CH{1'b0}},COMP_ALL,"alt_b_en not 0000", ERRORSTOP);

  // alt 1 alts 1
  apb_write (PXALTS,   {`GPIO_CH{1'b1}});
  check_output(alt_a_en,{`GPIO_CH{1'b0}},COMP_ALL,"alt_a_en not 0000", ERRORSTOP);
  check_output(alt_b_en,{`GPIO_CH{1'b1}},COMP_ALL,"alt_b_en not FFFF", ERRORSTOP);
     
  // alt 0 alts 1
  apb_write (PXALT,   {`GPIO_CH{1'b0}});
  check_output(alt_a_en,{`GPIO_CH{1'b0}},COMP_ALL,"alt_a_en not 0000", ERRORSTOP);
  check_output(alt_b_en,{`GPIO_CH{1'b0}},COMP_ALL,"alt_b_en not 0000", ERRORSTOP);

  // alt 0 alts 0
  apb_write (PXALTS,   {`GPIO_CH{1'b0}});
  check_output(alt_a_en,{`GPIO_CH{1'b0}},COMP_ALL,"alt_a_en not 0000", ERRORSTOP);
  check_output(alt_b_en,{`GPIO_CH{1'b0}},COMP_ALL,"alt_b_en not 0000", ERRORSTOP);

  $display ("\n******************** TESTING INTERRUPT ******************\n");

  drive_dinp  ( {`GPIO_CH{1'b0}} );
  apb_write (PXDIR,   {`GPIO_CH{1'b0}});
  apb_write (PXALT,   {`GPIO_CH{1'b0}});
     
  // dinp 0 dout 0 ien 0
  apb_write (PXIEN,   {`GPIO_CH{1'b0}});
  apb_write (PXDOUT,  {`GPIO_CH{1'b0}});
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt <> 0", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt <> 0", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)

  // dinp 0 dout 0 ien 0->1 (interrupt ->1 after 1 cycle)
  apb_write (PXIEN,   {`GPIO_CH{1'b1}});
     # `INT_CHECK
  if(gpio_int != 1'b1)
     begin
	Error("gpio interrupt <> 1", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     
  // dinp 0 dout 0->1 ien 1 (interrupt ->0 )
  apb_write (PXDOUT,  {`GPIO_CH{1'b1}});
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt <> 0", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt <> 0", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)

  // dinp 0->1 dout 1 ien 1 (interrupt ->1 )
  drive_dinp  ( {`GPIO_CH{1'b1}} );
  if(gpio_int != 1'b1)
     begin
	Error("gpio interrupt <> 1", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b1)
     begin
	Error("gpio interrupt <> 1", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)

  // dinp 1 dout 1 ien 1->0 (interrupt ->0 )
  apb_write (PXIEN,  {`GPIO_CH{1'b0}});
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt <> 0", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt <> 0", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)

  // dinp 1 dout 1 ien 0->1 (interrupt ->1 after 1 cycle )
  apb_write (PXIEN,  {`GPIO_CH{1'b1}});
     # `INT_CHECK
  if(gpio_int != 1'b1)
     begin
	Error("gpio interrupt <> 1", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)

  // dinp 1 dout 1->0 ien 1 (interrupt ->0 )
  apb_write (PXDOUT,  {`GPIO_CH{1'b0}});
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt <> 0", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt <> 0", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)

  // dinp 1 dout 0->1 ien 1 (interrupt ->1 )
  apb_write (PXDOUT,  {`GPIO_CH{1'b1}});
  if(gpio_int != 1'b1)
     begin
	Error("gpio interrupt <> 1", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b1)
     begin
	Error("gpio interrupt <> 1", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
  // Report pass/fail / Finish simulation
  
  // dinp 1->0 dout 1 ien 1 (interrupt ->0 )
  drive_dinp  ( {`GPIO_CH{1'b0}} );
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt <> 0", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt <> 0", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)

  // dinp 0 dout 1->0 ien 1 (interrupt ->1 )
  apb_write (PXDOUT,  {`GPIO_CH{1'b0}});
  if(gpio_int != 1'b1)
     begin
	Error("gpio interrupt <> 1", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b1)
     begin
	Error("gpio interrupt <> 1", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)

  // dinp 0->1 dout 0 ien 1 (interrupt ->0 )
  drive_dinp  ( {`GPIO_CH{1'b1}} );
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt <> 0", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt <> 0", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)

  // dinp 1->0 dout 0 ien 1 (interrupt ->1 )
  drive_dinp  ( {`GPIO_CH{1'b0}} );
  if(gpio_int != 1'b1)
     begin
	Error("gpio interrupt <> 1", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b1)
     begin
	Error("gpio interrupt <> 1", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)

  // dinp 0 dout 0 ien 1->0 (interrupt ->0 )
  apb_write (PXIEN,  {`GPIO_CH{1'b0}});
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt <> 0", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt <> 0", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)

  // dinp 0->1 dout 0 ien 0 (interrupt = 0 )
  drive_dinp  ( {`GPIO_CH{1'b1}} );
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt <> 0", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt <> 0", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)

  // dinp 1 dout 0->1 ien 0 (interrupt = 0 )
  apb_write (PXDOUT,  {`GPIO_CH{1'b1}});
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt <> 0", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt <> 0", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)

  // dinp 1->0 dout 1 ien 0 (interrupt = 0 )
  drive_dinp  ( {`GPIO_CH{1'b0}});
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt <> 0", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)
     # `INT_CHECK
  if(gpio_int != 1'b0)
     begin
	Error("gpio interrupt <> 0", ERRORSTOP);
	fail = 1;
     end // if (gpio_int != 1'b0)

  // Report pass/fail / Finish simulation

  apb_end_test (fail);
	
end // of initial
		
endmodule //gpio_rdwr_regs.v





