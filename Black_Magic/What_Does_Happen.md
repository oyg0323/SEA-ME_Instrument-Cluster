# How PiRacer Works with a Joystick (Xbox 360 Controller)

![alt text](image-1.png)

## 1. Press <- & -> (Streering)
1) Overview

    Joystick → Raspberry Pi (evdev input) → PiRacer → Front wheels steering

2) Detailed flow

    (1) Joystick movement (Left Stick - X axis)

    - The left stick sends an analog event (ABS_X) with values ranging from -32767 to 32767.

    - The center position is near 0.

    (2) Raspberry Pi reads the input

    - The evdev library detects the event:

            if event.code == ecodes.ABS_X:
                steering = -event.value / 32767.0
    

    - This converts the range to -1.0 to +1.0, where:

        -1.0 = full left,

        +1.0 = full right.

    (3) Send steering command to PiRacer

    - Using the API:
            
            piracer.set_steering_percent(steering)


    - The servo motor adjusts the front wheels accordingly.
    
    (4) Result

    - The PiRacer’s front wheels turn left or right, steering the car.


## 2. Press "A" Button (Moving Forward)
1) Overview

    A Button → Raspberry Pi (evdev input) → PiRacer → Rear motor drive → Car moves forward

2) Detailed flow

    (1) Pressing A button

    - The Xbox controller sends a digital event: BTN_SOUTH.

    - When pressed: event.value == 1
    - When released: event.value == 0.

    (2) Raspberry Pi updates throttle

    - The following code handles throttle:


            if event.code == ecodes.BTN_SOUTH:
                throttle = 0.5 if event.value == 1 else 0.0

    (3) Send throttle command to PiRacer

    - Using the API:

            piracer.set_throttle_percent(throttle)
    - 0.5 means 50% forward speed, 0.0 stops the motor.

    (4) Result

    - The rear DC motors power the car forward when A is pressed, and stop when it’s released.

