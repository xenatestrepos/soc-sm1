//----------------------------------------------------------------------------
// (c) Copyright 1998-2001, National Semiconductor Coporation
//----------------------------------------------------------------------------
// National Semiconductor Confidential. All Rights Reserved.
//----------------------------------------------------------------------------
// *Name: test_ck_gpio_xt_xxxx.v
// 
// *Module Description:  Testbench for AMBA APB scaleable GPIO module
// 
//
//    Parent:            test_top.v
//
//    Children:          apb_monitor.v
//                       apbif_xxxx.v        
//
//    Interface Diagram:  
//    ~~~~~~~~~~~~~~~~~~
//
//----------------------------------------------------------------------------
// *History:
//
//    Feb 28, 01 | Wolfgang Hoeld        V1.0 First Edit / Created
//----------------------------------------------------------------------------
// *endName

//============================================================================
//  Parameter declarations / Register declarations / Wire declarations
//============================================================================

// Parameter definitions

parameter  PXALT       = 'h00,      //PXALT  address
           PXDIR       = 'h02,      //PXDIR  address
           PXDIN       = 'h04,      //PXDIN  address
           PXDOUT      = 'h06,      //PXDOUT address
           PXWKPU      = 'h08,      //PXWKU  address
           PXALTS      = 'h0c,      //PXALTS address
           PXHDRV      = 'h0a,      //PXHDRV address
           PXIEN       = 'h0e,      //PXIEN  address
           PXPDR       = 'h10;      //PXPDR  address


// Register and wire  declarations

reg  [`GPIO_CH-1:0] alt_douta;
reg  [`GPIO_CH-1:0] alt_doutb;
reg  [`GPIO_CH-1:0] alt_dira;
reg  [`GPIO_CH-1:0] alt_dirb;
reg  [`GPIO_CH-1:0] dinp;
reg 	            fail;
reg                 pclk;
reg                 scan_clken;
//reg           [1:0] scan_in;
reg                 scan_reset;
reg                 scan_shift; 
reg                 scan_test;
reg                 tst; 
reg  [`GPIO_CH-1:0] tst_dir;
reg  [`GPIO_CH-1:0] tst_dout;
reg  [`GPIO_CH-1:0] tst_wkpu_en;

wire [`GPIO_CH-1:0] alt_dina;
wire [`GPIO_CH-1:0] alt_dinb;
wire [`GPIO_CH-1:0] din;
wire [`GPIO_CH-1:0] doutp;
wire [`GPIO_CH-1:0] out_en;
wire [`GPIO_CH-1:0] rd_en;         
//wire          [1:0] scan_out;
wire [`GPIO_CH-1:0] tst_din;
wire [`GPIO_CH-1:0] wkpu_en;
wire [`GPIO_CH-1:0] wkpd_en;
wire [`GPIO_CH-1:0] high_drive;
wire [`GPIO_CH-1:0] alt_a_en;
wire [`GPIO_CH-1:0] alt_b_en;
wire                gpio_int;


`include "apb_slave_timing.inc"     // APB slave timing definitions
`include "apb_tasks.v"              // APB Read/Write tasks
`include "ck_gpio_xt_tasks.v"          // GPIO specific test tasks          

//============================================================================
//      Clock generation 
//============================================================================

initial
  begin
    pclk = 1'b0;
    forever
      begin
        #`TCLKL pclk = 1'b1;
        #`TCLKH pclk = 1'b0;
      end

  end  // of initial
 

//============================================================================
//      APB Slave Bus Monitor 
//============================================================================

apb_slave_monitor #(`GPIO_CH) apb_slave_monitor (

// INPUTs
 .pclk   (pclk),    // I-APB PHI1 system clock
 .penable(penable), // I-2S  APB peripheral enable
 .prdata (prdata),  // I-2V  APB read data
 .presetn(presetn), // I-1S  APB peripheral reset
 .psel   (psel),    // I-2S  APB peripheral select
 .pwdata (pwdata),  // I-2S  APB peripheral write data
 .pwrite (pwrite)   // I-2S  APB peripheral write
);

//============================================================================
//      Module/Device under test (DUT) 
//============================================================================

gpio dut (

// OUTPUTs
 .alt_dina     (alt_dina),      // O-alternate A data in
 .alt_dinb     (alt_dinb),      // O-alternate B data in
 .doutp        (doutp),         // O-PAD data out
 .out_en       (out_en),        // O-PAD output enable
 .prdata       (prdata[`GPIO_CH-1:0]),   // O-2S APB read data
 .rd_en        (rd_en),         // O-PAD read/input enable
 
 .tst_din      (tst_din),       // O-functional test mode data in
 .wkpu_en      (wkpu_en),       // O-PAD weak pull up enable
 .wkpd_en      (wkpd_en),       // O-PAD weak pull up enable
 .high_drive   (high_drive),    // O-PAD high drive capability
 .alt_a_en     (alt_a_en),      // O-alternate function-source a en
 .alt_b_en     (alt_b_en),      // O-alternate function-source a en
 .gpio_int     (gpio_int),      // O-interrupt from the gpio

// INPUTs
 .alt_dira     (alt_dira),      // I-alternate A direction
 .alt_dirb     (alt_dirb),      // I-alternate B direction
 .alt_douta    (alt_douta),     // I-alternate A data out
 .alt_doutb    (alt_doutb),     // I-alternate B data out
 .dinp         (dinp),          // I-PAD data input
 
 .paddr        ({paddr[10-`ALSB:1],{`ALSB{1'b0}}}),    // I-2S APB Register Address
 .pclk         (pclk),          // I-APB system clock (phi1)
 .penable      (penable),       // I-2V APB peripheral enable
 .presetn      (presetn),       // I-1S/AS system reset (low active)
 .psel         (psel),          // I-2S chip/module select
 .pwdata       (pwdata[`GPIO_CH-1:0]),   // I-2S APB Register Write data
 .pwrite       (pwrite),        // I-2V APB peripheral write
 
 .scan_clken   (scan_clken),    // I-Scan NAND gated clock enable
 .scan_shift   (scan_shift),    // I-Scan NAND gated clock enable          
 .scan_reset   (scan_reset),    // I-Scan test mode reset input
 .scan_test    (scan_test),     // I-Scan test enable
 .tst          (tst),           // I-functional test mode enable
 .tst_dir      (tst_dir),       // I-functional test mode direction
 .tst_dout     (tst_dout),      // I-functional test mode data out
 .tst_wkpu_en  (tst_wkpu_en)   // I-functional test mode pullup ena.
 
);

// Emulate input path

assign din = rd_en & dinp;
 
//============================================================================
//      SDF annotation / VCD file generation
//============================================================================

// enable sdf backannotation for gate level simulation

initial
  begin
 
  `ifdef SDF_FILE
   $sdf_annotate(`SDF_FILE, test_top.dut, , "sdf.log", "TOOL_CONTROL", "1.0:1.0:1.0", "FROM_MTM");
  `endif
  end  // of initial
	

// generate a vcd - dump file

initial
  begin
    `ifdef DO_DUMPVARS
     $dumpfile(`DUMPFILE);
     $dumpvars( 0, test_top);				
    `endif
  end // of initial	


//============================================================================
//     General initialization
//============================================================================

initial
  begin
    alt_dira    = {`GPIO_CH{1'b0}};
    alt_dirb    = {`GPIO_CH{1'b0}};
    alt_douta   = {`GPIO_CH{1'b0}};
    alt_doutb   = {`GPIO_CH{1'b0}};
    fail        = 0;
    presetn     = 0;
    penable     = 0;
    pwrite      = 0;
    scan_clken  = 0;
  //  scan_in     = {2{1'b0}};
    scan_reset  = 0;
    scan_shift  = 0;
    scan_test   = 0;
    tst         = 0;
    tst_dir     = {`GPIO_CH{1'b0}};
    tst_wkpu_en = {`GPIO_CH{1'b0}};
  end // of initial







