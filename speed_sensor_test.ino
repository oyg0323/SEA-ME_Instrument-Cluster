const uint8_t sensorPin = 3;
const unsigned int slitsPerRev = 20;
const float wheelCircumference = 0.2073;  // 바퀴 둘레(m): π×0.026m

volatile unsigned long pulseCount = 0;
unsigned long lastPrintTime = 0;
const unsigned long printInterval = 500;

void pulseISR() {
  pulseCount++;
}

void setup() {
  Serial.begin(9600);
  pinMode(sensorPin, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(sensorPin), pulseISR, RISING);
  lastPrintTime = millis();
}

void loop() {
  unsigned long now = millis();

  // 0.5초마다 속도 출력
  if (now - lastPrintTime >= printInterval) {
    noInterrupts();
    unsigned long pulses = pulseCount;
    pulseCount = 0;
    interrupts();
    float freq = pulses / (printInterval / 1000.0);
    float rps  = freq / slitsPerRev;
    float speed = rps * wheelCircumference;
    Serial.print("  Speed: ");
    Serial.print(speed*100, 3);
    Serial.println(" cm/s");
    lastPrintTime = now;
  }
}
