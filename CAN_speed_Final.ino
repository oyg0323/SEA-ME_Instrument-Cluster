#include <SPI.h>
#include <mcp2515.h>

const uint8_t sensorPin = 3;
const unsigned int slitsPerRev = 20;
const float wheelCircumference = 0.2073;  // m
volatile unsigned long pulseCount = 0;
unsigned long lastPrintTime = 0;
const unsigned long printInterval = 500;  // ms

struct can_frame canMsg;
MCP2515 mcp2515(9);  // CS pin (e.g., D9)

void pulseISR() {
  
  pulseCount++;
}

void setup() {
  Serial.begin(9600);
  pinMode(sensorPin, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(sensorPin), pulseISR, RISING);

  lastPrintTime = millis();

  // MCP2515 초기화
  SPI.begin();
  mcp2515.reset();
  if (mcp2515.setBitrate(CAN_500KBPS, MCP_16MHZ) != MCP2515::ERROR_OK) {
    Serial.println("Failed to set bitrate!");
    while (1);
  }
  if (mcp2515.setNormalMode() != MCP2515::ERROR_OK) {
    Serial.println("Failed to enter Normal Mode!");
    while (1);
  }

  Serial.println("MCP2515 Initialized.");
}

void loop() {
  unsigned long now = millis();

  if (now - lastPrintTime >= printInterval) {
    noInterrupts();
    unsigned long pulses = pulseCount;
    pulseCount = 0;
    interrupts();

    float freq = pulses / (printInterval / 1000.0);
    float rps  = freq / slitsPerRev;
    float speed = rps * wheelCircumference;  // m/s
    float speed_cm_s = speed * 100.0;        // cm/s

    // Serial 출력
    Serial.print("Speed: ");
    Serial.print(speed_cm_s, 3);
    Serial.println(" cm/s");

    // CAN 메시지 작성
    canMsg.can_id  = 0x631;
    canMsg.can_dlc = 8;

    uint16_t speedData = (uint16_t)(speed_cm_s * 100);  // 예: 123.45cm/s → 12345
    canMsg.data[0] = (speedData >> 8) & 0xFF;
    canMsg.data[1] = speedData & 0xFF;
    canMsg.data[2] = 0x00;
    canMsg.data[3] = 0x00;
    canMsg.data[4] = 0x00;
    canMsg.data[5] = 0x00;
    canMsg.data[6] = 0x00;
    canMsg.data[7] = 0x00;

    mcp2515.sendMessage(&canMsg);

    Serial.print("Sent CAN message: ID=0x");
    Serial.print(canMsg.can_id, HEX);
    Serial.print(" Data: ");
    for (int i = 0; i < canMsg.can_dlc; i++) {
      Serial.print("0x");
      if (canMsg.data[i] < 0x10) Serial.print("0");
      Serial.print(canMsg.data[i], HEX);
      Serial.print(" ");
    }
    Serial.println();

    lastPrintTime = now;
  }
}

