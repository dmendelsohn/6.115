/*******************************************************************************
* File Name: MID_PIN.h  
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

#if !defined(CY_PINS_MID_PIN_H) /* Pins MID_PIN_H */
#define CY_PINS_MID_PIN_H

#include "cytypes.h"
#include "cyfitter.h"
#include "cypins.h"
#include "MID_PIN_aliases.h"

/* Check to see if required defines such as CY_PSOC5A are available */
/* They are defined starting with cy_boot v3.0 */
#if !defined (CY_PSOC5A)
    #error Component cy_pins_v1_70 requires cy_boot v3.0 or later
#endif /* (CY_PSOC5A) */

/* APIs are not generated for P15[7:6] */
#if !(CY_PSOC5A &&\
	 MID_PIN__PORT == 15 && (MID_PIN__MASK & 0xC0))

/***************************************
*        Function Prototypes             
***************************************/    

void    MID_PIN_Write(uint8 value) ;
void    MID_PIN_SetDriveMode(uint8 mode) ;
uint8   MID_PIN_ReadDataReg(void) ;
uint8   MID_PIN_Read(void) ;
uint8   MID_PIN_ClearInterrupt(void) ;

/***************************************
*           API Constants        
***************************************/

/* Drive Modes */
#define MID_PIN_DM_ALG_HIZ         PIN_DM_ALG_HIZ
#define MID_PIN_DM_DIG_HIZ         PIN_DM_DIG_HIZ
#define MID_PIN_DM_RES_UP          PIN_DM_RES_UP
#define MID_PIN_DM_RES_DWN         PIN_DM_RES_DWN
#define MID_PIN_DM_OD_LO           PIN_DM_OD_LO
#define MID_PIN_DM_OD_HI           PIN_DM_OD_HI
#define MID_PIN_DM_STRONG          PIN_DM_STRONG
#define MID_PIN_DM_RES_UPDWN       PIN_DM_RES_UPDWN

/* Digital Port Constants */
#define MID_PIN_MASK               MID_PIN__MASK
#define MID_PIN_SHIFT              MID_PIN__SHIFT
#define MID_PIN_WIDTH              1u

/***************************************
*             Registers        
***************************************/

/* Main Port Registers */
/* Pin State */
#define MID_PIN_PS                     (* (reg8 *) MID_PIN__PS)
/* Data Register */
#define MID_PIN_DR                     (* (reg8 *) MID_PIN__DR)
/* Port Number */
#define MID_PIN_PRT_NUM                (* (reg8 *) MID_PIN__PRT) 
/* Connect to Analog Globals */                                                  
#define MID_PIN_AG                     (* (reg8 *) MID_PIN__AG)                       
/* Analog MUX bux enable */
#define MID_PIN_AMUX                   (* (reg8 *) MID_PIN__AMUX) 
/* Bidirectional Enable */                                                        
#define MID_PIN_BIE                    (* (reg8 *) MID_PIN__BIE)
/* Bit-mask for Aliased Register Access */
#define MID_PIN_BIT_MASK               (* (reg8 *) MID_PIN__BIT_MASK)
/* Bypass Enable */
#define MID_PIN_BYP                    (* (reg8 *) MID_PIN__BYP)
/* Port wide control signals */                                                   
#define MID_PIN_CTL                    (* (reg8 *) MID_PIN__CTL)
/* Drive Modes */
#define MID_PIN_DM0                    (* (reg8 *) MID_PIN__DM0) 
#define MID_PIN_DM1                    (* (reg8 *) MID_PIN__DM1)
#define MID_PIN_DM2                    (* (reg8 *) MID_PIN__DM2) 
/* Input Buffer Disable Override */
#define MID_PIN_INP_DIS                (* (reg8 *) MID_PIN__INP_DIS)
/* LCD Common or Segment Drive */
#define MID_PIN_LCD_COM_SEG            (* (reg8 *) MID_PIN__LCD_COM_SEG)
/* Enable Segment LCD */
#define MID_PIN_LCD_EN                 (* (reg8 *) MID_PIN__LCD_EN)
/* Slew Rate Control */
#define MID_PIN_SLW                    (* (reg8 *) MID_PIN__SLW)

/* DSI Port Registers */
/* Global DSI Select Register */
#define MID_PIN_PRTDSI__CAPS_SEL       (* (reg8 *) MID_PIN__PRTDSI__CAPS_SEL) 
/* Double Sync Enable */
#define MID_PIN_PRTDSI__DBL_SYNC_IN    (* (reg8 *) MID_PIN__PRTDSI__DBL_SYNC_IN) 
/* Output Enable Select Drive Strength */
#define MID_PIN_PRTDSI__OE_SEL0        (* (reg8 *) MID_PIN__PRTDSI__OE_SEL0) 
#define MID_PIN_PRTDSI__OE_SEL1        (* (reg8 *) MID_PIN__PRTDSI__OE_SEL1) 
/* Port Pin Output Select Registers */
#define MID_PIN_PRTDSI__OUT_SEL0       (* (reg8 *) MID_PIN__PRTDSI__OUT_SEL0) 
#define MID_PIN_PRTDSI__OUT_SEL1       (* (reg8 *) MID_PIN__PRTDSI__OUT_SEL1) 
/* Sync Output Enable Registers */
#define MID_PIN_PRTDSI__SYNC_OUT       (* (reg8 *) MID_PIN__PRTDSI__SYNC_OUT) 


#if defined(MID_PIN__INTSTAT)  /* Interrupt Registers */

    #define MID_PIN_INTSTAT                (* (reg8 *) MID_PIN__INTSTAT)
    #define MID_PIN_SNAP                   (* (reg8 *) MID_PIN__SNAP)

#endif /* Interrupt Registers */

#endif /* End Pins MID_PIN_H */

#endif
/* [] END OF FILE */
