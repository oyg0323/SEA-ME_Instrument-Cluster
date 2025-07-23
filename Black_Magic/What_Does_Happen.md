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

**End-to-End Signal & Control Flow:**

```
Controller ADC & RF → USB HID → evdev → Python normalization → PiRacer API → I²C → PCA9685 PWM → Servo driver → Wheel linkage
```

1. **ADC Sampling & RF Transmission**

   * Controller’s MCU reads left-stick X-axis via a 12-bit ADC (0–3.3 V → –32767…+32767).
   * Packs axis data and button states into an HID report, appends CRC, and transmits via 2.4 GHz RF (nRF24L01–class), with ARQ/FEC.

2. **USB HID Reception & Kernel Parsing**

   * USB dongle decodes RF, verifies CRC, and exposes itself as a USB HID gamepad.
   * Linux’s `usbcore` + `hid-generic` bind the device; `usbhid` fetches reports over an Interrupt-IN endpoint (\~8 ms polling).

3. **evdev Event Generation**

   * HID core translates reports into `struct input_event` entries:

     * Type: `EV_ABS`, Code: `ABS_X`, Value: raw axis.
   * Events queued under `/dev/input/eventN` for user-space access.

4. **User-Space Normalization**

   ```python
   if event.code == ecodes.ABS_X:
       steering = -event.value / 32767.0  # → range [–1.0, +1.0]
   ```

   * Negative sign aligns positive values with right-turn.

5. **PiRacer API Call**

   * `piracer.set_steering_percent(steering)` selects a PWM channel and duty cycle:

     * Maps –1.0→1.0 ms, 0→1.5 ms pulse width at 50 Hz.

6. **I²C-Controlled PWM Generation**

   * Raspberry Pi writes PWM registers on the PCA9685 over I²C (`/dev/i2c-1` at 1 kHz).
   * PCA9685 outputs buffered, level-shifted PWM signals to the servo connector.

7. **Servo Actuation & Mechanical Linkage**

   * Pulse width controls the micro-servo horn (e.g., MG90S) to rotate (±90°).
   * Link rods transmit servo motion to front wheel knuckles, steering the wheels.

### I²C Bus Details

* **Bus Type:** I²C (Inter-Integrated Circuit), two-wire serial (SDA, SCL).
* **Device Node:** `/dev/i2c-1` on Raspberry Pi (pin header: GPIO2=SDA, GPIO3=SCL).
* **Speed:** Standard mode at 100 kHz or Fast mode at 400 kHz (PCA9685 supports up to 1 MHz).
* **Protocol:** Master (RPi) initiates transfer by sending device address, register address, then data to configure PWM frequency and duty cycles.

### PWM Signal Details

* **PWM (Pulse-Width Modulation):** Controls average voltage by switching between on/off states.
* **Frequency:** 50 Hz for servos, 1–2 kHz for DC motor speed control.
* **Duty Cycle:** Percentage of ON time per period (e.g., 7.5% at 50 Hz ≈ 1.5 ms pulse width for neutral servo position).
* **Mapping:** `steering` or `throttle` values map linearly to pulse widths (e.g., 1.0 ms–2.0 ms for steering servo).

**Latency Budget:** RF (\~1 ms) + USB poll (\~8 ms) + kernel & evdev (<1 ms) + Python (<1 ms) + I²C & PWM (<1 ms) = **<12 ms**
