`timescale 1ns / 100ps
//----------------------------------------------------------------------------
// (c) Copyright 1998-2001, National Semiconductor Coporation
//----------------------------------------------------------------------------
// National Semiconductor Confidential. All Rights Reserved.
//----------------------------------------------------------------------------
// *Name: gpio_xt_xxxx.v
// 
// *Module Description:  Scalable General Purpose I/O port for the
//                       AMBA APB (rev. E) bus
//
//    Notes:
//                       The PRDATA output is intended to use a central
//                       multiplexer.
//
//    Register Map:  
//			+-----------+-------------+--------+----------+
//			|    Name   |   int. Name |  addr. | ff/ff-sw |
//			+-----------+-------------+--------+----------+
//			|  PXALT    |   pxalt     |  x000  | ff-sw    |
//			+-----------+-------------+--------+----------+
//			|  PXDIR    |   pxdir     |  x002  | ff-sw    |
//			+-----------+-------------+--------+----------+
//			|  PXDIN    |   pxdin     |  x004  | no reg   |
//			+-----------+-------------+--------+----------+
//			|  PXDOUT   |   pxdout    |  x006  | ff-sw    |
//			+-----------+-------------+--------+----------+
//			|  PXWKPU   |   pxwkpu    |  x008  | ff-sw    |
//			+-----------+-------------+--------+----------+
//			|  PXHDRV   |   pxhdrv    |  x00a  | ff-sw    |
//			+-----------+-------------+--------+----------+
//			|  PXALTS   |   pxalts    |  x00c  | ff-sw    |
//			+-----------+-------------+--------+----------+
//			|  PXIEN    |   pxien     |  x00e  | ff-sw    |
//			+-----------+-------------+--------+----------+
//			|  PXPDR    |   pxpdr     |  x010  | ff-sw    |
//			+-----------+-------------+--------+----------+
//    
//
//    Parent:           None
//
//    Children:         None
//
//    Interface Diagram:  
//    ~~~~~~~~~~~~~~~~~~
//
//                                 +----------------+
//                                 |                |
//             alt_dira >----[n:0]-|                |----[n:0]-> alt_dina
//             alt_dirb >----[n:0]-|                |----[n:0]-> alt_dinb
//            alt_douta >----[n:0]-|                |----[n:0]-> doutp
//            alt_doutb >----[n:0]-|                |----[n:0]-> out_en
//                 dinp >----[n:0]-|                |----[n:0]-> prdata
//                  gnd >----------|                |----[n:0]-> rd_en
//              paddr >---[9:ALSB]-|                |----[1:0]-> scan_out
//               pclk   >----------|                |----[n:0]-> tst_din
//              penable >----------|                |----[n:0]-> wkpu_en
//              presetn >----------| ============== |----[n:0]-> high_drive
//                 psel >----------|  gpio_xt_gee0  |----------> gpio_int
//               pwdata >---[15:0]-| ============== |----[n:0]-> alt_a_en
//               pwrite >----------|                |----[n:0]-> alt_b_en
//           scan_clken >----------|                |----[n:0]-> wkpd_en
//              scan_in >----[1:0]-|                |
//           scan_reset >----------|                |
//            scan_test >----------|                |
//                  tst >----------|                |
//              tst_dir >----[n:0]-|                |
//             tst_dout >----[n:0]-|                |
//          tst_wkpu_en >----[n:0]-|                |
//                  vdd >----------|                |
//                                 |                |
//                                 +----------------+
//
//
//----------------------------------------------------------------------------
// *History:
//   03/30/04 Imported from : ck_gpio_xt_geg1
//   by /proj/cells/templates/bin/ip_setup_verilog , Version 1.9 
//
//   03/04/04 Imported from : ck_gpio_xt_geg0
//   by /proj/cells/templates/bin/ip_setup_verilog , Version 1.9 
//
//   10/27/03 Imported from : gpio_xt_gef0
//   by /proj/cells/templates/bin/ip_setup_verilog , Version 1.8 
//
//   06/10/03 Imported from : gpio_xt_gee2
//   by /proj/cells/templates/bin/ip_setup_verilog , Version 1.7 
//
//   04/16/03 Imported from : gpio_xt_gee1
//   by /proj/cells/templates/bin/ip_setup_verilog , Version 1.7 
//
//   11/29/02 Imported from : gpio_xt_gee0
//   by /proj/cells/templates/bin/ip_setup_verilog , Version 1.5 
//
//   11/28/02 Imported from : gpio_xt_ged0
//   by /proj/cells/templates/bin/ip_setup_verilog , Version 1.5 
//
//    Nov 18, 04 | Angelo Lo Cicero     RTL taken from the ck_gpio_xt_gef3
//                                      - corrected a bug seen in tst mode.
//                                        (the pull-up and pull-down signals
//                                        were not isolated in this mode).
//                                      - added a gated clock in the pxien_reg
//                                        register
//
//    Oct 27,03 | Olivier Girard        RTL taken from the gpio_xt_gef0
//                                      - change parameters PxPDR_RESET_VALUE,
//                                      PxWKPU_RESET_VALUE, PxALTS_RESET_VALUE,
//                                      and PxALT_RESET_VALUE
//                                      - remove  parallel_case statements
//
//    Nov 29, 02 | Angelo Lo Cicero     RTL taken from the gpio_xt_ged0
//                                      - added an Address Last significant bit
//                                        definition
//                                      - added a weak pull down enable output
//                                        signal and a PXPDR register
//                                        (pull direcion register)
//
//
//----------------------------------------------------------------------------
// *endName

module ck_gpio_xt_geh0 (

// OUTPUTs
    alt_dina,                                // alternate A data in
    alt_dinb,                                // alternate B data in
    doutp,                                   // PAD data out
    out_en,                                  // PAD output enable
    prdata,                                  // 2S APB read data
    rd_en,                                   // PAD read/input enable
    scan_out,                                // Scan test scan chain outputs
    tst_din,                                 // functional test mode data in
    wkpu_en,                                 // PAD weak pull up enable
    wkpd_en,                                 // PAD weak pull down enable
    high_drive,                              // PAD high drive capability
    alt_a_en,                                // alternate function-source a en
    alt_b_en,                                // alternate function-source b en
    gpio_int,                                // interrupt from the gpio

// INPUTs
    alt_dira,                                // alternate A direction
    alt_dirb,                                // alternate B direction
    alt_douta,                               // alternate A data out
    alt_doutb,                               // alternate B data out
    dinp,                                    // PAD data input
    gnd,                                     //
    paddr,                                   // 2S APB Register Address
    pclk,                                    // APB system clock (phi1)
    penable,                                 // 2V APB peripheral enable
    presetn,                                 // 1S/AS system reset (low active)
    psel,                                    // 2S chip/module select
    pwdata,                                  // 2S APB Register Write data
    pwrite,                                  // 2V APB peripheral write
    scan_clken,                              // Scan NAND gated clock enable
    scan_in,                                 // Scan test scan chain inputs
    scan_reset,                              // Scan test mode reset input
    scan_test,                               // Scan test enable
    scan_shift,                              // Scan Shift
    tst,                                     // functional test mode enable
    tst_dir,                                 // functional test mode direction
    tst_dout,                                // functional test mode data out
    tst_wkpu_en,                             // functional test mode pullup ena
    vdd                                      //
);

//============================================================================
// Input / Output  / Register declarations / Parameter declarations
//============================================================================

// OUTPUTs
output [`GPIO_CH-1:0] alt_dina;              // alternate A data in
output [`GPIO_CH-1:0] alt_dinb;              // alternate B data in
output [`GPIO_CH-1:0] doutp;                 // PAD data out
output [`GPIO_CH-1:0] out_en;                // PAD output enable
output [`GPIO_CH-1:0] prdata;                // 2S APB read data
output [`GPIO_CH-1:0] rd_en;                 // PAD read/input enable
output          [1:0] scan_out;              // Scan test scan chain outputs
output [`GPIO_CH-1:0] tst_din;               // functional test mode data in
output [`GPIO_CH-1:0] wkpu_en;               // PAD weak pull up enable
output [`GPIO_CH-1:0] wkpd_en;               // PAD weak pull down enable
output [`GPIO_CH-1:0] high_drive;            // PAD high drive capability
output [`GPIO_CH-1:0] alt_a_en;              // alternate function-source a en
output [`GPIO_CH-1:0] alt_b_en;              // alternate function-source b en
output                gpio_int;              // interrupt from the gpio

// INPUTs
input  [`GPIO_CH-1:0] alt_dira;              // alternate A direction
input  [`GPIO_CH-1:0] alt_dirb;              // alternate B direction
input  [`GPIO_CH-1:0] alt_douta;             // alternate A data out
input  [`GPIO_CH-1:0] alt_doutb;             // alternate B data out
input  [`GPIO_CH-1:0] dinp;                  // PAD data input
input                 gnd;                   //
input       [9:`ALSB] paddr;                 // 2S APB Register Address
input                 pclk;                  // APB system clock (phi1)
input                 penable;               // 2V APB peripheral enable
input                 presetn;               // 1S/AS system reset (low active)
input                 psel;                  // 2S chip/module select
input  [`GPIO_CH-1:0] pwdata;                // 2S APB Register Write data
input                 pwrite;                // 2V APB peripheral write
input                 scan_shift;            // Scan Shift
input                 scan_clken;            // Scan NAND gated clock enable
input           [1:0] scan_in;               // Scan test scan chain inputs
input                 scan_reset;            // Scan test mode reset input
input                 scan_test;             // Scan test enable
input                 tst;                   // functional test mode enable
input  [`GPIO_CH-1:0] tst_dir;               // functional test mode direction
input  [`GPIO_CH-1:0] tst_dout;              // functional test mode data out
input  [`GPIO_CH-1:0] tst_wkpu_en;           // functional test mode pullup ena
input                 vdd;                   //

// Register addresses

parameter       PXALT    =   10'b000_0000_000, // xx000
                PXDIR    =   10'b000_0000_001, // xx002
                PXDIN    =   10'b000_0000_010, // xx004
                PXDOUT   =   10'b000_0000_011, // xx006
                PXWKPU   =   10'b000_0000_100, // xx008
                PXHDRV   =   10'b000_0000_101, // xx00a
                PXALTS   =   10'b000_0000_110, // xx00c
                PXIEN    =   10'b000_0000_111, // xx00e
                PXPDR    =   10'b000_0001_000; // xx010

// Relative Register positions/order

parameter       NREG     =   9;              // Number of registers
           
parameter       PXALT_P  =   0,              // PXALT    rel. position
                PXDIR_P  =   1,              // PXDIR    rel. position
                PXDIN_P  =   2,              // PXDIN    rel. position
                PXDOUT_P =   3,              // PXDOUT   rel. position
                PXWKPU_P =   4,              // PXWKPU   rel. position
                PXHDRV_P =   5,              // PXHDRV   rel. position
                PXALTS_P =   6,              // PXALTS   rel. position
                PXIEN_P  =   7,              // PXIEN    rel. position
                PXPDR_P  =   8;              // PXPDR    rel. position
// Register decoder (one hot)

parameter       REG_BASE    =  'b1,  
                DEC_DEF     =  'b0,
                DEC_PXALT   = (REG_BASE << PXALT_P),
                DEC_PXDIR   = (REG_BASE << PXDIR_P),
                DEC_PXDIN   = (REG_BASE << PXDIN_P),
                DEC_PXDOUT  = (REG_BASE << PXDOUT_P),
                DEC_PXWKPU  = (REG_BASE << PXWKPU_P),
                DEC_PXHDRV  = (REG_BASE << PXHDRV_P),
                DEC_PXALTS  = (REG_BASE << PXALTS_P),
                DEC_PXIEN   = (REG_BASE << PXIEN_P),
                DEC_PXPDR   = (REG_BASE << PXPDR_P);

reg [`GPIO_CH-1:0]  prdata;
reg [`GPIO_CH-1:0]  prdata_next;
reg [NREG-1:0]  reg_dec;                // address decode output

//============================================================================
//                    Local clock and reset generation
//============================================================================

buf_gea1 phmul_buf_1 (.y(buf_pclk_c), .a(pclk));

// Generate local phi2 clock

inv_gea1 phmul_apbif_1 ( .y(clk_phi2_c), .a(buf_pclk_c));

// Local reset - high active - inverted presetn

wire preset = ~presetn;

// Scan test mode local reset is controller by scan_reset

wire reset = scan_test ? scan_reset : preset;

//============================================================================
//                        re-align addess
//============================================================================

wire [9:0]  paddr_in   = {{`ALSB{1'b0}},paddr[9:`ALSB]}; 
                  
//============================================================================
//                 Register decode / Read-Write strobes
//============================================================================

// Register address decode

always @(paddr_in)
  casex (paddr_in)
    PXALT  :        reg_dec  =  DEC_PXALT;
    PXDIR  :        reg_dec  =  DEC_PXDIR;
    PXDIN  :        reg_dec  =  DEC_PXDIN;
    PXDOUT :        reg_dec  =  DEC_PXDOUT;
    PXWKPU :        reg_dec  =  DEC_PXWKPU;
    PXHDRV :        reg_dec  =  DEC_PXHDRV;
    PXALTS :        reg_dec  =  DEC_PXALTS;
    PXIEN  :        reg_dec  =  DEC_PXIEN;
    PXPDR  :        reg_dec  =  DEC_PXPDR;
    default:        reg_dec  =  DEC_DEF;
  endcase

// APB Write

wire apb_write = pwrite & ~penable;

// Write strobe generation

function [NREG-1:0] reg_write;

  input [NREG-1:0] write_dec;
  input          write;
  input          sel;
  input          tmode;
  integer        i;

  begin
    for ( i=0; i < NREG; i=i+1 )
      reg_write[i] = (write_dec[i] & write & sel) | tmode;
  end
endfunction

wire [NREG-1:0] reg_wr = reg_write(reg_dec, apb_write, psel, scan_clken);

//============================================================================
//         Control registers (exclusively under software control)
//============================================================================
//
//                                         pwdata[15:0]
//                                             |
//                                             / 16
//                                             |
//                                             V                  
//                      reset--+  +-------------------------+            
//                             +--|R     regx_if[15:0]      |            
//                  +----      +--|>C                       |            
//   clk_phi2_c ----|    \     |  +-------------------------+            
//                  |NAND O----+               |                         
//   reg_wr[x]  ----|    / regx_if_wr (2Q)     / 16           
//                  +----                      V regx_if
//
// Registers use a NAND gated clock and are written on the boundary of an
// APB Setup / APB Enable cycle. 

// PXALT Register
// --------------

reg  [`GPIO_CH-1:0] pxalt;

`ifdef GATED_CLOCK
nand2_gea1 phmul_pxalt_wr  (.y(pxalt_wr_c),
                            .a(clk_phi2_c), .b(reg_wr[PXALT_P]));
`else
wire pxalt_wr_c = buf_pclk_c;
`endif
   
// synopsys async_set_reset "reset"
always @ (posedge pxalt_wr_c or posedge reset)
  if (reset)
   `ifdef PxALT_RESET_VALUE
      pxalt <= `PxALT_RESET_VALUE;
   `else
      pxalt <=  {`GPIO_CH{1'b0}};
   `endif
  `ifdef GATED_CLOCK
  else
  `else
  else if (reg_wr[PXALT_P])
  `endif
    pxalt <=  pwdata[`GPIO_CH-1:0];

// PXDIR Register
// --------------

reg  [`GPIO_CH-1:0] pxdir;

`ifdef GATED_CLOCK
nand2_gea1 phmul_pxdir_wr (.y(pxdir_wr_c),
                            .a(clk_phi2_c), .b(reg_wr[PXDIR_P]));
`else
wire pxdir_wr_c = buf_pclk_c;
`endif
   
// synopsys async_set_reset "reset"
always @ (posedge pxdir_wr_c or posedge reset)
  if (reset)
    pxdir <=  {`GPIO_CH{1'b0}};
  `ifdef GATED_CLOCK
  else
  `else
  else if (reg_wr[PXDIR_P])
  `endif
    pxdir <=  pwdata[`GPIO_CH-1:0];

// PXDOUT Register
// --------------
// Note: Register is not cleared upon reset

reg  [`GPIO_CH-1:0] pxdout;

`ifdef GATED_CLOCK
nand2_gea1 phmul_pxdout_wr (.y(pxdout_wr_c),
                            .a(clk_phi2_c), .b(reg_wr[PXDOUT_P]));
`else
wire pxdout_wr_c = buf_pclk_c;
`endif
   
always @ (posedge pxdout_wr_c)
  `ifdef GATED_CLOCK
  `else
  if (reg_wr[PXDOUT_P])
  `endif
    pxdout <=  pwdata[`GPIO_CH-1:0];

// PXWKPU Register
// ---------------

reg  [`GPIO_CH-1:0] pxwkpu;

`ifdef GATED_CLOCK
nand2_gea1 phmul_pxwkpu_wr (.y(pxwkpu_wr_c),
                            .a(clk_phi2_c), .b(reg_wr[PXWKPU_P]));
`else
wire pxwkpu_wr_c = buf_pclk_c;
`endif
   
// synopsys async_set_reset "reset"
always @ (posedge pxwkpu_wr_c or posedge reset)
  if (reset)
   `ifdef PxWKPU_RESET_VALUE
      pxwkpu <=  `PxWKPU_RESET_VALUE;
   `else
      pxwkpu <=  {`GPIO_CH{1'b0}};
   `endif
  `ifdef GATED_CLOCK
  else
  `else
  else if (reg_wr[PXWKPU_P])
  `endif
    pxwkpu <=  pwdata[`GPIO_CH-1:0];

// PXHDRV Register
// ---------------

reg  [`GPIO_CH-1:0] pxhdrv;

`ifdef GATED_CLOCK
nand2_gea1 phmul_pxhdrv_wr (.y(pxhdrv_wr_c),
                            .a(clk_phi2_c), .b(reg_wr[PXHDRV_P]));
`else
wire pxhdrv_wr_c = buf_pclk_c;
`endif

// synopsys async_set_reset "reset"
always @ (posedge pxhdrv_wr_c or posedge reset)
  if (reset)
    pxhdrv <=  {`GPIO_CH{1'b0}};
  `ifdef GATED_CLOCK
  else
  `else
  else if (reg_wr[PXHDRV_P])
  `endif
    pxhdrv <=  pwdata[`GPIO_CH-1:0];

// PXALTS Register
// ---------------

reg  [`GPIO_CH-1:0] pxalts;

`ifdef GATED_CLOCK
nand2_gea1 phmul_pxalts_wr (.y(pxalts_wr_c),
                            .a(clk_phi2_c), .b(reg_wr[PXALTS_P]));
`else
wire pxalts_wr_c = buf_pclk_c;
`endif
   
// synopsys async_set_reset "reset"
always @ (posedge pxalts_wr_c or posedge reset)
  if (reset)
   `ifdef PxALTS_RESET_VALUE
      pxalts <= `PxALTS_RESET_VALUE;
   `else
      pxalts <=  {`GPIO_CH{1'b0}};
   `endif
  `ifdef GATED_CLOCK
  else
  `else
  else if (reg_wr[PXALTS_P])
  `endif
    pxalts <=  pwdata[`GPIO_CH-1:0];

// PXIEN Register
// ---------------

reg  [`GPIO_CH-1:0] pxien;

`ifdef GATED_CLOCK
nand2_gea1 phmul_pxien_wr (.y(pxien_wr_c),
                            .a(clk_phi2_c), .b(reg_wr[PXIEN_P]));
`else
wire pxien_wr_c = buf_pclk_c;
`endif
   
// synopsys async_set_reset "reset"
always @ (posedge pxien_wr_c or posedge reset)
  if (reset)
    pxien <=  {`GPIO_CH{1'b0}};
  `ifdef GATED_CLOCK
  else
  `else
  else if (reg_wr[PXIEN_P])
  `endif
    pxien <=  pwdata[`GPIO_CH-1:0];

// PXPDR Register
// ---------------

reg  [`GPIO_CH-1:0] pxpdr;

`ifdef GATED_CLOCK
nand2_gea1 phmul_pxpdr_wr (.y(pxpdr_wr_c),
                            .a(clk_phi2_c), .b(reg_wr[PXPDR_P]));
`else
wire pxpdr_wr_c = buf_pclk_c;
`endif
   
// synopsys async_set_reset "reset"
always @ (posedge pxpdr_wr_c or posedge reset)
  if (reset)
   `ifdef PxPDR_RESET_VALUE
      pxpdr <=  `PxPDR_RESET_VALUE;
   `else
      pxpdr <=  {`GPIO_CH{1'b1}};
   `endif
  `ifdef GATED_CLOCK
  else
  `else
  else if (reg_wr[PXPDR_P])
  `endif
    pxpdr <=  pwdata[`GPIO_CH-1:0];

//============================================================================
//                      Read back mux, PRDATA output
//============================================================================
// Registers are read on the boundary of an APB Setup / APB Enable cycle 
// - an output register is used to improve the timing of the read data and
// to improve the scan coverage

wire apb_read = ~penable & ~pwrite & psel;

// Output data mux
 
always @(apb_read    or
         dinp        or
         paddr_in    or
         pxalt       or
         pxalts      or
         pxdir       or
         pxdout      or
         pxhdrv      or
         pxwkpu      or
         pxien       or
	 pxpdr
         )
  begin
    prdata_next = {`GPIO_CH{1'b0}};
    if(apb_read)    
      case (paddr_in)
        PXALT   :  prdata_next = {pxalt[`GPIO_CH-1:0]};
        PXDIR   :  prdata_next = {pxdir[`GPIO_CH-1:0]};
        PXDIN   :  prdata_next = {dinp[`GPIO_CH-1:0]};
        PXDOUT  :  prdata_next = {pxdout[`GPIO_CH-1:0]};
        PXWKPU  :  prdata_next = {pxwkpu[`GPIO_CH-1:0]};
        PXHDRV  :  prdata_next = {pxhdrv[`GPIO_CH-1:0]};
        PXALTS  :  prdata_next = {pxalts[`GPIO_CH-1:0]};
        PXIEN   :  prdata_next = {pxien[`GPIO_CH-1:0]};
        PXPDR   :  prdata_next = {pxpdr[`GPIO_CH-1:0]};
        default :  prdata_next = {`GPIO_CH{1'b1}};
      endcase
  end

// PRDATA Output Register - uses a nand gated clock to conserve power

`ifdef GATED_CLOCK
wire apb_rd_clk_en = apb_read | scan_test;
nand2_gea1 phmul_prdata (.y(prdata_reg_c), .a(clk_phi2_c), .b(apb_rd_clk_en));
`else
wire prdata_reg_c = buf_pclk_c;
`endif

// synopsys async_set_reset "reset"
always @ (posedge prdata_reg_c or posedge reset)
  if (reset)
    prdata <= {`GPIO_CH{1'b0}};
  `ifdef GATED_CLOCK
  else
  `else
  else if (apb_read)
  `endif
    prdata <= prdata_next;
     
//============================================================================
//                          GPIO Specific control
//============================================================================

// Output path

function [`GPIO_CH-1:0] gpiomux;

  input [`GPIO_CH-1:0] tstdata;
  input [`GPIO_CH-1:0] alta;
  input [`GPIO_CH-1:0] altb;
  input [`GPIO_CH-1:0] portdata;
  input [`GPIO_CH-1:0] tmode;
  input [`GPIO_CH-1:0] altmode;
  input [`GPIO_CH-1:0] altsource;

  integer i;

  begin
    for (i=0; i < `GPIO_CH; i=i+1)
      casex({tmode[i], altmode[i], altsource[i]})
        3'b00x : gpiomux[i] = portdata[i];
        3'b010 : gpiomux[i] = alta[i];
        3'b011 : gpiomux[i] = altb[i];
        3'b1xx : gpiomux[i] = tstdata[i];
      endcase
  end
endfunction // gpiomux

assign doutp  = gpiomux( tst_dout, alt_douta, alt_doutb, pxdout,
                        {`GPIO_CH{tst}}, pxalt, pxalts); 

assign out_en = gpiomux( tst_dir, alt_dira, alt_dirb, pxdir,
                        {`GPIO_CH{tst}}, pxalt, pxalts);
 
// Input path
// - generate tst_din  for functional test mode
// - generate alt_dina for alternate mode source A
// - generate alt_dinb for alternate mode source B
// - generate rd_en to enable the receive/input path of the i/o cell

assign tst_din  = tst ? dinp[`GPIO_CH-1:0] : {`GPIO_CH{1'b0}};
assign alt_dina = pxalt & ~pxalts & dinp;
assign alt_dinb = pxalt &  pxalts & dinp;

wire din_rd     = apb_read & reg_dec[PXDIN_P];
assign rd_en    = pxalt[`GPIO_CH-1:0] | {`GPIO_CH{tst}} | {`GPIO_CH{din_rd}}
                  | pxien[`GPIO_CH-1:0];

// Weak Pullup enable

assign wkpu_en  = tst? (tst_wkpu_en & ~tst_dir) : (pxwkpu & pxpdr & ~out_en);

// Weak Pulldown enable

assign wkpd_en  = tst? {`GPIO_CH{1'b0}} : (~pxpdr & pxwkpu & ~out_en);

// High drice enable

assign high_drive = pxhdrv;

// alt_a_en

assign alt_a_en = ~pxalts[`GPIO_CH-1:0] & pxalt[`GPIO_CH-1:0];

// alt_b_en

assign alt_b_en = pxalts[`GPIO_CH-1:0] & pxalt[`GPIO_CH-1:0];
   
// interrupt logic
// The register is used to avoid glitching the interrupt output when it's 
// first enabled an active low interrupt. In fact, if everything is set 
// for an active low interrupt (including the pin being high) except that 
// PxIEN is still 0, then the read strobe iws going to the IO cell, forcing 
// the input data line to 0. If is setted the PxIEN = 1, we would glitch 
// the interrupt line until the true data pin (one) gets thru the XNOR gate.

// the enable signal for the pxien_reg (that is pxien with 1 clock delay)
// is obtained delaying through 1 FF the enable signal of the pxien register.   
   
reg   reg_wr_pxien_del;
   
// synopsys async_set_reset "reset"
always @ (posedge buf_pclk_c or posedge reset)
  if (reset)
    reg_wr_pxien_del <=  1'b0;
  else
    reg_wr_pxien_del <=  reg_wr[PXIEN_P];

wire pxien_reg_wr_en = reg_wr_pxien_del | scan_shift;

`ifdef GATED_CLOCK
nand2_gea1 phmul_pxien_reg_wr (.y(pxien_reg_wr_c),
                               .a(clk_phi2_c), .b(pxien_reg_wr_en));
`else
wire pxien_reg_wr_c = buf_pclk_c;
`endif
   
reg  [`GPIO_CH-1:0] pxien_reg;

// synopsys async_set_reset "reset"
always @ (posedge pxien_reg_wr_c or posedge reset)
  if (reset)
    pxien_reg <=  {`GPIO_CH{1'b0}};
  `ifdef GATED_CLOCK
  else
  `else
  else if (pxien_reg_wr_en)
  `endif
    pxien_reg <=  pxien[`GPIO_CH-1:0];

wire [`GPIO_CH-1:0] cond = dinp ~^ pxdout;
   
wire [`GPIO_CH-1:0] pre_int = cond & pxien & pxien_reg;
   
assign gpio_int = | pre_int;
   
endmodule  // of ck_gpio_xt_geh0


