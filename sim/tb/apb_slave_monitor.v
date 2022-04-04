`timescale 1ns / 100ps
//-----------------------------------------------------------------------
// (c) Copyright 1998-2001, National Semiconductor Coporation
//-----------------------------------------------------------------------
// National Semiconductor Confidential. All Rights Reserved.
//-----------------------------------------------------------------------
// *Name: apb_slave_monitor.v
//
// *Module Description:  Bus/protocol monitor for an AMBA APB slave
//			 
//    Parent:	
//
//    Children:	
//
//    Interface Diagram:
//    ~~~~~~~~~~~~~~~~~~
//
//                                 +---------------------+
//                                 |                     |
//                 pclk >----------|                     |
//              penable >----------|                     |
//               prdata >---[15:0]-| =================== |
//              presetn >----------|  apb_slave_monitor  |
//                 psel >----------| =================== |
//               pwdata >---[15:0]-|                     |
//               pwrite >----------|                     |
//                                 |                     |
//                                 +---------------------+
//
// *endName
//-----------------------------------------------------------------------
// *Modification History:
// 
//  02/06/01 	Wolfgang Hoeld      - First edit / Created
//  12/12/02 	Angelo Lo Cicero    - Added parameter for the data width
//
//----------------------------------------------------------------------

module apb_slave_monitor (
                     // INPUTs
                     pclk,
                     presetn,
                     penable,
                     prdata,
                     psel,
                     pwdata,
                     pwrite
                     );
   
parameter WIDTH     = 16;

//============================================================================
// Input / Output  / Register declarations / Parameter declarations
//============================================================================

input                       pclk;             // APB PHI1 system clock
input                       presetn;          // 1S  APB peripheral reset
input                       penable;          // 2S  APB peripheral enable
input                [WIDTH-1:0] prdata;           // 2V  APB read data
input                       psel;             // 2S  APB peripheral select 
input                [WIDTH-1:0] pwdata;           // 2S  APB peripheral write data 
input                       pwrite;           // 2S  APB peripheral write 
   
parameter stoponerror       = 0;              // Stop simulation upon error
parameter resetcheck        = 0;              // Check while reset is active


//============================================================================
// Protocol check:  PWDATA
//============================================================================


always @(posedge penable)
  begin
    if (presetn | resetcheck)
      if (xorz(WIDTH, pwdata))
        msgout("Warning: PWDATA contains X or Z on PENABLE rising edge", 0);
  end

always @(negedge penable)
  begin
    if (presetn | resetcheck)
      if (xorz(WIDTH, pwdata))
        msgout("Warning: PWDATA contains X or Z on PENABLE falling edge", 0);
  end

//============================================================================
// Protocol check:  PRDATA change during setup cycle
//============================================================================

reg [WIDTH-1:0] prev_prdata;

always @(posedge pclk)
  begin
    if (presetn | resetcheck)
      if (!penable & psel & !pwrite & (prev_prdata !== prdata))
        msgout("ERROR: PRDATA change during APB setup / PWRITE=0 / PSEL=1", 0);
      else
        prev_prdata <= prdata;
    else
      prev_prdata <= prdata;
       
  end

always @(posedge pclk)
  begin
    if (presetn | resetcheck)
      if (!penable & psel & pwrite & (prev_prdata !== prdata))
        msgout("ERROR: PRDATA change during APB setup / PWRITE=1 / PSEL=1", 0);
      else
        prev_prdata <= prdata;
    else
      prev_prdata <= prdata;
  end

always @(posedge pclk)
  begin
    if (presetn | resetcheck)
      if (!penable & !psel & !pwrite & (prev_prdata !== prdata))
        msgout("ERROR: PRDATA change during APB setup / PWRITE=0 / PSEL=0", 0);
      else
        prev_prdata <= prdata;
    else
      prev_prdata <= prdata;
  end

always @(posedge pclk)
  begin
    if (presetn | resetcheck)
      if (!penable & !psel & pwrite & (prev_prdata !== prdata))
        msgout("ERROR: PRDATA change during APB setup / PWRITE=1 / PSEL=0", 0);
      else
        prev_prdata <= prdata;
    else
      prev_prdata <= prdata;
  end

//============================================================================
// Protocol check:  PRDATA on rising edge of pclk with penable=1
//============================================================================

always @(posedge pclk)
  begin
    if (presetn | resetcheck)
      if (!pwrite & !psel & penable & xorz(WIDTH, prdata))
        msgout("ERROR: PRDATA X or Z on read sample / PWRITE=0 / PSEL=0", 0);
  end

always @(posedge pclk)
  begin
    if (presetn | resetcheck)
      if (!pwrite & psel & penable & xorz(WIDTH, prdata))
        msgout("ERROR: PRDATA X or Z on read sample / PWRITE=0 / PSEL=1", 0);
  end

//============================================================================
// APB Slave Timing Checks (PRDATA)
//============================================================================
// Timing checks use the verilog system tasks ($setup, $hold) 

wire apb_read  = penable & !pwrite & (presetn | resetcheck);

// Timing violation fail flags

reg tsprd_fail;
reg thprd_fail;

// Specify APB timing parameters - timing information from apb_slave_timing.inc

specify

// Setup and Hold times
`define TSPRD (`TCLKH + `TCLKL - `TOVPRD)
specparam tsprd   = `TSPRD;              // PRDATA setup
specparam thprd   = `TOHPRD;             // PRDATA hold    
 
// Setup and Hold time checks

$setup (prdata, posedge pclk &&& apb_read,  tsprd,   tsprd_fail); // PRDATA
$hold  (posedge pclk &&& apb_read,  prdata, thprd,   thprd_fail); //PRDATA

endspecify

// Timing check messages (50 characters maximum)

parameter [399:0] tsprd_msg  = "PRDATA setup time violation";
parameter [399:0] thprd_msg  = "PRDATA hold  time violation";

// Report time check fail events
 
always @(tsprd_fail) time_msgout(tsprd_msg, tsprd,     stoponerror);
always @(thprd_fail) time_msgout(thprd_msg, thprd,     stoponerror);

//============================================================================
// Generic functions and tasks called by the apb bus monitor
//============================================================================


// Determine if data contains x or z 

function xorz;
  input  [7:0] inwidth;
  input [WIDTH-1:0] datain ;
  reg   temp_xorz;
  
  integer i;
  
  begin
    temp_xorz = 0;
    for (i=0 ; i < inwidth; i=i+1)
        temp_xorz = (temp_xorz | datain[i] == 1'bx | datain[i] == 1'bz);
    xorz = temp_xorz;
  end
endfunction // xorz

// Message Output

task msgout;
  input [639:0] out_message;
  input stopsim;
  
  begin
    $display("%t: %0s", $time, out_message);
    if (stopsim)
      $finish;
    else
      $display("Continuing simulation ...");
  end
endtask // msgout

// Timing check message out

task time_msgout;
  input [399:0] out_message;
  input timing;
  input stopsim;
  
  begin
    $display("%t: Timing!!: %0s Spec. %0s", $time, out_message, timing);
    if (stopsim)
      $finish;
    else
      $display("Continuing simulation ...");
  end
endtask // msgout


endmodule  // apb_slave_monitor
