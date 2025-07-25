// Circle.qml
import QtQuick 2.12
import QtQuick.Shapes 1.12

Item {
    id: root

    /** 외곽 원의 지름 */
    property real diameter: 100

    /** 선 두께 */
    property real strokeWidth: 4

    /** 선 색상 */
    property color strokeColor: "#7C9392"

    width: diameter
    height: diameter

    // 투명한 배경 + radius 로 원 테두리만
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: root.strokeWidth
        border.color: root.strokeColor
        // radius = 폭의 절반 -> 완전한 원
        radius: root.diameter / 2
    }
}

