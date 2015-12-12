/*******************************************************************************
* File Name: DUMMY.h  
* Version 1.70
*
* Description:
*  This file containts Control Register function prototypes and register defines
*
* Note:
*
********************************************************************************
* Copyright 2008-2010, Cypress Semiconductor Corporation.  All rights reserved.
* You may use this file only in accordance with the license, terms, conditions, 
* disclaimers, and limitations in the end user license agreement accompanying 
* the software package with which this file was provided.
********************************************************************************/

#if !defined(CY_PINS_DUMMY_H) /* Pins DUMMY_H */
#define CY_PINS_DUMMY_H

#include "cytypes.h"
#include "cyfitter.h"
#include "cypins.h"
#include "DUMMY_aliases.h"

/* Check to see if required defines such as CY_PSOC5A are available */
/* They are defined starting with cy_boot v3.0 */
#if !defined (CY_PSOC5A)
    #error Component cy_pins_v1_70 requires cy_boot v3.0 or later
#endif /* (CY_PSOC5A) */

/* APIs are not generated for P15[7:6] */
#if !(CY_PSOC5A &&\
	 DUMMY__PORT == 15 && (DUMMY__MASK & 0xC0))

/***************************************
*        Function Prototypes             
***************************************/    

void    DUMMY_Write(uint8 value) ;
void    DUMMY_SetDriveMode(uint8 mode) ;
uint8   DUMMY_ReadDataReg(void) ;
uint8   DUMMY_Read(void) ;
uint8   DUMMY_ClearInterrupt(void) ;

/***************************************
*           API Constants        
***************************************/

/* Drive Modes */
#define DUMMY_DM_ALG_HIZ         PIN_DM_ALG_HIZ
#define DUMMY_DM_DIG_HIZ         PIN_DM_DIG_HIZ
#define DUMMY_DM_RES_UP          PIN_DM_RES_UP
#define DUMMY_DM_RES_DWN         PIN_DM_RES_DWN
#define DUMMY_DM_OD_LO           PIN_DM_OD_LO
#define DUMMY_DM_OD_HI           PIN_DM_OD_HI
#define DUMMY_DM_STRONG          PIN_DM_STRONG
#define DUMMY_DM_RES_UPDWN       PIN_DM_RES_UPDWN

/* Digital Port Constants */
#define DUMMY_MASK               DUMMY__MASK
#define DUMMY_SHIFT              DUMMY__SHIFT
#define DUMMY_WIDTH              1u

/***************************************
*             Registers        
***************************************/

/* Main Port Registers */
/* Pin State */
#define DUMMY_PS                     (* (reg8 *) DUMMY__PS)
/* Data Register */
#define DUMMY_DR                     (* (reg8 *) DUMMY__DR)
/* Port Number */
#define DUMMY_PRT_NUM                (* (reg8 *) DUMMY__PRT) 
/* Connect to Analog Globals */                                                  
#define DUMMY_AG                     (* (reg8 *) DUMMY__AG)                       
/* Analog MUX bux enable */
#define DUMMY_AMUX                   (* (reg8 *) DUMMY__AMUX) 
/* Bidirectional Enable */                                                        
#define DUMMY_BIE                    (* (reg8 *) DUMMY__BIE)
/* Bit-mask for Aliased Register Access */
#define DUMMY_BIT_MASK               (* (reg8 *) DUMMY__BIT_MASK)
/* Bypass Enable */
#define DUMMY_BYP                    (* (reg8 *) DUMMY__BYP)
/* Port wide control signals */                                                   
#define DUMMY_CTL                    (* (reg8 *) DUMMY__CTL)
/* Drive Modes */
#define DUMMY_DM0                    (* (reg8 *) DUMMY__DM0) 
#define DUMMY_DM1                    (* (reg8 *) DUMMY__DM1)
#define DUMMY_DM2                    (* (reg8 *) DUMMY__DM2) 
/* Input Buffer Disable Override */
#define DUMMY_INP_DIS                (* (reg8 *) DUMMY__INP_DIS)
/* LCD Common or Segment Drive */
#define DUMMY_LCD_COM_SEG            (* (reg8 *) DUMMY__LCD_COM_SEG)
/* Enable Segment LCD */
#define DUMMY_LCD_EN                 (* (reg8 *) DUMMY__LCD_EN)
/* Slew Rate Control */
#define DUMMY_SLW                    (* (reg8 *) DUMMY__SLW)

/* DSI Port Registers */
/* Global DSI Select Register */
#define DUMMY_PRTDSI__CAPS_SEL       (* (reg8 *) DUMMY__PRTDSI__CAPS_SEL) 
/* Double Sync Enable */
#define DUMMY_PRTDSI__DBL_SYNC_IN    (* (reg8 *) DUMMY__PRTDSI__DBL_SYNC_IN) 
/* Output Enable Select Drive Strength */
#define DUMMY_PRTDSI__OE_SEL0        (* (reg8 *) DUMMY__PRTDSI__OE_SEL0) 
#define DUMMY_PRTDSI__OE_SEL1        (* (reg8 *) DUMMY__PRTDSI__OE_SEL1) 
/* Port Pin Output Select Registers */
#define DUMMY_PRTDSI__OUT_SEL0       (* (reg8 *) DUMMY__PRTDSI__OUT_SEL0) 
#define DUMMY_PRTDSI__OUT_SEL1       (* (reg8 *) DUMMY__PRTDSI__OUT_SEL1) 
/* Sync Output Enable Registers */
#define DUMMY_PRTDSI__SYNC_OUT       (* (reg8 *) DUMMY__PRTDSI__SYNC_OUT) 


#if defined(DUMMY__INTSTAT)  /* Interrupt Registers */

    #define DUMMY_INTSTAT                (* (reg8 *) DUMMY__INTSTAT)
    #define DUMMY_SNAP                   (* (reg8 *) DUMMY__SNAP)

#endif /* Interrupt Registers */

#endif /* End Pins DUMMY_H */

#endif
/* [] END OF FILE */
