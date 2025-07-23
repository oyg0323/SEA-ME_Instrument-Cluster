const int PIN_OUT = 8;  // 테스트 신호 출력 핀
const int PIN_IN = 9;   // 입력 감지 핀

void setup() {
  pinMode(PIN_OUT, OUTPUT);
  pinMode(PIN_IN, INPUT_PULLUP);  // 내부 풀업 저항 활성화
  Serial.begin(9600);
}

void loop() {
  digitalWrite(PIN_OUT, LOW);  // 기준 전압 LOW
  delay(10);                   // 안정화 대기
  int state = digitalRead(PIN_IN);  // 핀 상태 읽기

  if (state == LOW) {
    Serial.println("도통됨 (Connected)");
  } else {
    Serial.println("도통되지 않음 (Open)");
  }

  delay(1000);  // 1초 간격으로 반복
}

