/*******************************************************************************
* File Name: MID_PIN.c  
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
#include "MID_PIN.h"

/* APIs are not generated for P15[7:6] */
#if !(CY_PSOC5A &&\
	 MID_PIN__PORT == 15 && (MID_PIN__MASK & 0xC0))

/*******************************************************************************
* Function Name: MID_PIN_Write
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
void MID_PIN_Write(uint8 value) 
{
    uint8 staticBits = MID_PIN_DR & ~MID_PIN_MASK;
    MID_PIN_DR = staticBits | ((value << MID_PIN_SHIFT) & MID_PIN_MASK);
}


/*******************************************************************************
* Function Name: MID_PIN_SetDriveMode
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
void MID_PIN_SetDriveMode(uint8 mode) 
{
	CyPins_SetPinDriveMode(MID_PIN_0, mode);
}


/*******************************************************************************
* Function Name: MID_PIN_Read
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
*  Macro MID_PIN_ReadPS calls this function. 
*  
*******************************************************************************/
uint8 MID_PIN_Read(void) 
{
    return (MID_PIN_PS & MID_PIN_MASK) >> MID_PIN_SHIFT;
}


/*******************************************************************************
* Function Name: MID_PIN_ReadDataReg
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
uint8 MID_PIN_ReadDataReg(void) 
{
    return (MID_PIN_DR & MID_PIN_MASK) >> MID_PIN_SHIFT;
}


/* If Interrupts Are Enabled for this Pins component */ 
#if defined(MID_PIN_INTSTAT) 

    /*******************************************************************************
    * Function Name: MID_PIN_ClearInterrupt
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
    uint8 MID_PIN_ClearInterrupt(void) 
    {
        return (MID_PIN_INTSTAT & MID_PIN_MASK) >> MID_PIN_SHIFT;
    }

#endif /* If Interrupts Are Enabled for this Pins component */ 

#endif
/* [] END OF FILE */ 
