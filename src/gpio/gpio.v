`timescale 1ns / 100ps
//----------------------------------------------------------------------------
// (c) Copyright 1998-2001, National Semiconductor Coporation
//----------------------------------------------------------------------------
// National Semiconductor Confidential. All Rights Reserved.
//----------------------------------------------------------------------------
// *Name: gpio.v
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
//    Children:         ck_gpio_xt_geh0.v
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
//                                 |                |----[n:0]-> rd_en
//              paddr >------[9:0]-|                |                    
//               pclk   >----------|                |----[n:0]-> tst_din
//              penable >----------|                |----[n:0]-> wkpu_en
//              presetn >----------| ============== |----[n:0]-> high_drive
//                 psel >----------|  gpio_xt_gee0  |----------> gpio_int
//               pwdata >---[15:0]-| ============== |----[n:0]-> alt_a_en
//               pwrite >----------|                |----[n:0]-> alt_b_en
//           scan_clken >----------|                |----[n:0]-> wkpd_en
//                                 |                |
//           scan_reset >----------|                |
//            scan_test >----------|                |
//                  tst >----------|                |
//              tst_dir >----[n:0]-|                |
//             tst_dout >----[n:0]-|                |
//          tst_wkpu_en >----[n:0]-|                |
//                                 |                |
//                                 |                |
//                                 +----------------+
//
//
//----------------------------------------------------------------------------
// *endName

module gpio (

// OUTPUTs
    alt_dina,                                // alternate A data in
    alt_dinb,                                // alternate B data in
    doutp,                                   // PAD data out
    out_en,                                  // PAD output enable
    prdata,                                  // 2S APB read data
    rd_en,                                   // PAD read/input enable
    
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
    
    paddr,                                   // 2S APB Register Address
    pclk,                                    // APB system clock (phi1)
    penable,                                 // 2V APB peripheral enable
    presetn,                                 // 1S/AS system reset (low active)
    psel,                                    // 2S chip/module select
    pwdata,                                  // 2S APB Register Write data
    pwrite,                                  // 2V APB peripheral write
    scan_clken,                              // Scan NAND gated clock enable
    
    scan_reset,                              // Scan test mode reset input
    scan_test,                               // Scan test enable
    scan_shift,                              // Scan Shift             
    tst,                                     // functional test mode enable
    tst_dir,                                 // functional test mode direction
    tst_dout,                                // functional test mode data out
    tst_wkpu_en                             // functional test mode pullup ena
    
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

input [9:0]           paddr;                 // 2S APB Register Address
input                 pclk;                  // APB system clock (phi1)
input                 penable;               // 2V APB peripheral enable
input                 presetn;               // 1S/AS system reset (low active)
input                 psel;                  // 2S chip/module select
input  [`GPIO_CH-1:0] pwdata;                // 2S APB Register Write data
input                 pwrite;                // 2V APB peripheral write
input                 scan_shift;            // Scan Shift
input                 scan_clken;            // Scan NAND gated clock enable
  
input                 scan_reset;            // Scan test mode reset input
input                 scan_test;             // Scan test enable
input                 tst;                   // functional test mode enable
input  [`GPIO_CH-1:0] tst_dir;               // functional test mode direction
input  [`GPIO_CH-1:0] tst_dout;              // functional test mode data out
input  [`GPIO_CH-1:0] tst_wkpu_en;           // functional test mode pullup ena



ck_gpio_xt_geh0
  xgpio
    (
     // Outputs
     .alt_dina                          (alt_dina[`GPIO_CH-1:0]),
     .alt_dinb                          (alt_dinb[`GPIO_CH-1:0]),
     .doutp                             (doutp[`GPIO_CH-1:0]),
     .out_en                            (out_en[`GPIO_CH-1:0]),
     .prdata                            (prdata[`GPIO_CH-1:0]),
     .rd_en                             (rd_en[`GPIO_CH-1:0]),
     .scan_out                          (),
     .tst_din                           (tst_din[`GPIO_CH-1:0]),
     .wkpu_en                           (wkpu_en[`GPIO_CH-1:0]),
     .wkpd_en                           (wkpd_en[`GPIO_CH-1:0]),
     .high_drive                        (high_drive[`GPIO_CH-1:0]),
     .alt_a_en                          (alt_a_en[`GPIO_CH-1:0]),
     .alt_b_en                          (alt_b_en[`GPIO_CH-1:0]),
     .gpio_int                          (gpio_int),
     // Inputs
     .alt_dira                          (alt_dira[`GPIO_CH-1:0]),
     .alt_dirb                          (alt_dirb[`GPIO_CH-1:0]),
     .alt_douta                         (alt_douta[`GPIO_CH-1:0]),
     .alt_doutb                         (alt_doutb[`GPIO_CH-1:0]),
     .dinp                              (dinp[`GPIO_CH-1:0]),
     .gnd                               (1'b0),
     .paddr                             (paddr[9:`ALSB]),
     .pclk                              (pclk),
     .penable                           (penable),
     .presetn                           (presetn),
     .psel                              (psel),
     .pwdata                            (pwdata[`GPIO_CH-1:0]),
     .pwrite                            (pwrite),
     .scan_shift                        (scan_shift),
     .scan_clken                        (scan_clken),
     .scan_in                           (2'b0),
     .scan_reset                        (scan_reset),
     .scan_test                         (scan_test),
     .tst                               (tst),
     .tst_dir                           (tst_dir[`GPIO_CH-1:0]),
     .tst_dout                          (tst_dout[`GPIO_CH-1:0]),
     .tst_wkpu_en                       (tst_wkpu_en[`GPIO_CH-1:0]),
     .vdd                               (1'b1));
   
endmodule  // of ck_gpio_xt_geh0


