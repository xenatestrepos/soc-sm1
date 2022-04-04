/*****************************************************
 *     C HEADER FILE FOR GPIO_XT_GEXX
 *---------------------------------------------------
 *
 *	Author: Angelo Lo Cicero
 *        
 ****************************************************/

typedef struct
{
        volatile union u32PORT      PALT     ;
        volatile union u32PORT      PDIR     ;
        volatile union u32PORT      PDIN     ;
        volatile union u32PORT      PDOUT    ;
        volatile union u32PORT      PWKPU    ;
        volatile union u32PORT      PHDRV    ;
        volatile union u32PORT      PALTS    ;
        volatile union u32PORT      PIEN     ;
        volatile union u32PORT      PPDR     ;
  } *gpio_t;

extern const unsigned long gpio_base_addresses[NU_OF_GPIOS];
extern const unsigned short gpio_wup_0[NU_OF_GPIOS][2];
extern const unsigned long gpio_mask[NU_OF_GPIOS][3];

typedef struct
{
        volatile union u32PORT        EXTDIR;
        volatile union u32PORT        EXTDATA;
  } *ext_gpio_t;

extern const unsigned long extreg_gpio_base_addresses[NU_OF_GPIOS];


