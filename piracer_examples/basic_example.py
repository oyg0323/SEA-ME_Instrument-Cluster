import time
from piracer.vehicles import PiRacerPro, PiRacerStandard

if __name__ == '__main__':
    try:
        piracer = PiRacerPro()
        print("Using PiRacerPro (with INA219 battery monitor)")
    except ValueError as e:
        print(f"PiRacerPro init failed ({e}), falling back to Standard mode")
        piracer = PiRacerStandard()

    # Forward
    piracer.set_throttle_percent(0.2)
    time.sleep(2.0)

    # Brake
    piracer.set_throttle_percent(-1.0)
    time.sleep(0.5)
    piracer.set_throttle_percent(0.0)
    time.sleep(0.1)

    # Backward
    piracer.set_throttle_percent(-0.3)
    time.sleep(2.0)

    # Stop
    piracer.set_throttle_percent(0.0)

    # Steering left
    piracer.set_steering_percent(1.0)
    time.sleep(1.0)

    # Steering right
    piracer.set_steering_percent(-1.0)
    time.sleep(1.0)

    # Steering neutral
    piracer.set_steering_percent(0.0)

