#include <SPI.h>
#include <mcp2515.h>

struct can_frame canMsg;
MCP2515 mcp2515(9);  // CS 핀 (보통 D10)

void setup() {
  Serial.begin(9600);
  while (!Serial);

  Serial.println("Initializing MCP2515...");

  SPI.begin();

  // MCP2515 리셋
  mcp2515.reset();

  // 속도 설정: 500kbps, 오실레이터 16MHz 기준
  if (mcp2515.setBitrate(CAN_500KBPS, MCP_16MHZ) != MCP2515::ERROR_OK) {
    Serial.println("Failed to set bitrate!");
    while (1);
  }

  // 노멀 모드 설정
  if (mcp2515.setNormalMode() != MCP2515::ERROR_OK) {
    Serial.println("Failed to enter Normal Mode!");
    while (1);
  }

  Serial.println("MCP2515 Initialized successfully.");
}

void loop() {
  canMsg.can_id  = 0x631;  // 11비트 표준 ID
  canMsg.can_dlc = 8;      // 데이터 길이

  canMsg.data[0] = 0x40;
  canMsg.data[1] = 0x05;
  canMsg.data[2] = 0x30;
  canMsg.data[3] = 0xFF;
  canMsg.data[4] = 0x00;
  canMsg.data[5] = 0x40;
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

  delay(1000);
}
