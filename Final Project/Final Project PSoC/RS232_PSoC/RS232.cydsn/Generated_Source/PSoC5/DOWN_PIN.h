/*******************************************************************************
* File Name: DOWN_PIN.h  
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

#if !defined(CY_PINS_DOWN_PIN_H) /* Pins DOWN_PIN_H */
#define CY_PINS_DOWN_PIN_H

#include "cytypes.h"
#include "cyfitter.h"
#include "cypins.h"
#include "DOWN_PIN_aliases.h"

/* Check to see if required defines such as CY_PSOC5A are available */
/* They are defined starting with cy_boot v3.0 */
#if !defined (CY_PSOC5A)
    #error Component cy_pins_v1_70 requires cy_boot v3.0 or later
#endif /* (CY_PSOC5A) */

/* APIs are not generated for P15[7:6] */
#if !(CY_PSOC5A &&\
	 DOWN_PIN__PORT == 15 && (DOWN_PIN__MASK & 0xC0))

/***************************************
*        Function Prototypes             
***************************************/    

void    DOWN_PIN_Write(uint8 value) ;
void    DOWN_PIN_SetDriveMode(uint8 mode) ;
uint8   DOWN_PIN_ReadDataReg(void) ;
uint8   DOWN_PIN_Read(void) ;
uint8   DOWN_PIN_ClearInterrupt(void) ;

/***************************************
*           API Constants        
***************************************/

/* Drive Modes */
#define DOWN_PIN_DM_ALG_HIZ         PIN_DM_ALG_HIZ
#define DOWN_PIN_DM_DIG_HIZ         PIN_DM_DIG_HIZ
#define DOWN_PIN_DM_RES_UP          PIN_DM_RES_UP
#define DOWN_PIN_DM_RES_DWN         PIN_DM_RES_DWN
#define DOWN_PIN_DM_OD_LO           PIN_DM_OD_LO
#define DOWN_PIN_DM_OD_HI           PIN_DM_OD_HI
#define DOWN_PIN_DM_STRONG          PIN_DM_STRONG
#define DOWN_PIN_DM_RES_UPDWN       PIN_DM_RES_UPDWN

/* Digital Port Constants */
#define DOWN_PIN_MASK               DOWN_PIN__MASK
#define DOWN_PIN_SHIFT              DOWN_PIN__SHIFT
#define DOWN_PIN_WIDTH              1u

/***************************************
*             Registers        
***************************************/

/* Main Port Registers */
/* Pin State */
#define DOWN_PIN_PS                     (* (reg8 *) DOWN_PIN__PS)
/* Data Register */
#define DOWN_PIN_DR                     (* (reg8 *) DOWN_PIN__DR)
/* Port Number */
#define DOWN_PIN_PRT_NUM                (* (reg8 *) DOWN_PIN__PRT) 
/* Connect to Analog Globals */                                                  
#define DOWN_PIN_AG                     (* (reg8 *) DOWN_PIN__AG)                       
/* Analog MUX bux enable */
#define DOWN_PIN_AMUX                   (* (reg8 *) DOWN_PIN__AMUX) 
/* Bidirectional Enable */                                                        
#define DOWN_PIN_BIE                    (* (reg8 *) DOWN_PIN__BIE)
/* Bit-mask for Aliased Register Access */
#define DOWN_PIN_BIT_MASK               (* (reg8 *) DOWN_PIN__BIT_MASK)
/* Bypass Enable */
#define DOWN_PIN_BYP                    (* (reg8 *) DOWN_PIN__BYP)
/* Port wide control signals */                                                   
#define DOWN_PIN_CTL                    (* (reg8 *) DOWN_PIN__CTL)
/* Drive Modes */
#define DOWN_PIN_DM0                    (* (reg8 *) DOWN_PIN__DM0) 
#define DOWN_PIN_DM1                    (* (reg8 *) DOWN_PIN__DM1)
#define DOWN_PIN_DM2                    (* (reg8 *) DOWN_PIN__DM2) 
/* Input Buffer Disable Override */
#define DOWN_PIN_INP_DIS                (* (reg8 *) DOWN_PIN__INP_DIS)
/* LCD Common or Segment Drive */
#define DOWN_PIN_LCD_COM_SEG            (* (reg8 *) DOWN_PIN__LCD_COM_SEG)
/* Enable Segment LCD */
#define DOWN_PIN_LCD_EN                 (* (reg8 *) DOWN_PIN__LCD_EN)
/* Slew Rate Control */
#define DOWN_PIN_SLW                    (* (reg8 *) DOWN_PIN__SLW)

/* DSI Port Registers */
/* Global DSI Select Register */
#define DOWN_PIN_PRTDSI__CAPS_SEL       (* (reg8 *) DOWN_PIN__PRTDSI__CAPS_SEL) 
/* Double Sync Enable */
#define DOWN_PIN_PRTDSI__DBL_SYNC_IN    (* (reg8 *) DOWN_PIN__PRTDSI__DBL_SYNC_IN) 
/* Output Enable Select Drive Strength */
#define DOWN_PIN_PRTDSI__OE_SEL0        (* (reg8 *) DOWN_PIN__PRTDSI__OE_SEL0) 
#define DOWN_PIN_PRTDSI__OE_SEL1        (* (reg8 *) DOWN_PIN__PRTDSI__OE_SEL1) 
/* Port Pin Output Select Registers */
#define DOWN_PIN_PRTDSI__OUT_SEL0       (* (reg8 *) DOWN_PIN__PRTDSI__OUT_SEL0) 
#define DOWN_PIN_PRTDSI__OUT_SEL1       (* (reg8 *) DOWN_PIN__PRTDSI__OUT_SEL1) 
/* Sync Output Enable Registers */
#define DOWN_PIN_PRTDSI__SYNC_OUT       (* (reg8 *) DOWN_PIN__PRTDSI__SYNC_OUT) 


#if defined(DOWN_PIN__INTSTAT)  /* Interrupt Registers */

    #define DOWN_PIN_INTSTAT                (* (reg8 *) DOWN_PIN__INTSTAT)
    #define DOWN_PIN_SNAP                   (* (reg8 *) DOWN_PIN__SNAP)

#endif /* Interrupt Registers */

#endif /* End Pins DOWN_PIN_H */

#endif
/* [] END OF FILE */
