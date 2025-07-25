import QtQuick 2.15

Item {
    id: root
    width: 1280
    height: 400
    // 오른쪽에 90도 회전해서 붙이기
    Image {
        id: side_right
        source: "qrc:/images/Vector 70.svg"
        anchors.right: parent.right
        anchors.rightMargin: -215
        anchors.verticalCenter: parent.verticalCenter
        antialiasing: true
        // SVG의 크기 조절
        width: 450; height: 20

        transform: Rotation {
            origin.x: side_right.width  / 2
            origin.y: side_right.height / 2
            angle: 90
        }
    }

    // 왼쪽에 90도 회전해서 붙이기
    Image {
        id: side_left
        source: "qrc:/images/Vector 70.svg"
        anchors.left: parent.left
        anchors.leftMargin: -215
        anchors.verticalCenter: parent.verticalCenter
        antialiasing: true
        // SVG의 크기 조절
        width: 450; height: 20

        transform: Rotation {
            origin.x: side_left.width  / 2
            origin.y: side_left.height / 2
            angle: 270
        }
    }

    // 위쪽
    Image {
        id: top_side
        source: "qrc:/images/Vector 70.svg"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenterOffset: -190
        antialiasing: true
        // SVG의 크기 조절
        width: 1500; height: 20
    }

    // 아래쪽
    Image {
        id: bottom_side
        source: "qrc:/images/Vector 70.svg"
        //anchors.verticalCenter: parent.verticalCenter
        anchors.bottom: parent.bottom
        //anchors.bottomMargin: 100
        //anchors.verticalCenterOffset: 190
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 1050
        antialiasing: true
        // SVG의 크기 조절
        width: 1500; height: 20

        transform: Rotation {
            origin.x: side_left.width  / 2
            origin.y: side_left.height / 2
            angle: 180
        }
    }
}
