import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

ApplicationWindow {
    visible: true
    flags: Qt.FramelessWindowHint
    //visibility: Window.FullScreen
    width: 1280
    height: 400
    title: "Dial Application"
    color: "black"

    Cluster {
        id: dial
        anchors.centerIn: parent
        value: 0
    }

    // ← 경고 이미지는 모두 prefix "/images" 아래에 묶여 있으므로
    Image {
        id: low_battery1
        visible: batterylevel.level <= 10
        anchors.left: parent.left; anchors.leftMargin: 560
        anchors.top: parent.top;   anchors.topMargin: 30
        antialiasing: true
        source: "qrc:/images/low_battery.png"
        z:2
    }

    Text {
        text: "Low Battery WARNING!!"
        visible: batterylevel.level <= 10
        color: "red"; font.pixelSize: 20
        anchors.horizontalCenter: low_battery1.horizontalCenter
        anchors.top: low_battery1.bottom; anchors.topMargin: 10
        z:2
    }

    //from 3rd gen
    Image{
        id: backcar
        visible: true
        //anchors.centerIn: parent
        //anchors.horizontalCenterOffset: 100
        x: 420; y: 160
        source: "qrc:/images/car_background.png"
        z:1
    }


    //from gihoon
    /*
    Car{
        id: car
        visible:true
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -45
        width: 500; height: 500
        scale: 0.1
        z: 1
    }
    */


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
