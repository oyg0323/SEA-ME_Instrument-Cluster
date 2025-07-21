#!/usr/bin/env python3
import threading
import time
import os, sys
from flask import Flask, Response
import cv2

# ------------------------------
# Flask 앱 설정
# ------------------------------
app = Flask(__name__)
cap = cv2.VideoCapture(0)  # 카메라 인덱스 조정 가능

def gen_frames():
    while True:
        success, frame = cap.read()
        if not success:
            continue
        ret, buf = cv2.imencode('.jpg', frame)
        frame_bytes = buf.tobytes()
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame_bytes + b'\r\n')

@app.route('/video_feed')
def video_feed():
    return Response(gen_frames(),
                    mimetype='multipart/x-mixed-replace; boundary=frame')

# ------------------------------
# RC 제어 루프
# ------------------------------
from piracer.vehicles import PiRacerPro, PiRacerStandard
from piracer.gamepads import ShanWanGamepad

def rc_control_loop():
    # 게임패드 초기화
    gamepad = ShanWanGamepad()
    # Pro 모드 시도, 실패 시 Standard
    try:
        piracer = PiRacerPro()
        print("Using PiRacerPro")
    except ValueError as e:
        print(f"PiRacerPro init failed ({e}), falling back to Standard")
        piracer = PiRacerStandard()
    print("Starting remote control loop.")

    try:
        while True:
            data = gamepad.read_data()
            throttle = data.analog_stick_right.y * 0.5
            steering = -data.analog_stick_left.x
            piracer.set_throttle_percent(throttle)
            piracer.set_steering_percent(steering)
            time.sleep(0.02)
    except KeyboardInterrupt:
        piracer.set_throttle_percent(0.0)
        piracer.set_steering_percent(0.0)
        print("RC control loop stopped.")

# ------------------------------
# 메인 실행
# ------------------------------
if __name__ == '__main__':
    # 제어 스레드 시작
    rc_thread = threading.Thread(target=rc_control_loop, daemon=True)
    rc_thread.start()

    # Flask 웹 서버 실행
    app.run(host='0.0.0.0', port=5000, threaded=True)
