/* 
 *  Arduino Nano Fan Controller
 *  Version: 1.0
 *  Author: Devin Watson
 *  Purpose: Control a fan using MOSFET and PWM with interrupts
 *  Uses a 3-speed toggle to control fan speed with a button
 * 
 * Note: This uses a lot of direct port register manipulation for speed and size. If you want to use
 * a different set of pins, be sure to consult the datasheet for the correct PORT and DDR registers!
 * 
 * PWM timer frequencies that can be set based on the clock divider:
 * 
 * 1: 31372.5 Hz
 * 2: 3921.57 Hz
 * 3: 980.392 Hz
 * 4: 490.196 Hz (default)
 * 5: 245.098 Hz
 * 6: 122.549 Hz
 * 7: 30.6373 Hz
 * 
 * The controller uses Timer1's  Timer/Counter Control Register (TCCR1B) which uses pin D10 (PB2) on the Nano
 * For the fan that I use, 31372.5 Hz produces the best results without any  whining at any speed from the 
 * fan motor. Your mileage may vary depending on the fan you use.
 * 
 * Bill of Materials:
 * 
 * 1x Arcade button, 30mm
 * 1x LM7805 Voltage Regulator
 * 1x 30N06LE N-channel MOSFET, or any comparable N-channel MOSFET with a voltage rating greater than 12V and at least 1A
 * 1x 120mm 12V PC fan
 * 3x LEDs (any color)
 * 3x 120 ohm resistors
 * 1x 12V 2A power supply
 */

#define FAN_GATE  10  // D10 (PB2), utilizing the phase-correct PWM by default on Timer1
#define BUTTON_PIN 2  // D2 (PD2), one of the only pins on the Nano that has an interrupt
#define LED_PIN 4   // Starting pin for the 3 status LEDs (D4-D6)

volatile unsigned int fanSpeed = 0;

void setup() {
  // Set the PWM frequency to 31372.5 Hz
  // See comments at the top for all frequency values
  // This is for Timer1 register, which is where pin D10 (PB2) resides 
  TCCR1B = (TCCR1B & 0xF8) | 1;
  
  // Set the MOSFET gate pin to output
  DDRB &= ( 1 << PORTB2 );

  // Set all of the LED pins as output in one go
  DDRD = 0b01110000;

  // Button (D2) needs its pullup resistor turned on
  PORTD |= (1 << PORTD2);

  // Turn off the fan
  PORTB &= ~(1 << PORTB2);

  // Make sure the LEDs are turned off
  PORTD &= ~(1 << PORTD4) & ~(1 << PORTD5) & ~(1 << PORTD6);
  
  // Set up the interrupt for D2, which uses INT0
  attachInterrupt( 0, button_isr, FALLING );
}

void loop() {
  /* Nothing to do here. All the work is in the ISR */
}

void button_isr() {
  static unsigned long debounceTime;
  static int i;
  
   if ( millis() - debounceTime >= 250 ) {
      debounceTime = millis();
      fanSpeed = (fanSpeed + 85 > 255) ? 0 : fanSpeed + 85;
      
      PORTD &= ~(1 << PORTD4) & ~(1 << PORTD5) & ~(1 << PORTD6);

      for ( i = 0; i < (fanSpeed / 85) + 4; i++ ) {
        PORTD |= (1 << i); // Fast set LED pin high
      }

      // Set the fan speed
      analogWrite( FAN_GATE, fanSpeed );
    }
  
}

