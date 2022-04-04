/*==================================================================#
#                      PRODUCTION TEST PATTERN                      #
#===================================================================#
#  Test Name               :      gpio_reg                          #
#  Target Block(s)         :      gpio_xt_xxxx                      #
#                                                                   #
#  Written By              :      Angelo Lo Cicero                  # 
#  Date                    :      Nov  12th, 2002                   #
#===================================================================#
#                      Test Description                             #
#-------------------------------------------------------------------#
#                                                                   #
# This pattern checks the chip level connections for the            #
# GPIO, isn't absolutely intended for checking the GPIO             #
# functionality, that is supposed to have been already checked.     #
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

#include "chip_definitions.h"
#include "global_definitions.h"

void gpio_reg(void)
{

//***********************************************
// Define the varible for multiple device
//***********************************************

  unsigned char Module_number;
  unsigned long gpio_masc;

  gpio_t gpio_module;

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

      gpio_masc  = gpio_mask[Module_number][0];

//***********************************************
// Initialize registers
//***********************************************

      reg_r11 = 0;

// ***********************************************
// Check reset value of the Module's registers
// ***********************************************
 
      if ( (gpio_module->PDIR.lword & gpio_masc) != 0x00)
	goto test_end;
      reg_r11++;              // reg_r11 = 0x1

//***********************************************
// Write and read Module's registers
//***********************************************

      gpio_module->PDIR.lword   = (0x55440022 & gpio_masc);
      gpio_module->PDOUT.lword  = (0x7755FF47 & gpio_masc);
      gpio_module->PWKPU.lword  = (0x99885566 & gpio_masc);

      if ( (gpio_module->PDIR.lword & gpio_masc)  !=  ( 0x55440022 & gpio_masc))
        goto test_end;
      reg_r11++;              // reg_r11 = 0x2
      if ( (gpio_module->PDOUT.lword & gpio_masc) != ( 0x7755FF47 & gpio_masc))
	goto test_end;
      reg_r11++;              // reg_r11 = 0x3
      if ( (gpio_module->PWKPU.lword & gpio_masc) != ( 0x99885566 & gpio_masc))
        goto test_end;
      reg_r11++;              // reg_r11 = 0x4

//***********************************************
// Exit condition
//***********************************************

      reg_r12++;
        }

  reg_r13++;

test_end: 
        
 //   PROGRAMend();
   return;

}        
