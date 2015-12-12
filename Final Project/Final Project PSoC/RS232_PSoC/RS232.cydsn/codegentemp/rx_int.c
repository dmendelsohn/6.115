/*******************************************************************************
* File Name: rx_int.c  
* Version 1.60
*
*  Description:
*   API for controlling the state of an interrupt.
*
*
*  Note:
*
********************************************************************************
* Copyright 2008-2010, Cypress Semiconductor Corporation.  All rights reserved.
* You may use this file only in accordance with the license, terms, conditions, 
* disclaimers, and limitations in the end user license agreement accompanying 
* the software package with which this file was provided.
********************************************************************************/


#include <CYDEVICE.H>
#include <CYDEVICE_TRM.H>
#include <CYLIB.H>
#include <rx_int.H>


/*******************************************************************************
*  Place your includes, defines and code here 
********************************************************************************/
/* `#START rx_int_intc` */

/* `#END` */

#ifndef CYINT_IRQ_BASE
#define CYINT_IRQ_BASE	16
#endif
#ifndef CYINT_VECT_TABLE
#define CYINT_VECT_TABLE    ((cyisraddress **) CYREG_NVIC_VECT_OFFSET)
#endif

/* Declared in startup, used to set unused interrupts to. */
CY_ISR_PROTO(IntDefaultHandler);

/*******************************************************************************
* Function Name: rx_int_Start
********************************************************************************
* Summary:
*  Set up the interrupt and enable it.
*
* Parameters:  
*   void.
*
*
* Return:
*   void.
*
*******************************************************************************/
void rx_int_Start(void)
{
    /* For all we know the interrupt is active. */
    rx_int_Disable();

    /* Set the ISR to point to the rx_int Interrupt. */
    rx_int_SetVector(rx_int_Interrupt);

    /* Set the priority. */
    rx_int_SetPriority(rx_int_INTC_PRIOR_NUMBER);

    /* Enable it. */
    rx_int_Enable();
}

/*******************************************************************************
* Function Name: rx_int_StartEx
********************************************************************************
* Summary:
*  Set up the interrupt and enable it.
*
* Parameters:  
*   address: Address of the ISR to set in the interrupt vector table.
*
*
* Return:
*   void.
*
*******************************************************************************/
void rx_int_StartEx(cyisraddress address)
{
    /* For all we know the interrupt is active. */
    rx_int_Disable();

    /* Set the ISR to point to the rx_int Interrupt. */
    rx_int_SetVector(address);

    /* Set the priority. */
    rx_int_SetPriority(rx_int_INTC_PRIOR_NUMBER);

    /* Enable it. */
    rx_int_Enable();
}

/*******************************************************************************
* Function Name: rx_int_Stop
********************************************************************************
* Summary:
*   Disables and removes the interrupt.
*
* Parameters:  
*
*
* Return:
*   void.
*
*******************************************************************************/
void rx_int_Stop(void) 
{
    /* Disable this interrupt. */
    rx_int_Disable();

    /* Set the ISR to point to the passive one. */
    rx_int_SetVector(IntDefaultHandler);
}

/*******************************************************************************
* Function Name: rx_int_Interrupt
********************************************************************************
* Summary:
*   The default Interrupt Service Routine for rx_int.
*
*   Add custom code between the coments to keep the next version of this file
*   from over writting your code.
*
*
*
* Parameters:  
*
*
* Return:
*   void.
*
*******************************************************************************/
CY_ISR(rx_int_Interrupt)
{
    /*  Place your Interrupt code here. */
    /* `#START rx_int_Interrupt` */
       /* uint8 data =  UART_ReadRxData();
        if (data == 0b11111111){
            LCD_PrintString("OOPS                ");			// clean up the previous display
        ;    LCD_Position(0,0);
        }
        else{
        LCD_WriteData(data);
        } */ // commented out
    /* `#END` */
}

/*******************************************************************************
* Function Name: rx_int_SetVector
********************************************************************************
* Summary:
*   Change the ISR vector for the Interrupt. Note calling rx_int_Start
*   will override any effect this method would have had. To set the vector before
*   the component has been started use rx_int_StartEx instead.
*
*
* Parameters:
*   address: Address of the ISR to set in the interrupt vector table.
*
*
* Return:
*   void.
*
*
*******************************************************************************/
void rx_int_SetVector(cyisraddress address) 
{
    cyisraddress * ramVectorTable;

    ramVectorTable = (cyisraddress *) *CYINT_VECT_TABLE;

    ramVectorTable[CYINT_IRQ_BASE + rx_int__INTC_NUMBER] = address;
}

/*******************************************************************************
* Function Name: rx_int_GetVector
********************************************************************************
* Summary:
*   Gets the "address" of the current ISR vector for the Interrupt.
*
*
* Parameters:
*   void.
*
*
* Return:
*   Address of the ISR in the interrupt vector table.
*
*
*******************************************************************************/
cyisraddress rx_int_GetVector(void) 
{
    cyisraddress * ramVectorTable;

    ramVectorTable = (cyisraddress *) *CYINT_VECT_TABLE;

    return ramVectorTable[CYINT_IRQ_BASE + rx_int__INTC_NUMBER];
}

/*******************************************************************************
* Function Name: rx_int_SetPriority
********************************************************************************
* Summary:
*   Sets the Priority of the Interrupt. Note calling rx_int_Start
*   or rx_int_StartEx will override any effect this method would have had. 
*	This method should only be called after rx_int_Start or 
*	rx_int_StartEx has been called. To set the initial
*	priority for the component use the cydwr file in the tool.
*
*
* Parameters:
*   priority: Priority of the interrupt. 0 - 7, 0 being the highest.
*
*
* Return:
*   void.
*
*
*******************************************************************************/
void rx_int_SetPriority(uint8 priority) 
{
    *rx_int_INTC_PRIOR = priority << 5;
}

/*******************************************************************************
* Function Name: rx_int_GetPriority
********************************************************************************
* Summary:
*   Gets the Priority of the Interrupt.
*
*
* Parameters:
*   void.
*
*
* Return:
*   Priority of the interrupt. 0 - 7, 0 being the highest.
*
*
*******************************************************************************/
uint8 rx_int_GetPriority(void) 
{
    uint8 priority;


    priority = *rx_int_INTC_PRIOR >> 5;

    return priority;
}

/*******************************************************************************
* Function Name: rx_int_Enable
********************************************************************************
* Summary:
*   Enables the interrupt.
*
*
* Parameters:
*   void.
*
*
* Return:
*   void.
*
*
*******************************************************************************/
void rx_int_Enable(void) 
{
    /* Enable the general interrupt. */
    *rx_int_INTC_SET_EN = rx_int__INTC_MASK;
}

/*******************************************************************************
* Function Name: rx_int_GetState
********************************************************************************
* Summary:
*   Gets the state (enabled, disabled) of the Interrupt.
*
*
* Parameters:
*   void.
*
*
* Return:
*   1 if enabled, 0 if disabled.
*
*
*******************************************************************************/
uint8 rx_int_GetState(void) 
{
    /* Get the state of the general interrupt. */
    return (*rx_int_INTC_SET_EN & rx_int__INTC_MASK) ? 1:0;
}

/*******************************************************************************
* Function Name: rx_int_Disable
********************************************************************************
* Summary:
*   Disables the Interrupt.
*
*
* Parameters:
*   void.
*
*
* Return:
*   void.
*
*
*******************************************************************************/
void rx_int_Disable(void) 
{
    /* Disable the general interrupt. */
    *rx_int_INTC_CLR_EN = rx_int__INTC_MASK;
}

/*******************************************************************************
* Function Name: rx_int_SetPending
********************************************************************************
* Summary:
*   Causes the Interrupt to enter the pending state, a software method of
*   generating the interrupt.
*
*
* Parameters:
*   void.
*
*
* Return:
*   void.
*
*
*******************************************************************************/
void rx_int_SetPending(void) 
{
    *rx_int_INTC_SET_PD = rx_int__INTC_MASK;
}

/*******************************************************************************
* Function Name: rx_int_ClearPending
********************************************************************************
* Summary:
*   Clears a pending interrupt.
*
* Parameters:
*   void.
*
*
* Return:
*   void.
*
*
*******************************************************************************/
void rx_int_ClearPending(void) 
{
    *rx_int_INTC_CLR_PD = rx_int__INTC_MASK;
}
