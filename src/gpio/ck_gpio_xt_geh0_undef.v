//----------------------------------------------------------------------------
// (c) Copyright 2001, National Semiconductor Coporation
//----------------------------------------------------------------------------
// National Semiconductor Confidential. All Rights Reserved.
//----------------------------------------------------------------------------
// *Name: ck_gpio_xt_geg0.undef
//
// *Module Description:  Scalable GPIO module global undefine include file
//
//    Parent:    gpio_xt_xxxx
//
//    Children:  None
//
//
//----------------------------------------------------------------------------
// *History:
//
//    Nov 03, 03 | Olivier Girard :  V1.00 First Edit.
//----------------------------------------------------------------------------
// *endName

// reuse-pragma startSub DoUndef [IncludeIf 1 -comment // %subText]

`undef GPIO_CH

`undef ALSB

`undef CB_PxALT_RESET_VALUE
`undef PxALT_RESET_VALUE

`undef CB_PxALTS_RESET_VALUE
`undef PxALTS_RESET_VALUE

`undef CB_PxWKPU_RESET_VALUE
`undef PxWKPU_RESET_VALUE

`undef CB_PxPDR_RESET_VALUE
`undef PxPDR_RESET_VALUE

// reuse-pragma startSub [IncludeIf @GATED_CLOCK==1 %subText]
`undef GATED_CLOCK 

// reuse-pragma endSub DoUndef
