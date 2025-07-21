import threading, time, glob
from flask import Flask, Response
import cv2
from piracer.vehicles import PiRacerPro, PiRacerStandard
from evdev import InputDevice, ecodes, list_devices

app = Flask(__name__)
cap = cv2.VideoCapture(0)

def find_gamepad():
    # /dev/input/event* 중에서 ‘Microsoft X-Box 360 pad’ 이름을 가진 디바이스를 리턴
    for path in list_devices():
        dev = InputDevice(path)
        if 'Microsoft X-Box 360 pad' in dev.name:
            print(f"Using gamepad event device: {path}")
            return dev
    raise RuntimeError("XBox 360 pad 이벤트 디바이스를 찾을 수 없습니다.")

def gen_frames():
    while True:
        success, frame = cap.read()
        if not success: continue
        ret, buf = cv2.imencode('.jpg', frame)
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' +
               buf.tobytes() +
               b'\r\n')

@app.route('/video_feed')
def video_feed():
    return Response(gen_frames(),
                    mimetype='multipart/x-mixed-replace; boundary=frame')

def rc_control_loop(stop_event):
    # 1) 올바른 /dev/input/eventX 디바이스 찾기
    dev = find_gamepad()

    # 2) PiRacer 초기화
    try:
        piracer = PiRacerPro()
    except ValueError:
        piracer = PiRacerStandard()

    throttle = 0.0
    steering = 0.0
    print("Starting remote control loop (evdev).")

    # 3) 이벤트 루프
    for event in dev.read_loop():
        if stop_event.is_set():
            break

        if event.type == ecodes.EV_KEY:
            # A (num 0) → BTN_SOUTH, Y (num 3) → BTN_NORTH
            if event.code == ecodes.BTN_SOUTH:
                throttle = 0.5 if event.value == 1 else 0.0
            elif event.code == ecodes.BTN_EAST:
                throttle = -0.5 if event.value == 1 else 0.0

        elif event.type == ecodes.EV_ABS:
            # 좌측 스틱 X축: ABS_X, 값 -32767~32767 → -1.0~+1.0
            if event.code == ecodes.ABS_X:
                steering = -event.value / 32767.0

        piracer.set_throttle_percent(throttle)
        piracer.set_steering_percent(steering)
        time.sleep(0.01)

    # 종료 시 정지
    piracer.set_throttle_percent(0.0)
    piracer.set_steering_percent(0.0)
    print("RC control loop stopped.")

if __name__ == '__main__':
    stop_event = threading.Event()
    t = threading.Thread(target=rc_control_loop,
                         args=(stop_event,),
                         daemon=True)
    t.start()
    app.run(host='0.0.0.0', port=5000, threaded=True)
