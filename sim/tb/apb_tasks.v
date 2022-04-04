//----------------------------------------------------------------------------
// (c) Copyright 1998-2001, National Semiconductor Coporation
//----------------------------------------------------------------------------
// National Semiconductor Confidential. All Rights Reserved.
//----------------------------------------------------------------------------
// *Name: apb_tasks.v
// 
// *Module Description:  Read and Write tasks to emulate the AMBA APB protocol
// 
//
//    Parent:           None
//
//    Children:         None
//
//    Interface Diagram:  
//    ~~~~~~~~~~~~~~~~~~
//
//----------------------------------------------------------------------------
// *History:
//
//    Feb 05, 01 | Wolfgang Hoeld        V1.0 First Edit / Created
//----------------------------------------------------------------------------
// *endName


//============================================================================
//                 Register / Wire / Parameter definitions
//============================================================================

parameter PDATA_WIDTH = `GPIO_CH;    // PWDATA and PRDATA width
parameter PADDR_WIDTH = 12;          // PADDR width

wire [PDATA_WIDTH-1:0]   prdata;

reg  [PADDR_WIDTH-1:0]   paddr;
reg                      penable;
reg                      presetn;
reg                      psel;
reg                      pwrite;
reg  [PDATA_WIDTH-1:0]   pwdata;

//============================================================================
//                            Reset Task
//============================================================================

task apb_reset;
   
   begin
     @(posedge pclk);
     psel    <= 1'bx;
     pwrite  <= 1'bx;
     paddr   <= {PADDR_WIDTH{1'b0}};
     pwdata  <= {PDATA_WIDTH{1'b0}};
     presetn <= #(`TIHNRES) 1'b0;
     @(posedge pclk);
     psel    <= 1'b0;
     pwrite  <= 1'b0;
     presetn <= #(`TCLKL + `TCLKH - `TISNRES)1'b1;
   end

endtask
 

//============================================================================
//                            APB Read Task
//============================================================================
 
task apb_read;
 
  input [PADDR_WIDTH-1:0] address;
  input [PDATA_WIDTH-1:0] compare_data;
  input [PDATA_WIDTH-1:0] compare_mask;
  input                   stop_on_error;

  begin

    // APB Setup cycle
    @(posedge pclk);
    paddr   <=  #(`TCLKL + `TCLKH - `TISPA)    address;
    psel    <=  #(`TCLKL + `TCLKH - `TISPSEL)  1'b1;
    pwrite  <=  #(`TCLKL + `TCLKH - `TISPW)    1'b0;

    // APB Enable cycle
    @(posedge pclk);
    penable <=  #(`TCLKL + `TCLKH - `TISPEN)   1'b1;

    // Sample the data on the R.E. of pclk - deassert controls 
    @(posedge pclk);
    // Check read data
    apb_read_check (address, prdata, compare_data, compare_mask, stop_on_error);
    psel      <= #(`TIHPSEL) 1'b0;
    penable   <= #(`TIHPEN)  1'b0;
    pwrite    <= #(`TIHPW)   1'b0;
    paddr     <= #(`TIHPA)   {PADDR_WIDTH{1'b0}};
   
  end

endtask

//============================================================================
//                            APB Write Task
//============================================================================


task apb_write;
 
  input [PADDR_WIDTH-1:0] address;
  input [PDATA_WIDTH-1:0] data;

  begin

    // APB Setup cycle
    @(posedge pclk);
    @(posedge pclk);
    paddr   <=  #(`TCLKL + `TCLKH - `TISPA)    address;
    psel    <=  #(`TCLKL + `TCLKH - `TISPSEL)  1'b1;
    pwdata  <=  #(`TCLKL + `TCLKH - `TISPWD)   data;
    pwrite  <=  #(`TCLKL + `TCLKH - `TISPW)    1'b1;

    // APB Enable cycle
    @(posedge pclk);
    penable <=  #(`TCLKL + `TCLKH - `TISPEN)   1'b1;

    // Deassert data and control at the end of the APB Enable cycle
    @(posedge pclk);
    paddr     <= #(`TIHPA)   {PADDR_WIDTH{1'b0}};
    psel      <= #(`TIHPSEL) 1'b0;
    penable   <= #(`TIHPEN)  1'b0;
    pwrite    <= #(`TIHPW)   1'b0;
    pwdata    <= #(`TIHPWD)  {PDATA_WIDTH{1'b0}};  

  end

endtask


//============================================================================
//                            APB Write/Read Task
//============================================================================


task apb_write_read;
 
  input [PADDR_WIDTH-1:0] address;
  input [PDATA_WIDTH-1:0] data;
  input [PDATA_WIDTH-1:0] compare_data;
  input [PDATA_WIDTH-1:0] compare_mask;
  input                   stop_on_error;

  begin

    // APB Setup cycle - Write
    @(posedge pclk);
    @(posedge pclk);
    paddr   <=  #(`TCLKL + `TCLKH - `TISPA)    address;
    psel    <=  #(`TCLKL + `TCLKH - `TISPSEL)  1'b1;
    pwdata  <=  #(`TCLKL + `TCLKH - `TISPWD)   data;
    pwrite  <=  #(`TCLKL + `TCLKH - `TISPW)    1'b1;

    // APB Enable cycle - Write
    @(posedge pclk);
    penable <=  #(`TCLKL + `TCLKH - `TISPEN)   1'b1;

    // APB Setup cycle - Read
    @(posedge pclk);
    penable   <= #(`TIHPEN)  1'b0;
    psel      <= #(`TIHPSEL) 1'bx;
    psel      <= #(`TCLKL + `TCLKH - `TISPSEL)  1'b1;
    pwrite    <= #(`TIHPW)   1'b0;
    pwdata    <= #(`TIHPWD)  {PDATA_WIDTH{1'b0}};

    // APB Enable cycle - Read
    @(posedge pclk);
    penable <=  #(`TCLKL + `TCLKH - `TISPEN)   1'b1;

    // Sample the data on the R.E. of pclk - deassert controls 
    @(posedge pclk);
    // Check read data
    apb_read_check (address, prdata, compare_data, compare_mask, stop_on_error);
    psel      <= #(`TIHPSEL) 1'b0;
    penable   <= #(`TIHPEN)  1'b0;
    pwrite    <= #(`TIHPW)   1'b0;
    paddr     <= #(`TIHPA)   {PADDR_WIDTH{1'b0}};   

  end

endtask
  

//============================================================================
//                         APB read check task
//============================================================================

task apb_read_check;

  input [PADDR_WIDTH-1:0] addr;
  input [PDATA_WIDTH-1:0] act_data;
  input [PDATA_WIDTH-1:0] comp_data;
  input [PDATA_WIDTH-1:0] comp_mask;
  input                   stop_on_error;

  begin
    if ( (act_data & comp_mask) !== (comp_data & comp_mask) )
      begin
       $display("APB Read Error from address %h at %t ", addr, $time);
       $display("Act: %h Exp: %h Mask: %h ", act_data, comp_data, comp_mask);
       fail = 1'b1;
       if (stop_on_error)
         $finish;
      end
    else
      begin
        $display("APB Read for address %h passed at %t", addr, $time);
        $display("Data:  %h Mask: %h ", act_data, comp_mask);
      end
  end
endtask
 
//============================================================================
//                         APB end test task
//============================================================================

task apb_end_test;

  input status;

  begin
    if (status == 1'b1)
      begin
        $display ("+-----------------------------------------------------+");
        $display ("|                  TEST FAILED :-(                    |");
        $display ("+-----------------------------------------------------+");
      end
    else
      begin
        $display ("+-----------------------------------------------------+");
        $display ("|                  TEST PASSED :-)                    |");
        $display ("+-----------------------------------------------------+");
      end
     $finish;
  end
endtask



         




