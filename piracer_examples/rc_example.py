from piracer.vehicles import PiRacerPro, PiRacerStandard
from piracer.gamepads import ShanWanGamepad
import time

if __name__ == '__main__':
    # 게임패드 동글이 USB에 꽂혀 있어야 합니다
    gamepad = ShanWanGamepad()

    # Pro 모드로 시도, 실패 시 Standard 모드로 전환
    try:
        piracer = PiRacerPro()
        print("Using PiRacerPro")
    except ValueError as e:
        print(f"PiRacerPro init failed ({e}), falling back to Standard")
        piracer = PiRacerStandard()

    print("Starting remote control loop. Press Ctrl+C to exit.")

    while True:
        data = gamepad.read_data()
        # 우측 스틱 세로축으로 스로틀, 좌측 스틱 가로축으로 조향
        throttle = data.analog_stick_right.y * 0.5
        steering = -data.analog_stick_left.x

        print(f"throttle={throttle:.2f}, steering={steering:.2f}")

        piracer.set_throttle_percent(throttle)
        piracer.set_steering_percent(steering)

        time.sleep(0.02)  # 50Hz 루프
