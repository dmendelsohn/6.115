/*******************************************************************************
* File Name: TEST_PIN.c  
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
#include "TEST_PIN.h"

/* APIs are not generated for P15[7:6] */
#if !(CY_PSOC5A &&\
	 TEST_PIN__PORT == 15 && (TEST_PIN__MASK & 0xC0))

/*******************************************************************************
* Function Name: TEST_PIN_Write
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
void TEST_PIN_Write(uint8 value) 
{
    uint8 staticBits = TEST_PIN_DR & ~TEST_PIN_MASK;
    TEST_PIN_DR = staticBits | ((value << TEST_PIN_SHIFT) & TEST_PIN_MASK);
}


/*******************************************************************************
* Function Name: TEST_PIN_SetDriveMode
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
void TEST_PIN_SetDriveMode(uint8 mode) 
{
	CyPins_SetPinDriveMode(TEST_PIN_0, mode);
}


/*******************************************************************************
* Function Name: TEST_PIN_Read
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
*  Macro TEST_PIN_ReadPS calls this function. 
*  
*******************************************************************************/
uint8 TEST_PIN_Read(void) 
{
    return (TEST_PIN_PS & TEST_PIN_MASK) >> TEST_PIN_SHIFT;
}


/*******************************************************************************
* Function Name: TEST_PIN_ReadDataReg
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
uint8 TEST_PIN_ReadDataReg(void) 
{
    return (TEST_PIN_DR & TEST_PIN_MASK) >> TEST_PIN_SHIFT;
}


/* If Interrupts Are Enabled for this Pins component */ 
#if defined(TEST_PIN_INTSTAT) 

    /*******************************************************************************
    * Function Name: TEST_PIN_ClearInterrupt
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
    uint8 TEST_PIN_ClearInterrupt(void) 
    {
        return (TEST_PIN_INTSTAT & TEST_PIN_MASK) >> TEST_PIN_SHIFT;
    }

#endif /* If Interrupts Are Enabled for this Pins component */ 

#endif
/* [] END OF FILE */ 
