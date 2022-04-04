/*****************************************************
 *     C HEADER FILE FOR GPIO_XT_GEXX's base addresses file
 *---------------------------------------------------
 *
 *	Author: Angelo Lo Cicero
 *        
 ****************************************************/

#if NU_OF_GPIOS == 1
/*  base adresses */
    const unsigned long gpio_base_addresses[1] = { GPIO_0_ADDR };
    const unsigned long extreg_gpio_base_addresses[1] = { EXTREG_GPIO_0_ADDR };
/*  wup */
    const unsigned short gpio_wup_0[1][2]        = { { GPIO_0_WKUP } };
/* ext */
    const unsigned long  gpio_mask[1][3]       = { { GPIO_0_MASK } };
#elif NU_OF_GPIOS == 2
/*  base adresses */
    const unsigned long gpio_base_addresses[2] = { GPIO_0_ADDR , 
                                                   GPIO_1_ADDR };
    const unsigned long extreg_gpio_base_addresses[2] = { EXTREG_GPIO_0_ADDR ,
                                                          EXTREG_GPIO_1_ADDR };
/*  wup */
    const unsigned short gpio_wup_0[2][2]      = { { GPIO_0_WKUP } ,
                                                   { GPIO_1_WKUP } };
/* ext */
    const unsigned long  gpio_mask[2][3]       = { { GPIO_0_MASK },
                                                   { GPIO_1_MASK } };
#elif NU_OF_GPIOS == 3
/*  base adresses */
    const unsigned long gpio_base_addresses[3] = { GPIO_0_ADDR ,
                                                   GPIO_1_ADDR ,
                                                   GPIO_2_ADDR };
    const unsigned long extreg_gpio_base_addresses[3] = { EXTREG_GPIO_0_ADDR ,
                                                          EXTREG_GPIO_1_ADDR ,
                                                          EXTREG_GPIO_2_ADDR };
/*  wup */
    const unsigned short gpio_wup_0[3][2]      = { { GPIO_0_WKUP } ,
                                                   { GPIO_1_WKUP } ,
                                                   { GPIO_2_WKUP } };
/* ext */
    const unsigned long  gpio_mask[3][3]       = { { GPIO_0_MASK },
                                                   { GPIO_1_MASK },
                                                   { GPIO_2_MASK } };
#elif NU_OF_GPIOS == 4
/*  base adresses */
    const unsigned long gpio_base_addresses[4] = { GPIO_0_ADDR ,
                                                   GPIO_1_ADDR ,
                                                   GPIO_2_ADDR ,
                                                   GPIO_3_ADDR };
    const unsigned long extreg_gpio_base_addresses[4] = { EXTREG_GPIO_0_ADDR ,
                                                          EXTREG_GPIO_1_ADDR ,
                                                          EXTREG_GPIO_2_ADDR ,
                                                          EXTREG_GPIO_3_ADDR };
/*  wup */
    const unsigned short gpio_wup_0[4][2]      = { { GPIO_0_WKUP } ,
                                                   { GPIO_1_WKUP } ,
                                                   { GPIO_2_WKUP } ,
                                                   { GPIO_3_WKUP } };
/* ext */
    const unsigned long  gpio_mask[4][3]       = { { GPIO_0_MASK },
                                                   { GPIO_1_MASK },
                                                   { GPIO_2_MASK },
                                                   { GPIO_3_MASK } };
#elif NU_OF_GPIOS == 5
/*  base adresses */
    const unsigned long gpio_base_addresses[5] = { GPIO_0_ADDR ,
                                                   GPIO_1_ADDR ,
                                                   GPIO_2_ADDR ,
                                                   GPIO_3_ADDR ,
                                                   GPIO_4_ADDR };
    const unsigned long extreg_gpio_base_addresses[5] = { EXTREG_GPIO_0_ADDR ,
                                                          EXTREG_GPIO_1_ADDR ,
                                                          EXTREG_GPIO_2_ADDR ,
                                                          EXTREG_GPIO_3_ADDR ,
                                                          EXTREG_GPIO_4_ADDR };
/*  wup */
    const unsigned short gpio_wup_0[5][2]      = { { GPIO_0_WKUP } ,
                                                   { GPIO_1_WKUP } ,
                                                   { GPIO_2_WKUP } ,
                                                   { GPIO_3_WKUP } ,
                                                   { GPIO_4_WKUP } };
/* ext */
    const unsigned long  gpio_mask[5][3]       = { { GPIO_0_MASK },
                                                   { GPIO_1_MASK },
                                                   { GPIO_2_MASK },
                                                   { GPIO_3_MASK },
                                                   { GPIO_4_MASK } };
#elif NU_OF_GPIOS == 6
/*  base adresses */
    const unsigned long gpio_base_addresses[6] = { GPIO_0_ADDR ,
                                                   GPIO_1_ADDR ,
                                                   GPIO_2_ADDR ,
                                                   GPIO_3_ADDR ,
                                                   GPIO_4_ADDR ,
                                                   GPIO_5_ADDR };
    const unsigned long extreg_gpio_base_addresses[6] = { EXTREG_GPIO_0_ADDR ,
                                                          EXTREG_GPIO_1_ADDR ,
                                                          EXTREG_GPIO_2_ADDR ,
                                                          EXTREG_GPIO_3_ADDR ,
                                                          EXTREG_GPIO_4_ADDR ,
                                                          EXTREG_GPIO_5_ADDR };
/*  wup */
    const unsigned short gpio_wup_0[6][2]      = { { GPIO_0_WKUP } ,
                                                   { GPIO_1_WKUP } ,
                                                   { GPIO_2_WKUP } ,
                                                   { GPIO_3_WKUP } ,
                                                   { GPIO_4_WKUP } ,
                                                   { GPIO_5_WKUP } };
/* ext */
    const unsigned long  gpio_mask[6][3]       = { { GPIO_0_MASK },
                                                   { GPIO_1_MASK },
                                                   { GPIO_2_MASK },
                                                   { GPIO_3_MASK },
                                                   { GPIO_4_MASK },
                                                   { GPIO_5_MASK } };
#endif

