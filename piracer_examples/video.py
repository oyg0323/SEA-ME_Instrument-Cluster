import time
import os
import picamera

# 1) 저장할 경로: 현재 스크립트 위치 안에 recordvideo.h264
base_dir = os.path.dirname(os.path.abspath(__file__))
output_path = os.path.join(base_dir, 'recordvideo.h264')

# 2) PiCamera 인스턴스 생성 및 설정
with picamera.PiCamera() as camera:
    camera.resolution = (1920, 1080)
    camera.framerate = 30

    # 3) 녹화 시작
    camera.start_recording(output_path)
    print(f"Recording to {output_path} for 2 seconds...")

    time.sleep(10)
    # 4) 녹화 종료
    camera.stop_recording()
    print("Recording finished. File saved at:")
    print(f"  {output_path}")
