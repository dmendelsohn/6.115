#include <device.h>
#include <stdio.h>
#include <time.h>

#define N 4

//#define LEFT 0
//#define RIGHT 1
//#define TOP 2
//#define BOTTOM 3
//#define MIDDLE 4

#define BOTTOM 0
#define LEFT 1
#define RIGHT 2
#define TOP 3

#define NO_MOVE	0x00
#define UNDEF_MOVE 0x01
#define LEFT_MOVE	0x61
#define RIGHT_MOVE	0x64
#define DOWN_MOVE	0x73
#define ROTATE_MOVE	0x77

#define LOW_V -1
#define MID_v 0
#define HIGH_V 1

#define LOW_CUTOFF 50	// lower is considered "low"
#define HIGH_CUTOFF 120	// higher is considered "high"

#define POLL_DELAY 5	// how long between polls
#define COMMAND_DELAY 300	// how long between sending commands

void print_all_readings();
void update_readings();
void update_digital_readings();
int convert_to_digital(int val);
void update_state_machine();
void print_state();
int numLowReadings();
int numHighReadings();
int getWhichOneLow();
int convert_light_to_move_type();
void send_command(int val);
char* getNameOfMove(int val);

int readings[N];
int digital_readings[N];
int current_move;
int hold_down_state = 0;
int move_counter;

/* This ISR triggers at a low frequency.  It determines if the user is "holding"
and if so, repeats the last move */
CY_ISR(myisr) {
    if (current_move != NO_MOVE && current_move != UNDEF_MOVE) {
        if (hold_down_state) {
            send_command(current_move);
            move_counter++;
        } else {
            hold_down_state = 1;
        }
    }
}

void main()
{   
	LCD_Start();					    // initialize lcd
	LCD_ClearDisplay();
    
    ADC_Start();                        // start ADC
    ADC_StartConvert();
    
    AMux_Init();                        // start Mux
    AMux_Start();
    
    CyGlobalIntEnable;
    rx_int_Start();                     // start RX interrupt--look at this file under "Generated_Source"
                                        // for code that writes received bytes to LCD.
    
    UART_Start();                       // initialize UART
    UART_ClearRxBuffer();
    
    
    current_move = NO_MOVE;
    hold_down_state = 0;
    move_counter = 0;
    
    ISR_StartEx(myisr);

    for(;;) {
        CyDelay(POLL_DELAY);
        update_readings();                      //grab new 8 bit readings
        update_digital_readings();              //interpret as ternary readings           
        int old_state = current_move;
        update_state_machine();                 //update the state machine accordingly
        int new_state = current_move;
        if ((old_state == NO_MOVE) && (new_state != NO_MOVE) && (new_state != UNDEF_MOVE)) {
            move_counter = 1;                   // increment the "multiplicity" of the current move
            send_command(new_state);            // do a move if necessary
        }
    }
}

/* This is for testing only */
void print_all_readings() {
    LCD_ClearDisplay();
    char buff_1[50];
    sprintf(buff_1, "%d,%d,%d,%d",readings[0], readings[1],readings[2],\
            readings[3]);
    char buff_2[50];
    sprintf(buff_2,"%d,%d,%d,%d", digital_readings[0],\
            digital_readings[1],digital_readings[2],digital_readings[3]);
    LCD_Position(0,0);
    LCD_PrintString(buff_1);
    LCD_Position(1,0);
    LCD_PrintString(buff_2);
    LCD_Position(1,13);
    LCD_PrintNumber(current_move);
}

/* This is for testing only */
void print_state() {
    LCD_ClearDisplay();
    char buff[50];
    sprintf(buff, "State=%d", current_move);
    LCD_PrintString(buff);
}

/*Updates the 8 bit values of our readings by calling the ADC */
void update_readings() {
    int pins[] = {0, 1, 2, 3, 4};
    int i;
    for (i = 0; i < N; i++) {
        AMux_Select(pins[i]);                 //select the input
        CyDelayUs(50);            // delay 50 microseconds
        readings[i] = ADC_GetResult16();
        CyDelay(1); //delay 1000 microseconds
    }
}

/*Updates our digital ternary readings based on the current value of the 8 bit readings */
void update_digital_readings() {
    int i;
    for (i = 0; i < N; i++) {
        digital_readings[i] = convert_to_digital(readings[i]);
    }
}

/*Converts a 8 bit value from the ADC and interprets as either HIGH, LOW, or MID*/
int convert_to_digital(int val) {
    if (val < LOW_CUTOFF) {
        return 1;
    } else if (val > HIGH_CUTOFF) {
        return -1;
    } else {
        return 0;
    }
}

/* This routine updates the current_move variable to reflect a move in progress
a lack of a move, or a move that is undefined (e.g. diagonal moves) */
void update_state_machine() {
    int numLow = numLowReadings();
    if (numLow == 0) {	// set current_move to null move
        current_move = NO_MOVE;
        hold_down_state = 0;
    } else if (current_move == NO_MOVE && numLow == 1) { //interpret new move!
        int low_light = getWhichOneLow();
        current_move = convert_light_to_move_type(low_light);
        hold_down_state = 0;
     } else if (current_move == NO_MOVE && numLow > 1) {       //indicate confusion (more than 1 move at a time)
        current_move = UNDEF_MOVE;
        hold_down_state = 0;
     }
}

/* Counts the number of photo resistors that are LOW */
int numLowReadings() {
    int count = 0;
    int i;
    for (i = 0; i < N; i++) {
        if (digital_readings[i] < 0) {
            count++;	// we found a dark one!
        }
    }
    return count;
}

/* Counts the number of photo resistors that are HIGH */
int numHighReadings() {
    int count = 0;
    int i;
    for (i = 0; i < N; i++) {
        if (digital_readings[i] > 0) {
            count++;	// we found a light one!
        }
    }
    return count;
}

/* Assumes only 1 reading is low, and returns the int corresponding to that resistor */
int getWhichOneLow() {
    int i;
    for (i = 0; i < N; i++) {
        if (digital_readings[i] < 0)
            return i;
    }
    return -1;	//error
}

/* Maps a single dark resistor to the type of move it indicates */
int convert_light_to_move_type(int val) {
    if (val == LEFT) {
        return RIGHT_MOVE;
    } else if (val == RIGHT) {
        return LEFT_MOVE;
    } else if (val == TOP) {
        return DOWN_MOVE;
    } else if (val == BOTTOM) {
        return ROTATE_MOVE;
    } else {
        return NO_MOVE;	//error
    }
}

/* Sends the current_move over the serial port and updates the LCD display */
void send_command(int val) {
    LCD_ClearDisplay();
    char buff[50];
    sprintf(buff, "%s, %d times", getNameOfMove(val), move_counter);
    LCD_PrintString(buff);
    UART_WriteTxData(val);
}

/* Maps hex values of moves to English names */
char* getNameOfMove(int val) {
    if (val == 0) {
        return "no move";
    } else if (val == 1) {
        return "undefined move";
    } else if (val == 97) {
        return "Left";
    } else if (val == 100) {
        return "Right";
    } else if (val == 115) {
        return "Down";
    } else if (val == 119) {
        return "Rotate";
    } else {
        return "error";
    }
}