# How PiRacer Works with a Joystick (Xbox 360 Controller)

![Joystick to PiRacer Pipeline](image-1.png)

---

## Wireless Input Reception (End-to-End)

This section covers how the controller’s analog-stick movements become Linux input events on the Raspberry Pi with minimal latency and high reliability.

1. **ADC Sampling & RF Packetization (Controller Side)**

   * The controller’s MCU reads the left-stick X-axis via a 12-bit ADC (voltage 0–3.3 V → digital range –32767…+32767).
   * Axis values and button states are packed into a HID-style report (32–64 bytes), with a CRC-16 appended for error detection.
   * A 2.4 GHz RF transceiver (e.g., Nordic nRF24L01-class SoC) transmits the packet on a chosen ISM-band channel.
   * ARQ (Automatic Repeat Request) and optional FEC ensure lost or corrupted packets are retransmitted.

2. **RF Reception & USB HID Emulation (USB Dongle)**

   * The USB dongle’s RF radio receives the packet, discards CRC-invalid frames, and extracts the HID report payload.
   * The dongle’s MCU enumerates as a USB Full-Speed (12 Mbps) HID device on the Pi.
   * Defines an Interrupt-IN endpoint (e.g., 8 bytes, polled every 8 ms) for sending reports to the host.

3. **USB Stack & HID Parsing (Host Kernel)**

   * Upon dongle insertion, `usbcore` reads descriptors, binds `hid-generic` and `usbhid` drivers.
   * The kernel schedules periodic interrupt transfers to fetch the latest HID reports from the dongle.

4. **evdev Event Generation**

   * The HID core maps report fields to input subsystem events:

     * Axes → `EV_ABS` events (e.g., `ABS_X`), raw value –32767…+32767
     * Buttons → `EV_KEY` events (e.g., `BTN_SOUTH`), value 0 or 1
   * Events are queued into `/dev/input/eventN` as `struct input_event` records.
   * Total latency: \~1 ms (RF) + \~8 ms (USB poll) + \~1 ms (kernel) = **<10 ms**.

---

## 1. Press ← & → (Steering)

**Signal & Control Pipeline:**

```
Controller ADC → RF → USB HID → evdev → Python normalization → PiRacer API → I²C → PCA9685 → PWM → Servo driver → Mechanical linkage → Front wheels
```

1. **evdev Input**

   * `/dev/input/eventN` emits:

     ```c
     struct input_event ev = { .type = EV_ABS, .code = ABS_X, .value = raw }; // raw ∈ [–32767,+32767]
     ```

2. **Python Normalization**

   ```python
   if event.code == ecodes.ABS_X:
       steering = -event.value / 32767.0  # normalized ∈ [–1.0,+1.0]
   ```

   * Inversion ensures positive value = right turn.

3. **PiRacer API Call**

   ```python
   piracer.set_steering_percent(steering)
   ```

   * Internally selects a PCA9685 PWM channel and computes pulse width:

     * **Pulse Width** (ms) = 1.0 ms + (steering + 1.0) × 0.5 ms
     * Range: 1.0 ms (–1.0) … 2.0 ms (+1.0) at 50 Hz.

4. **I²C Communication**

   * The Pi’s I²C master writes to the PCA9685 registers over `/dev/i2c-1`:

     * Bus pins: GPIO2 (SDA), GPIO3 (SCL)
     * Address: 0x40 (default)
     * Frequency: set via MODE1 register → \~50 Hz output.
     * PWM registers (LEDn\_ON, LEDn\_OFF) receive 12-bit counts (0–4095).
   * Each register write sequence:

     ```text
     [START][0x40<<1 + W][register][data]…[STOP]
     ```

5. **PCA9685 PWM Output**

   * Generates 16 channels of buffered, level-shifted PWM outputs.
   * Outputs a 50 Hz pulse train: ON count → OFF count mapping to desired pulse width.

6. **Servo Driver & Mechanics**

   * PWM drives a micro-servo (e.g., MG90S): 1.0 ms = –90°, 1.5 ms = 0°, 2.0 ms = +90°.
   * Servo horn moves the tie-rod, steering knuckle, and front wheel hubs.
   * Mechanical geometry (Ackermann linkages) translates horn rotation into precise wheel angle.

---

### I²C Bus Essentials

* **Protocol:** Master/slave, 7-bit addressing, clock-stretched bidirectional data.
* **Speeds:** Standard (100 kHz), Fast (400 kHz), Fast Plus (1 MHz).
* **Flow:** START → Address + R/W bit → ACK → Register pointer → Data bytes → STOP.
* **Error Handling:** NACK on invalid address/register; bus arbitration if multiple masters.

### PWM Fundamentals

* **Definition:** Modulate a digital signal’s duty cycle to simulate analog levels.

* **Frequency:** 50 Hz for hobby servos; DC motors often use >200 Hz to minimize torque ripple.

* **Duty Cycle Calculation:**

  $\text{Duty}\% = \frac{\text{PulseWidth(ms)}}{\text{Period(ms)}} \times 100\%$

* **Servo Mapping:** 1.0 ms (5%) → full left; 1.5 ms (7.5%) → center; 2.0 ms (10%) → full right.

**\~12 ms total round-trip latency** ensures responsive, real-time steering control.
