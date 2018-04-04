# Nanofan Controller

Purpose: Control a fan using MOSFET and PWM with interrupts on an Arduino Nano.

There are countless tutorials out there on how to control a fan using PWM on an Arduino, some good and some bad. I wanted to explore how to do it with small, optimized code that ran as efficiently as possible. While this comes close at 1.4KB, I think it could be improved upon.

This design does not use a potentiometer to set fan speed. Rather, it uses a single arcade button that cycles through preset fan speeds then shuts off. And I wanted to do it through interrupts for the fastest possible response time.

Three LEDs are used to represent the different fan speeds. Green for slow, yellow for medium, and red for full speed. As speed increases, the LEDs graduate up until all 3 are lit at full speed.

### Motivation

While it may seem simplistic, I wanted to tackle this project from start to finish, including documentation and releasing on GitHub. Hopefully someone out there will learn from it.

### License

All source code, models, CAD files, etc., for this project are released under the MIT License.

### Bill of Materials

For this project, I used:

* (1x) Arduino Uno
* (1x) LM7805 Voltage Regulator
* (1x) 30N06LE N-channel MOSFET*
* (1x) 30mm Arcade Button
* (1x) 5mm Green LED
* (1x) 5mm Yellow LED
* (1x) Red LED
* (1x) 120mm 12V fan

The 30N06LE MOSFET is definitely overkill for this project, as it has a maximum rating of 60V. Any comparable N-channel MOSFET with a voltage rating greater than 12V and current output of at least 1A will work.

Included in this repository also are the STL files for the fan case for 3D printing, as well as the OpenSCAD source for modification. 

### Compatibility

The code, as is, will work with an Arduino Nano, Uno, or even a barebones ATMega328P. With some understanding of the code, it could easily be ported to work with other microcontrollers in the Arduino family. 

### Models

Included in the repository are the STL files for a case I designed and 3D printed. It's a snap fit design so you can open it back up more easily and access the hardware. You can print it yourself also or give a go at the OpenSCAD source file to modify it.

The lid is recessed to hold the fan on top and will accommodate a 120mm fan with grilles. I used [this model](https://www.thingiverse.com/thing:263573) for my fan grilles. 