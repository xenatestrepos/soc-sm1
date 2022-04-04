/*==================================================================#
#                      PRODUCTION TEST PATTERN                      #
#===================================================================#
#  Test Name               :      reg_all                           #
#                                                                   #
#  Written By              :      Angelo Lo Cicero                  # 
#  Date                    :      Sep  17th, 2002                   #
#===================================================================#
#                      Test Description                             #
#-------------------------------------------------------------------#
#                                                                   #
# This pattern drives the I/O chip level connections for all gpio   #
# pins. No check is made! The pattern can be used just for          #
# production.                                                       #
#                                                                   #
#===================================================================#
#                      Test Info                                    #
#-------------------------------------------------------------------#
#  Test Mode               : stest                                  #
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

#include "chip_definitions.h"
#include "global_definitions.h"

void gpio_misc(void)
{

//***********************************************
// Define the varible for multiple device
//***********************************************

  unsigned char  Module_number;
  unsigned long gpio_masc;

  gpio_t         gpio_module;
  ext_gpio_t     gpio_extreg;

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

      gpio_extreg = (ext_gpio_t)extreg_gpio_base_addresses[Module_number];
      gpio_module = (gpio_t)gpio_base_addresses[Module_number];

      gpio_masc  = gpio_mask[Module_number][0];

//***********************************************
// Initialize registers
//***********************************************

      reg_r11 = 0;

      gpio_module->PALT.lword    = 0x00000000;
      gpio_module->PWKPU.lword   = 0x00000000;

//***********************************************
// Drive from outside all the I/O pins and read the data back
//***********************************************

      gpio_module->PDIR.lword    = 0x00000000;
      gpio_extreg->EXTDATA.lword = 0x5A5A5A5A;
      gpio_extreg->EXTDIR.lword  = 0xFFFFFFFF;

      reg_r11++;              // reg_r11 = 0x1

      wait(2);

      if ((gpio_module->PDIN.lword & gpio_masc) != (0x5A5A5A5A & gpio_masc))
       goto test_end;
      reg_r11++;              // reg_r11 = 0x2
 

      gpio_extreg->EXTDATA.lword = 0xA5A5A5A5;

      reg_r11++;              // reg_r11 = 0x3

      wait(2);

      if ((gpio_module->PDIN.lword & gpio_masc) != (0xA5A5A5A5 & gpio_masc))
       goto test_end;
      reg_r11++;              // reg_r11 = 0x4


      gpio_extreg->EXTDATA.lword = 0x00000000;

      reg_r11++;              // reg_r11 = 0x5

      wait(2);

      if ((gpio_module->PDIN.lword & gpio_masc) != (0x00000000 & gpio_masc))
       goto test_end;
      reg_r11++;              // reg_r11 = 0x6


      gpio_extreg->EXTDATA.lword = 0xFFFFFFFF;

      reg_r11++;              // reg_r11 = 0x7

      wait(2);

      if ((gpio_module->PDIN.lword & gpio_masc) != (0xFFFFFFFF & gpio_masc))
       goto test_end;
      reg_r11++;              // reg_r11 = 0x8

//***********************************************
// Drive from chip all the I/O pins
//***********************************************

      gpio_extreg->EXTDIR.lword  = 0x000000000;

      gpio_module->PDOUT.lword = 0x5A5A5A5A;
      gpio_module->PDIR.lword =  0xFFFFFFFF;

      wait(2);

      if (gpio_extreg->EXTDATA.lword != (0x5A5A5A5A & gpio_masc))
       goto test_end;
      reg_r11++;              // reg_r11 = 0x9


      gpio_module->PDOUT.lword = 0xA5A5A5A5;

      wait(2);

     if (gpio_extreg->EXTDATA.lword != (0xA5A5A5A5 & gpio_masc))
       goto test_end;
      reg_r11++;              // reg_r11 = 0xA

      gpio_module->PDOUT.lword = 0x5A5A5A5A;

      wait(2);

      if (gpio_extreg->EXTDATA.lword != (0x5A5A5A5A & gpio_masc))
       goto test_end;
      reg_r11++;              // reg_r11 = 0xB

//***********************************************
// verify weak pull-up and weak pull-down
//***********************************************

      gpio_module->PDIR.lword   = 0x00000000;
      gpio_module->PPDR.lword   = 0xFFFFFFFF;
      gpio_module->PWKPU.lword  = 0xFFFFFFFF;

      wait(2);

      if (gpio_extreg->EXTDATA.lword != (0xFFFFFFFF & gpio_masc))
       goto test_end;
      reg_r11++;              // reg_r11 = 0xC

      gpio_module->PPDR.lword   = 0x00000000;

      wait(2);

      if (gpio_extreg->EXTDATA.lword != (0x00000000 & gpio_masc))
       goto test_end;
      reg_r11++;              // reg_r11 = 0xD

//***********************************************
// Exit condition
//***********************************************

      gpio_module->PWKPU.lword  = 0x00000000;
      reg_r12++;
        }

  reg_r13++;

test_end: 

   return;

}        
	
		
	  
        
