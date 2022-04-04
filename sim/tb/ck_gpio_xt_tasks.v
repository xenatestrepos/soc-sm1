//----------------------------------------------------------------------------
// (c) Copyright 1998-2001, National Semiconductor Coporation
//----------------------------------------------------------------------------
// National Semiconductor Confidential. All Rights Reserved.
//----------------------------------------------------------------------------
// *Name: gpio_xt_tasks.v
// 
// *Module Description:  Test tasks for the AMBA APB scaleable GPIO module
// 
//
//    Parent:            test_gpio_xt_xxxx.v
//
//    Children:          None     
//
//    Interface Diagram:  
//    ~~~~~~~~~~~~~~~~~~
//
//----------------------------------------------------------------------------
// *History:
//
//    Feb 28, 01 | Wolfgang Hoeld        V1.0 Created from test_tasks.v
//----------------------------------------------------------------------------

parameter PERIOD  = `TCLKL + `TCLKH;
parameter T_SETUP = 0.25 * PERIOD;

//-----------------------------------------------------------------------------
// Task to check value on any output bus
//-----------------------------------------------------------------------------

task check_output;

 input [`GPIO_CH-1:0] value;
 input [`GPIO_CH-1:0] expected;
 input [`GPIO_CH-1:0] mask;
 input        [159:0] message;
 input                stoponfail;
 
 begin
   if ((value & mask) != (expected & mask))
     begin
       Error(message, stoponfail);
       fail = 1;
     end
 end
       
endtask

//-----------------------------------------------------------------------------
// Task for reporting error messages
//-----------------------------------------------------------------------------

task Error;

   input [8*20:0] error_case;
   input          stoponfail;

   reg   [8*20:0] error;

   begin
     error = error_case;
     $display("ERROR: %s check failed at time ", error, $time , "\n\n\n");
     if (stoponfail)
       begin 
         repeat (5) @(posedge pclk);
         $finish;
       end
   end

endtask

//-----------------------------------------------------------------------------
// Task to drive a value to tst input
//-----------------------------------------------------------------------------

task drive_tst;

    input	tst_value;		// value to be driven to tst

    begin				// drive value to tst
	@(posedge pclk);
        #(PERIOD - T_SETUP);            // drive value with chosen setup time
        tst = tst_value;

	@(posedge pclk);		// wait for end of period
    end

endtask

//-----------------------------------------------------------------------------
// Task to drive a value to tst_wkpu_en_b input
//-----------------------------------------------------------------------------

task drive_tst_wkpu;

    input [`GPIO_CH-1:0] tst_wkpu_value; // value to be driven to tst_wkpu_en_b

    begin				// drive value to tst
	@(posedge pclk);
        #(PERIOD - T_SETUP);            // drive value with chosen setup time
        tst_wkpu_en = tst_wkpu_value;

	@(posedge pclk);		// wait for end of period
    end

endtask

//-----------------------------------------------------------------------------
// Task to drive a value to tst_dir_b input
//-----------------------------------------------------------------------------

task drive_tst_dir;

    input [`GPIO_CH-1:0] tst_dir_value;	// value to be driven to tst_dir_b

    begin				// drive value to tst
	@(posedge pclk);
        #(PERIOD - T_SETUP);            // drive value with chosen setup time
        tst_dir = tst_dir_value;

	@(posedge pclk);		// wait for end of period
    end

endtask

//-----------------------------------------------------------------------------
// Task to drive a value to tst_dout_b input
//-----------------------------------------------------------------------------

task drive_tst_dout;

    input [`GPIO_CH-1:0] tst_dout_value; // value to be driven to tst_dout_b

    begin				 // drive value to tst
	@(posedge pclk);
        #(PERIOD - T_SETUP);             // drive value with chosen setup time
        tst_dout = tst_dout_value;

	@(posedge pclk);		 // wait for end of period
    end

endtask

//-----------------------------------------------------------------------------
// Task to drive a value to alt_dira_b input
//-----------------------------------------------------------------------------

task drive_alt_dira;

    input [`GPIO_CH-1:0] alt_dira_value; // value to be driven to alt_dira_b

    begin				 // drive value to alt_dira_b
	@(posedge pclk);
        #(PERIOD - T_SETUP);             // drive value with chosen setup time
        alt_dira = alt_dira_value;

	@(posedge pclk);		 // wait for end of period
    end

endtask

//-----------------------------------------------------------------------------
// Task to drive a value to alt_dirb_b input
//-----------------------------------------------------------------------------

task drive_alt_dirb;

    input [`GPIO_CH-1:0] alt_dirb_value; // value to be driven to alt_dirb_b

    begin				 // drive value to alt_dirb_b
	@(posedge pclk);
        #(PERIOD - T_SETUP);             // drive value with chosen setup time
        alt_dirb = alt_dirb_value;

	@(posedge pclk);		 // wait for end of period
    end

endtask

//-----------------------------------------------------------------------------
// Task to drive a value to alt_douta_b input
//-----------------------------------------------------------------------------

task drive_alt_douta;

    input [`GPIO_CH-1:0] alt_douta_value; // value to be driven to alt_douta_b

    begin				  // drive value to alt_douta_b
	@(posedge pclk);
        #(PERIOD - T_SETUP);              // drive value with chosen setup time
        alt_douta = alt_douta_value;

	@(posedge pclk);		  // wait for end of period
    end

endtask

//-----------------------------------------------------------------------------
// Task to drive a value to alt_doutb_b input
//-----------------------------------------------------------------------------

task drive_alt_doutb;

    input [`GPIO_CH-1:0] alt_doutb_value; // value to be driven to alt_doutb_b

    begin				  // drive value to alt_doutb_b
	@(posedge pclk);
        #(PERIOD - T_SETUP);              // drive value with chosen setup time
        alt_doutb = alt_doutb_value;

	@(posedge pclk);		  // wait for end of period
    end

endtask

//-----------------------------------------------------------------------------
// Task to drive a value to dinp_b input
//-----------------------------------------------------------------------------

task drive_dinp;

    input [`GPIO_CH-1:0] dinp_value;	// value to be driven to dinp_b

    begin				// drive value to dinp_b
	@(posedge pclk);
        #(PERIOD - T_SETUP);            // drive value with chosen setup time
        dinp = dinp_value;

	@(posedge pclk);		// wait for end of period
    end

endtask


