/*******************************************************************************
* File Name: command_isr.h
* Version 1.60
*
*  Description:
*   Provides the function definitions for the Interrupt Controller.
*
*
********************************************************************************
* Copyright 2008-2010, Cypress Semiconductor Corporation.  All rights reserved.
* You may use this file only in accordance with the license, terms, conditions, 
* disclaimers, and limitations in the end user license agreement accompanying 
* the software package with which this file was provided.
********************************************************************************/
#if !defined(__command_isr_INTC_H__)
#define __command_isr_INTC_H__


#include <cytypes.h>
#include <cyfitter.h>

/* Interrupt Controller API. */
void command_isr_Start(void);
void command_isr_StartEx(cyisraddress address);
void command_isr_Stop(void) ;

CY_ISR_PROTO(command_isr_Interrupt);

void command_isr_SetVector(cyisraddress address) ;
cyisraddress command_isr_GetVector(void) ;

void command_isr_SetPriority(uint8 priority) ;
uint8 command_isr_GetPriority(void) ;

void command_isr_Enable(void) ;
uint8 command_isr_GetState(void) ;
void command_isr_Disable(void) ;

void command_isr_SetPending(void) ;
void command_isr_ClearPending(void) ;


/* Interrupt Controller Constants */

/* Address of the INTC.VECT[x] register that contains the Address of the command_isr ISR. */
#define command_isr_INTC_VECTOR            ((reg32 *) command_isr__INTC_VECT)

/* Address of the command_isr ISR priority. */
#define command_isr_INTC_PRIOR             ((reg8 *) command_isr__INTC_PRIOR_REG)

/* Priority of the command_isr interrupt. */
#define command_isr_INTC_PRIOR_NUMBER      command_isr__INTC_PRIOR_NUM

/* Address of the INTC.SET_EN[x] byte to bit enable command_isr interrupt. */
#define command_isr_INTC_SET_EN            ((reg32 *) command_isr__INTC_SET_EN_REG)

/* Address of the INTC.CLR_EN[x] register to bit clear the command_isr interrupt. */
#define command_isr_INTC_CLR_EN            ((reg32 *) command_isr__INTC_CLR_EN_REG)

/* Address of the INTC.SET_PD[x] register to set the command_isr interrupt state to pending. */
#define command_isr_INTC_SET_PD            ((reg32 *) command_isr__INTC_SET_PD_REG)

/* Address of the INTC.CLR_PD[x] register to clear the command_isr interrupt. */
#define command_isr_INTC_CLR_PD            ((reg32 *) command_isr__INTC_CLR_PD_REG)



/* __command_isr_INTC_H__ */
#endif
