# How PiRacer Works with a Joystick (Xbox 360 Controller)

![alt text](image-1.png)

---

## Wireless Input Reception

Before any steering or throttle commands, the gamepad’s wireless signals must be received and converted into Linux input events:

1. **RF Transmission (Controller Side)**

   * MCU samples the joystick axes via ADC and packages axis/button data into a HID report with CRC.
   * A 2.4 GHz transceiver (e.g., Nordic nRF24L01-class) wirelessly sends the report, using ARQ/FEC for reliability.

2. **USB Dongle Reception**

   * The USB dongle decodes the RF packet, verifies CRC, and exposes itself as a USB HID Gamepad (Interrupt-IN endpoint, \~8 ms polling).

3. **Host USB Stack (Linux Kernel)**

   * The Pi’s `usbcore` enumerates the HID device and uses `hid-generic` + `usbhid` to fetch reports over interrupt transfers.

4. **evdev Exposure**

   * The HID core parses reports into `EV_ABS` (axes) and `EV_KEY` (buttons) events.
   * Events appear under `/dev/input/eventN`, ready for user-space.

*Total latency from physical stick movement to `/dev/input/eventN` <10 ms.*

---

## 1. Press ← & → (Steering)

**Overview:**

```
Joystick → evdev input → Python normalization → PiRacer API → Servo PWM → Front wheels turn
```

1. **Joystick movement (Left Stick - X axis)**

   * Generates an analog event (`ABS_X`) in the range -32767…+32767 (center ≈ 0).

2. **Raspberry Pi reads the input**

   ```python
   if event.code == ecodes.ABS_X:
       steering = -event.value / 32767.0
   ```

   * Normalizes value to -1.0…+1.0: -1.0 = full left, +1.0 = full right.

3. **Send steering command to PiRacer**

   ```python
   piracer.set_steering_percent(steering)
   ```

   * The Python API adjusts the PWM duty cycle on the servo channel to turn the wheels.

4. **Result**

   * The front wheels rotate left or right according to the joystick position.

---

## 2. Press "A" Button (Moving Forward)

**Overview:**

```
A button → evdev input → Python throttle update → PiRacer API → H-bridge PWM → Rear DC motors
```

1. **Pressing A button**

   * Controller emits a digital event `BTN_SOUTH` with `value = 1` on press, `0` on release.

2. **Raspberry Pi updates throttle**

   ```python
   if event.code == ecodes.BTN_SOUTH:
       throttle = 0.5 if event.value == 1 else 0.0
   ```

   * `0.5` = 50% forward speed, `0.0` = stop.

3. **Send throttle command to PiRacer**

   ```python
   piracer.set_throttle_percent(throttle)
   ```

   * The API sets the PWM duty cycle on the motor driver inputs.

4. **Result**

   * Rear DC motors receive PWM and drive the car forward when A is pressed, stopping on release.
