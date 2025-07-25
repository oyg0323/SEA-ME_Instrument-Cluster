import QtQuick 2.15

Item {
    id: root
    width: 1000; height: 400
    property real value: 0

    // 속도 변경 시 바늘 회전
    Connections {
        target: speedController
        function onSpeedChanged() {
            needleRotation.angle = (speedController.speed * 1.5) - 60
        }
    }

    // 배터리 레벨 변경 시 바늘 회전
    Connections {
        target: batterylevel
        function onLevelChanged() {
            console.log("Battery changed to:", batterylevel.level)
            //needleRotation_battery.angle = (batterylevel.level * -1.16) - 32
            needleRotation_battery.angle = (batterylevel.level * 3.8) - 90
        }
    }

    // 배경 프레임
    Image {
        id: speedGauge
        source: "qrc:/images/Ellipse1.svg"
        x: -50; y: 0
        Text {
            id: speedText
            text: speedController.speed + " cm/s"
            anchors.top: parent.bottom;  anchors.topMargin: -100
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 30; color: "#7C9392"
        }

    }
    // 배경 추가
    Item {
        id: innerCircle

        /** 외곽 원의 지름 */
        property real diameter: 330

        /** 선 두께 */
        property real strokeWidth: 4

        /** 선 색상 */
        property color strokeColor: "#619177"

        width: diameter
        height: diameter
        anchors.centerIn: speedGauge

        // 투명한 배경 + radius 로 원 테두리만
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.width: innerCircle.strokeWidth
            border.color: innerCircle.strokeColor
            // radius = 폭의 절반 -> 완전한 원
            radius: innerCircle.diameter / 2
        }
    }

    // 배경 프레임 2
    Image {
        id: batteryGauge
        source: "qrc:/images/Ellipse1.svg"
        x: 650; y: 0

        Text {
            id: batteryText
            text: "Battery: " + batterylevel.level + "%"
            anchors.top: parent.bottom; anchors.topMargin: -100
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 30; color: "#7C9392"
        }

    }
    // 배경 추가
    Item {
        id: innerCircle2

        // 외곽 원의 지름
        property real diameter: 330

        // 선 두께
        property real strokeWidth: 4

        //선 색상
        property color strokeColor: "#619177"

        width: diameter
        height: diameter
        anchors.centerIn: batteryGauge

        // 투명한 배경 + radius 로 원 테두리만
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.width: innerCircle2.strokeWidth
            border.color: innerCircle2.strokeColor
            // radius = 폭의 절반 -> 완전한 원
            radius: innerCircle2.diameter / 2
        }
    }
    // 속도 바늘
    Image {
        id: needle
        x: 37; y: 200
        //x: 64; y: 190       //바늘 위치(항상 화면 내에서 왼쪽 위 모서리를 기준)
        antialiasing: true  //이미지 렌더링 시 경계선을 부드럽게 처리(계단 현상 최소화)
        source: "qrc:/images/needle.png"
        transform: Rotation {
            id: needleRotation
            origin.x: 115; origin.y: 5      //피벗 좌표(회전 중심)  x + origin.x, y + origin.y
            //angle: -28
            angle: -70
            Behavior on angle {
                SequentialAnimation {
                    SpringAnimation { spring: 1.4; damping: 0.5 }
                    NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
                }
            }
        }
    }

    // 배터리 바늘

    Image {
        id: needle_battery
        x: 735; y: 200
        antialiasing: true
        source: "qrc:/images/needle.png"
        transform: Rotation {
            id: needleRotation_battery
            origin.x: 115; origin.y: 5
            angle: -70
            Behavior on angle {
                SequentialAnimation {
                    SpringAnimation { spring: 1.4; damping: 0.5 }
                    NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
                }
            }
        }
    }

    //깜빡이 추가
    Image{
        id:right
        x: 650; y: 30
        source:"qrc:/images/right.svg"
        scale: 2
    }
    Image{
        id:left
        x: 320; y: 30
        source:"qrc:/images/left.svg"
        scale: 2
    }
    Image{
        id:mid
        x: 445; y: -10
        source:"qrc:/images/red.svg"
        scale: 0.45
    }

}
