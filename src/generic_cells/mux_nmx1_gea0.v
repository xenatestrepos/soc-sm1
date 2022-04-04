`timescale 100 ps/100 ps
//------------------------------------------------------------------------------
// (c) Copyright 2003, National Semiconductors Corporation
//------------------------------------------------------------------------------
// National Semiconductor Confidential. All Rights Reserved.
//------------------------------------------------------------------------------
//
// Name: mux_nmx1_gea0
//
// Module Description:
// 
//
//  SEL_WIDTH = 4  : number of positions
//  n  : (INPUT_WIDTH * SEL_WIDTH) 
//  i  : OUTPUT_WIDTH and INPUT_WIDTH of each channel
//
//                n              0
//  mux_input    i:0 i:0  i:0 i:0
//                |   |    |   |
//    
//                  \ 
//  mux_sel          \
//                     \ 
//                      |
//  mux_output         m:0   
// 
//  Please read the README file in the folder doc, for more information.
// 
//
// Parent:    chip
// Children:  none
//
// Interface Diagramm:
//
//                               +---------------------+
//                               |                     |
//                               |     mux_nmx1        |
//       mux_input   >--[n:0]----|                     |
//                               |                     |--[m:0]-> mux_output
//       mux_sel gnd >-----------|                     |
//                               |                     |
//                               +---------------------+ 
//------------------------------------------------------------------------------
// *History:
//
// 05, 07, 03     | Markus Karg    V1.0    First Edit 
//
//------------------------------------------------------------------------------
// 
// Code Structure
//
// 1.Parameter declaration
// 2.Multiplexer function
// 3.Main Code


// reuse-pragma startSub [InsertComponentPrefix %subText 7]
module mux_nmx1_gea0 (

// OUTPUT
mux_output,      // mux output

// INPUTs
mux_input,      // mux_input
mux_sel         // input_sel
);

// synopsys template

// 1.Parameter declaration

parameter OUTPUT_WIDTH = 32;
parameter INPUT_WIDTH  = 32*16;
parameter SEL_WIDTH    = 16;

// OUTPUT

output [OUTPUT_WIDTH-1:0] mux_output;   // mux output

// INPUT

input  [INPUT_WIDTH-1:0]   mux_input;   // mux input
input  [SEL_WIDTH-1:0]     mux_sel;     // mux sel

// 2. Multiplexer function

function [OUTPUT_WIDTH-1:0] mux_sw;
 input  [INPUT_WIDTH-1:0]  mux_sw_input;
 input  [SEL_WIDTH-1:0]    mux_sw_sel;

 integer i,j;
 reg    [OUTPUT_WIDTH-1:0] mux_sw_output;

 begin
  mux_sw_output = {OUTPUT_WIDTH{1'b0}};
  for(i=0;i<SEL_WIDTH;i=i+1)
    begin
     for(j=0;j<OUTPUT_WIDTH;j=j+1)
       begin 
        mux_sw_output[j]= mux_sw_output[j] | (mux_sw_sel[i] & 
        mux_sw_input[i*OUTPUT_WIDTH+j]);
       end
    end     
    mux_sw = mux_sw_output;
  end    
 endfunction // mux_sw

// 3.Main code

wire [OUTPUT_WIDTH-1:0] mux_output;

assign mux_output =  mux_sw(mux_input,mux_sel);

endmodule // mux_nmx1_gea0

   
 
 
