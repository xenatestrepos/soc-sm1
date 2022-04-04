/*==================================================================#
#                      PRODUCTION TEST PATTERN                      #
#===================================================================#
#  Test Name               :      gpio_wup                          #
#  Target Block(s)         :      gpio_xt_xxxx                      #
#                                                                   #
#  Written By              :      Angelo Lo Cicero                  # 
#  Date                    :      Sep  16th, 2002                   #
#===================================================================#
#                      Test Description                             #
#-------------------------------------------------------------------#
#                                                                   #
# This pattern checks the chip level wake up connections for the    #
# GPIO, isn't absolutely intended for checking the GPIO             #
# functionality, that is supposed to have been already checked.     #
#                                                                   #
#                                                                   #
#===================================================================#
#                      Test Info                                    #
#-------------------------------------------------------------------#
#  Test Mode               : dev                                    #
#                                                                   #
#  Memory Model            : small                                  #
#                                                                   #
#  Simulation Time         :                                        #
#                                                                   #
#===================================================================#
# Include standard register definition files                        #
#==================================================================*/

//***********************************************
// General Include Files
//***********************************************
#define WAIT_CYCLES 0x0100

#include "chip_definitions.h"
#include "global_definitions.h"

void gpio_wup(void)
{

//***********************************************
// Define the varible for multiple device
//***********************************************

unsigned char Module_number;
unsigned char wup_number;
unsigned char wup_channel;
const unsigned short *gpio_wup_0_vector;

gpio_t     gpio_module;
miwu_t    miwu_module;
ext_gpio_t gpio_extreg;

//***********************************************
// Initialize the chip
//***********************************************

reg_r12 = 0;
reg_r13 = 0;

//***********************************************
// Test_all_modules
//***********************************************

for (Module_number = 0; Module_number < NU_OF_GPIOS; Module_number++)
{

//***********************************************
// Set Module base pointers
//***********************************************

  gpio_module = (gpio_t)gpio_base_addresses[Module_number];
  gpio_extreg = (ext_gpio_t)extreg_gpio_base_addresses[Module_number];

//***********************************************
// Set Gpio vectors
//***********************************************
//***********************************************
// Set MIWU vector
//***********************************************

  gpio_wup_0_vector = (gpio_wup_0[Module_number]);

  wup_number  = gpio_wup_0_vector[0];
  wup_channel = gpio_wup_0_vector[1];

//***********************************************
// Initialize registers
//***********************************************

  reg_r11 = 0;

//***********************************************
// configure device
//***********************************************
//***********************************************
// Check if the device is connected to the MIWU
//***********************************************

  if (wup_number == 112)
    goto  final_check;  //skip if wup is not connected

//***********************************************
// Set MIWU Module base pointers
//***********************************************

   miwu_module = (miwu_t)miwu_base_addresses[wup_number];

//***********************************************
// check if wake_up is not active before         
//***********************************************

#ifndef WT_MIWU
  if (Report_wup_pin(miwu_module, wup_channel) != 0)
#endif
#ifdef WT_MIWU
   if (Report_rwup_pin(miwu_module, wup_channel) != 0)
#endif
   goto test_end;
        
//***********************************************
// configure MIWU
//***********************************************

#ifndef WT_MIWU
  miwu_module->WKCL.word = 0xFFFF;     //clear pending bits
  miwu_module->WKICTL1.word = 0x0000 ; //activate interrupt request 0
  miwu_module->WKICTL2.word = 0x0000 ; //for every miwu channel
#endif
#ifdef WT_MIWU
  miwu_module->WKCLR1.lword = 0xFFFFFFFF;     //clear pending bits
  miwu_module->WKCLR2.lword = 0xFFFFFFFF;     //clear pending bits
#endif

//***********************************************
// configure EXTREGs to a default value of 0
// in the first bit of the GPIO
//***********************************************

#ifdef BITS_ALLIGNMENT_16
  gpio_extreg->EXTDATA.word = 0x0000;
  gpio_extreg->EXTDIR.word = 0x0001;
#endif
#ifdef BITS_ALLIGNMENT_32
  gpio_extreg->EXTDATA.lword = 0x0000;
  gpio_extreg->EXTDIR.lword = 0x0001;
#endif

//***********************************************
// configure GPIO
//***********************************************
//***********************************************
// configure device
//***********************************************

#ifdef BITS_ALLIGNMENT_16
  gpio_module->PDIR.word  = 0x0000;
  gpio_module->PALT.word  = gpio_module->PALT.word & 0xFFFE;  
  gpio_module->PDOUT.word = 0x0001;
  gpio_module->PIEN.word  = 0x0001;
#endif
#ifdef BITS_ALLIGNMENT_32
  gpio_module->PDIR.lword  = 0x0000;
  gpio_module->PALT.lword  = gpio_module->PALT.lword & 0xFFFFFFFE;
  gpio_module->PDOUT.lword = 0x0001;
  gpio_module->PIEN.lword  = 0x0001;
#endif

//***********************************************
// particular routine to generate WUP request
// configure external stimulator to send a 0->1 transaction 
// on the first input pin of the gpio
//***********************************************

#ifdef BITS_ALLIGNMENT_16
  gpio_extreg->EXTDATA.word = 0x0001;
#endif
#ifdef BITS_ALLIGNMENT_32
  gpio_extreg->EXTDATA.lword = 0x0001;
#endif

//***********************************************
// wait
//***********************************************

  wait(WAIT_CYCLES);
  reg_r11++;              // reg_r11 = 0x01

//***********************************************
// check values
//***********************************************

#ifndef WT_MIWU
  if (Report_wup_pin(miwu_module, wup_channel)   == 0)
#endif
#ifdef WT_MIWU
   if (Report_rwup_pin(miwu_module, wup_channel) == 0)
#endif
    goto test_end;
        
//***********************************************
// turn off wup en
//***********************************************

#ifdef BITS_ALLIGNMENT_16
  gpio_module->PIEN.word  = 0x0000;
#endif
#ifdef BITS_ALLIGNMENT_32
  gpio_module->PIEN.lword  = 0x0000;
#endif

//***********************************************
// turn off the GPIO
//***********************************************
//***********************************************
// turn off the EXTREG
//***********************************************

#ifdef BITS_ALLIGNMENT_16
  gpio_extreg->EXTDIR.word   = 0x0000;
#endif
#ifdef BITS_ALLIGNMENT_32
  gpio_extreg->EXTDIR.lword   = 0x0000;
#endif

//***********************************************
// clear pending bit in MIWU
//***********************************************

#ifndef WT_MIWU
  miwu_module->WKCL.word = 0xFFFF;    //clear pending bits
#endif
#ifdef WT_MIWU
  miwu_module->WKCLR1.lword = 0xFFFFFFFF;     //clear pending bits
  miwu_module->WKCLR2.lword = 0xFFFFFFFF;     //clear pending bits
#endif

final_check:        
        
//***********************************************
// turn off the device
//***********************************************

#ifdef BITS_ALLIGNMENT_16
  gpio_module->PDOUT.word = 0x0000;
#endif
#ifdef BITS_ALLIGNMENT_32
  gpio_module->PDOUT.lword = 0x0000;
#endif

//***********************************************
// Exit condition
//***********************************************

  reg_r11 = 0x0002;      //r11 = 2
  reg_r12++;
        }

  reg_r13++;

test_end: 
        
  return;

} 
        
