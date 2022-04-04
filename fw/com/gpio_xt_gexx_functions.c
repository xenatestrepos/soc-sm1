/*****************************************************
 *     C HEADER FILE FOR GPIO_XT_GEXX's functions
 *---------------------------------------------------
 *
 *	Author: Angelo Lo Cicero
 *        
 ****************************************************/

/*==================================================================#
# Collection of the common functions, used in the different patterns   #
#==================================================================*/

#include "chip_definitions.h"
#include "global_definitions.h"

#if NU_OF_GPIOS>=1	
//***********************************************************************
//  GPIO set up procedure
//***********************************************************************

void GPIOinit(gpio_t gpio_module, short gpio_port, short gpio_channel)
{
  unsigned long    help_value    ;                

//***************************
// set GPIO register
//***************************
  
  help_value = (long) 1 << gpio_channel;

  if (gpio_port == 1) // port B
    {
    gpio_module->PALTS.lword = gpio_module->PALTS.lword | help_value;
    gpio_module->PALT.lword = gpio_module->PALT.lword | help_value;
    }
  else if (gpio_port == 0) // port A
    {
    gpio_module->PALTS.lword = gpio_module->PALTS.lword & (~help_value);
    gpio_module->PALT.lword = gpio_module->PALT.lword | help_value;
    }
  else // connected directlry to the Y output of the PAD
    {
    gpio_module->PALT.lword = gpio_module->PALT.lword & (~help_value);
    gpio_module->PDIR.lword = gpio_module->PDIR.lword & (~help_value);
    gpio_module->PIEN.lword = gpio_module-> PIEN.lword | help_value;
    }

  return;

}

//***********************************************************************
//  GPIO off procedure
//***********************************************************************

void GPIOend(gpio_t gpio_module, short gpio_channel)
{
  int    help_value    ;                

//***************************
// set GPIO register
//***************************
  
  help_value = 1 << gpio_channel;

  gpio_module->PALT.lword = gpio_module->PALT.lword & (~help_value);
  gpio_module->PIEN.lword = gpio_module-> PIEN.lword & (~help_value);

  return;

}
#endif
