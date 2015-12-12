/*******************************************************************************
* File Name: DOWN_PIN.c  
* Version 1.70
*
* Description:
*  This file contains API to enable firmware control of a Pins component.
*
* Note:
*
********************************************************************************
* Copyright 2008-2010, Cypress Semiconductor Corporation.  All rights reserved.
* You may use this file only in accordance with the license, terms, conditions, 
* disclaimers, and limitations in the end user license agreement accompanying 
* the software package with which this file was provided.
********************************************************************************/

#include "cytypes.h"
#include "DOWN_PIN.h"

/* APIs are not generated for P15[7:6] */
#if !(CY_PSOC5A &&\
	 DOWN_PIN__PORT == 15 && (DOWN_PIN__MASK & 0xC0))

/*******************************************************************************
* Function Name: DOWN_PIN_Write
********************************************************************************
* Summary:
*  Assign a new value to the digital port's data output register.  
*
* Parameters:  
*  prtValue:  The value to be assigned to the Digital Port. 
*
* Return: 
*  void 
*  
*******************************************************************************/
void DOWN_PIN_Write(uint8 value) 
{
    uint8 staticBits = DOWN_PIN_DR & ~DOWN_PIN_MASK;
    DOWN_PIN_DR = staticBits | ((value << DOWN_PIN_SHIFT) & DOWN_PIN_MASK);
}


/*******************************************************************************
* Function Name: DOWN_PIN_SetDriveMode
********************************************************************************
* Summary:
*  Change the drive mode on the pins of the port.
* 
* Parameters:  
*  mode:  Change the pins to this drive mode.
*
* Return: 
*  void
*
*******************************************************************************/
void DOWN_PIN_SetDriveMode(uint8 mode) 
{
	CyPins_SetPinDriveMode(DOWN_PIN_0, mode);
}


/*******************************************************************************
* Function Name: DOWN_PIN_Read
********************************************************************************
* Summary:
*  Read the current value on the pins of the Digital Port in right justified 
*  form.
*
* Parameters:  
*  void 
*
* Return: 
*  Returns the current value of the Digital Port as a right justified number
*  
* Note:
*  Macro DOWN_PIN_ReadPS calls this function. 
*  
*******************************************************************************/
uint8 DOWN_PIN_Read(void) 
{
    return (DOWN_PIN_PS & DOWN_PIN_MASK) >> DOWN_PIN_SHIFT;
}


/*******************************************************************************
* Function Name: DOWN_PIN_ReadDataReg
********************************************************************************
* Summary:
*  Read the current value assigned to a Digital Port's data output register
*
* Parameters:  
*  void 
*
* Return: 
*  Returns the current value assigned to the Digital Port's data output register
*  
*******************************************************************************/
uint8 DOWN_PIN_ReadDataReg(void) 
{
    return (DOWN_PIN_DR & DOWN_PIN_MASK) >> DOWN_PIN_SHIFT;
}


/* If Interrupts Are Enabled for this Pins component */ 
#if defined(DOWN_PIN_INTSTAT) 

    /*******************************************************************************
    * Function Name: DOWN_PIN_ClearInterrupt
    ********************************************************************************
    * Summary:
    *  Clears any active interrupts attached to port and returns the value of the 
    *  interrupt status register.
    *
    * Parameters:  
    *  void 
    *
    * Return: 
    *  Returns the value of the interrupt status register
    *  
    *******************************************************************************/
    uint8 DOWN_PIN_ClearInterrupt(void) 
    {
        return (DOWN_PIN_INTSTAT & DOWN_PIN_MASK) >> DOWN_PIN_SHIFT;
    }

#endif /* If Interrupts Are Enabled for this Pins component */ 

#endif
/* [] END OF FILE */ 
