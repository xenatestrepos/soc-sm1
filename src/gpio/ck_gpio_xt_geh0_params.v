//----------------------------------------------------------------------------
// (c) Copyright 2001, National Semiconductor Coporation
//----------------------------------------------------------------------------
// National Semiconductor Confidential. All Rights Reserved.
//----------------------------------------------------------------------------
// *Name: gpio_xt_const.inc
//
// *Module Description:  Scalable GPIO module global define include file
//
//    Parent:    gpio_xt_xxxx
//
//    Children:  None
//
//
//----------------------------------------------------------------------------
// *History:
//
//    Feb 26, 01 | Wolfgang Hoeld :  V1.00 First edit.
//    Oct 27, 03 | Olivier Girard :  V1.10 Update for coreTools support
//----------------------------------------------------------------------------
// *endName

// reuse-pragma attr Label Width of the gpio port and registers
// reuse-pragma attr EnumValues 8 16 32
// reuse-pragma attr SymbolicNames 8 16 32
// reuse-pragma attr GroupName BasicConfig
// reuse-pragma beginAttr Description
// Width of the gpio port and registers - choose among 8 - 16 or 32 width
// reuse-pragma endAttr
`define GPIO_CH 32

// reuse-pragma attr Label Address least significant bit to be decoded in the address's input bus
// reuse-pragma attr EnumValues 0 1 2
// reuse-pragma attr SymbolicNames 0 1 2
// reuse-pragma attr GroupName BasicConfig
// reuse-pragma attr CheckExpr[@GPIO_CH==16] @ALSB!=0
// reuse-pragma attr CheckExpr[@GPIO_CH==32] @ALSB==2
// reuse-pragma beginAttr
// CheckExprMessage[@GPIO_CH==16]
// "If the width of the port is 16, then the address decoding should be 16 bit aligned (LSB = 1 or 2)."
// reuse-pragma endAttr
// reuse-pragma beginAttr
// CheckExprMessage[@GPIO_CH==32]
// "If the width of the port is 32, then the address decoding should be 32 bit aligned (LSB = 2)."
// reuse-pragma endAttr
// reuse-pragma beginAttr Description
// Address least significant bit to be decoded in the address's input bus.
//  Choose according to the following table:
//  ALSB |                            | possible values of GPIO_CH
// ---------------------------------------------------------------
//   0   | registers byte addressed   | 8
//   1   | registers word addressed   | 8, 16
//   2   | registers 32 bit addressed | 8, 16, 32
// reuse-pragma endAttr
`define ALSB 2

// reuse-pragma attr Label Port Alternate function Register:
// reuse-pragma attr GroupName BasicConfig/RESET_VALUES
// reuse-pragma attr CheckExpr[@GPIO_CH==8]  @CB_PxALT_RESET_VALUE<0x100
// reuse-pragma attr CheckExpr[@GPIO_CH==16] @CB_PxALT_RESET_VALUE<0x10000
// reuse-pragma beginAttr
// CheckExprMessage[@GPIO_CH==8]
// "If the width of the port is 8, then the register value's width should not exceed 8."
// reuse-pragma endAttr
// reuse-pragma beginAttr
// CheckExprMessage[@GPIO_CH==16]
// "If the width of the port is 16, then the register value's width should not exceed 16."
// reuse-pragma endAttr
// reuse-pragma beginAttr Description
// Reset value of the register PxALT, uncomment it if the standard
// 'GPIO_CH{1'b0} is the wanted value
// reuse-pragma endAttr
`define CB_PxALT_RESET_VALUE 32'b0000_0000_0000_0000_0000_0000_0000_0000
// reuse-pragma startSub [format "`define PxALT_RESET_VALUE %s" [nsc::format_hex2bin CB_PxALT_RESET_VALUE GPIO_CH]]
`define PxALT_RESET_VALUE 32'b0000_0000_0000_0000_0000_0000_0000_0000

// reuse-pragma attr Label Port Alternate Source Register:
// reuse-pragma attr GroupName BasicConfig/RESET_VALUES
// reuse-pragma attr CheckExpr[@GPIO_CH==8]  @CB_PxALTS_RESET_VALUE<0x100
// reuse-pragma attr CheckExpr[@GPIO_CH==16] @CB_PxALTS_RESET_VALUE<0x10000
// reuse-pragma beginAttr
// CheckExprMessage[@GPIO_CH==8]
// "If the width of the port is 8, then the register value's width should not exceed 8."
// reuse-pragma endAttr
// reuse-pragma beginAttr
// CheckExprMessage[@GPIO_CH==16]
// "If the width of the port is 16, then the register value's width should not exceed 16."
// reuse-pragma endAttr
// reuse-pragma beginAttr Description
// Reset value of the register PxALTS, uncomment it if the standard
// 'GPIO_CH{1'b0} is the wanted value
// reuse-pragma endAttr
`define CB_PxALTS_RESET_VALUE 32'b0000_0000_0000_0000_0000_0000_0000_0000
// reuse-pragma startSub [format "`define PxALTS_RESET_VALUE %s" [nsc::format_hex2bin CB_PxALTS_RESET_VALUE GPIO_CH]]
`define PxALTS_RESET_VALUE 32'b0000_0000_0000_0000_0000_0000_0000_0000

// reuse-pragma attr Label Port Weak Pull-up/Pull-down Enable:
// reuse-pragma attr GroupName BasicConfig/RESET_VALUES
// reuse-pragma attr CheckExpr[@GPIO_CH==8]  @CB_PxWKPU_RESET_VALUE<0x100
// reuse-pragma attr CheckExpr[@GPIO_CH==16] @CB_PxWKPU_RESET_VALUE<0x10000
// reuse-pragma beginAttr
// CheckExprMessage[@GPIO_CH==8]
// "If the width of the port is 8, then the register value's width should not exceed 8."
// reuse-pragma endAttr
// reuse-pragma beginAttr
// CheckExprMessage[@GPIO_CH==16]
// "If the width of the port is 16, then the register value's width should not exceed 16."
// reuse-pragma endAttr
// reuse-pragma beginAttr Description
// Reset value of the register PxWKPU, uncomment it if the standard
// 'GPIO_CH{1'b0} is the wanted value
// reuse-pragma endAttr
`define CB_PxWKPU_RESET_VALUE 32'b0000_0000_0000_0000_0000_0000_0000_0000
// reuse-pragma startSub [format "`define PxWKPU_RESET_VALUE %s" [nsc::format_hex2bin CB_PxWKPU_RESET_VALUE GPIO_CH]]
`define PxWKPU_RESET_VALUE 32'b0000_0000_0000_0000_0000_0000_0000_0000

// reuse-pragma attr Label Port Weak Pull-up/Pull-down Direction:
// reuse-pragma attr GroupName BasicConfig/RESET_VALUES
// reuse-pragma attr CheckExpr[@GPIO_CH==8]  @CB_PxPDR_RESET_VALUE<0x100
// reuse-pragma attr CheckExpr[@GPIO_CH==16] @CB_PxPDR_RESET_VALUE<0x10000
// reuse-pragma beginAttr
// CheckExprMessage[@GPIO_CH==8]
// "If the width of the port is 8, then the register value's width should not exceed 8."
// reuse-pragma endAttr
// reuse-pragma beginAttr
// CheckExprMessage[@GPIO_CH==16]
// "If the width of the port is 16, then the register value's width should not exceed 16."
// reuse-pragma endAttr
// reuse-pragma beginAttr Description
// Reset value of the register PxPDR, uncomment it if the standard
// 'GPIO_CH{1'b1} is the wanted value
// reuse-pragma endAttr
`define CB_PxPDR_RESET_VALUE 32'b1111_1111_1111_1111_1111_1111_1111_1111
// reuse-pragma startSub [format "`define PxPDR_RESET_VALUE %s" [nsc::format_hex2bin CB_PxPDR_RESET_VALUE GPIO_CH]]
`define PxPDR_RESET_VALUE 32'b1111_1111_1111_1111_1111_1111_1111_1111

// reuse-pragma attr Label Enable Clock Gating:
// reuse-pragma attr GroupName BasicConfig
// reuse-pragma beginAttr Description
//This parameter allows the user to enable or disable the
//clock gating within the system (e.g. for FPGA synthesis).
// reuse-pragma endAttr
//`define GATED_CLOCK 

