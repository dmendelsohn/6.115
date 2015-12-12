/*******************************************************************************
* File Name: RIGHT_PIN.h  
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

#if !defined(CY_PINS_RIGHT_PIN_H) /* Pins RIGHT_PIN_H */
#define CY_PINS_RIGHT_PIN_H

#include "cytypes.h"
#include "cyfitter.h"
#include "cypins.h"
#include "RIGHT_PIN_aliases.h"

/* Check to see if required defines such as CY_PSOC5A are available */
/* They are defined starting with cy_boot v3.0 */
#if !defined (CY_PSOC5A)
    #error Component cy_pins_v1_70 requires cy_boot v3.0 or later
#endif /* (CY_PSOC5A) */

/* APIs are not generated for P15[7:6] */
#if !(CY_PSOC5A &&\
	 RIGHT_PIN__PORT == 15 && (RIGHT_PIN__MASK & 0xC0))

/***************************************
*        Function Prototypes             
***************************************/    

void    RIGHT_PIN_Write(uint8 value) ;
void    RIGHT_PIN_SetDriveMode(uint8 mode) ;
uint8   RIGHT_PIN_ReadDataReg(void) ;
uint8   RIGHT_PIN_Read(void) ;
uint8   RIGHT_PIN_ClearInterrupt(void) ;

/***************************************
*           API Constants        
***************************************/

/* Drive Modes */
#define RIGHT_PIN_DM_ALG_HIZ         PIN_DM_ALG_HIZ
#define RIGHT_PIN_DM_DIG_HIZ         PIN_DM_DIG_HIZ
#define RIGHT_PIN_DM_RES_UP          PIN_DM_RES_UP
#define RIGHT_PIN_DM_RES_DWN         PIN_DM_RES_DWN
#define RIGHT_PIN_DM_OD_LO           PIN_DM_OD_LO
#define RIGHT_PIN_DM_OD_HI           PIN_DM_OD_HI
#define RIGHT_PIN_DM_STRONG          PIN_DM_STRONG
#define RIGHT_PIN_DM_RES_UPDWN       PIN_DM_RES_UPDWN

/* Digital Port Constants */
#define RIGHT_PIN_MASK               RIGHT_PIN__MASK
#define RIGHT_PIN_SHIFT              RIGHT_PIN__SHIFT
#define RIGHT_PIN_WIDTH              1u

/***************************************
*             Registers        
***************************************/

/* Main Port Registers */
/* Pin State */
#define RIGHT_PIN_PS                     (* (reg8 *) RIGHT_PIN__PS)
/* Data Register */
#define RIGHT_PIN_DR                     (* (reg8 *) RIGHT_PIN__DR)
/* Port Number */
#define RIGHT_PIN_PRT_NUM                (* (reg8 *) RIGHT_PIN__PRT) 
/* Connect to Analog Globals */                                                  
#define RIGHT_PIN_AG                     (* (reg8 *) RIGHT_PIN__AG)                       
/* Analog MUX bux enable */
#define RIGHT_PIN_AMUX                   (* (reg8 *) RIGHT_PIN__AMUX) 
/* Bidirectional Enable */                                                        
#define RIGHT_PIN_BIE                    (* (reg8 *) RIGHT_PIN__BIE)
/* Bit-mask for Aliased Register Access */
#define RIGHT_PIN_BIT_MASK               (* (reg8 *) RIGHT_PIN__BIT_MASK)
/* Bypass Enable */
#define RIGHT_PIN_BYP                    (* (reg8 *) RIGHT_PIN__BYP)
/* Port wide control signals */                                                   
#define RIGHT_PIN_CTL                    (* (reg8 *) RIGHT_PIN__CTL)
/* Drive Modes */
#define RIGHT_PIN_DM0                    (* (reg8 *) RIGHT_PIN__DM0) 
#define RIGHT_PIN_DM1                    (* (reg8 *) RIGHT_PIN__DM1)
#define RIGHT_PIN_DM2                    (* (reg8 *) RIGHT_PIN__DM2) 
/* Input Buffer Disable Override */
#define RIGHT_PIN_INP_DIS                (* (reg8 *) RIGHT_PIN__INP_DIS)
/* LCD Common or Segment Drive */
#define RIGHT_PIN_LCD_COM_SEG            (* (reg8 *) RIGHT_PIN__LCD_COM_SEG)
/* Enable Segment LCD */
#define RIGHT_PIN_LCD_EN                 (* (reg8 *) RIGHT_PIN__LCD_EN)
/* Slew Rate Control */
#define RIGHT_PIN_SLW                    (* (reg8 *) RIGHT_PIN__SLW)

/* DSI Port Registers */
/* Global DSI Select Register */
#define RIGHT_PIN_PRTDSI__CAPS_SEL       (* (reg8 *) RIGHT_PIN__PRTDSI__CAPS_SEL) 
/* Double Sync Enable */
#define RIGHT_PIN_PRTDSI__DBL_SYNC_IN    (* (reg8 *) RIGHT_PIN__PRTDSI__DBL_SYNC_IN) 
/* Output Enable Select Drive Strength */
#define RIGHT_PIN_PRTDSI__OE_SEL0        (* (reg8 *) RIGHT_PIN__PRTDSI__OE_SEL0) 
#define RIGHT_PIN_PRTDSI__OE_SEL1        (* (reg8 *) RIGHT_PIN__PRTDSI__OE_SEL1) 
/* Port Pin Output Select Registers */
#define RIGHT_PIN_PRTDSI__OUT_SEL0       (* (reg8 *) RIGHT_PIN__PRTDSI__OUT_SEL0) 
#define RIGHT_PIN_PRTDSI__OUT_SEL1       (* (reg8 *) RIGHT_PIN__PRTDSI__OUT_SEL1) 
/* Sync Output Enable Registers */
#define RIGHT_PIN_PRTDSI__SYNC_OUT       (* (reg8 *) RIGHT_PIN__PRTDSI__SYNC_OUT) 


#if defined(RIGHT_PIN__INTSTAT)  /* Interrupt Registers */

    #define RIGHT_PIN_INTSTAT                (* (reg8 *) RIGHT_PIN__INTSTAT)
    #define RIGHT_PIN_SNAP                   (* (reg8 *) RIGHT_PIN__SNAP)

#endif /* Interrupt Registers */

#endif /* End Pins RIGHT_PIN_H */

#endif
/* [] END OF FILE */
