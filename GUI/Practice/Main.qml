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
        z:1
    }

    Item {
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            color: "transparent"

            Text {
                text: timeProvider.currentDateTime || ""  // ⏰ 여기에서 연결!
                font.pixelSize: 20
                color: "#7C9392"
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 70  // 원하는 만큼 여백 조절
            }
        }
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

    Neon{
        id: neonSign
        anchors.centerIn: parent
    }
    /*
    StackView {
        id: stackView
        anchors.fill: parent
        z: 10
    }
    */

    Row {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 100
            z:1
            IconButton { iconSource: "qrc:/images/nav.svg"; scale: 0.6}
            IconButton { iconSource: "qrc:/images/music.svg"; scale: 0.6}
            IconButton { iconSource: "qrc:/images/time.svg"; scale: 0.6}
            IconButton { iconSource: "qrc:/images/settings.svg"; scale: 0.6}
            /*
            IconButton { iconSource: "qrc:/images/nav.svg"; onClicked: stackView.push(Qt.resolvedUrl("NavigationPage.qml"))}
            IconButton {
                iconSource: "qrc:/images/nav.svg"
                onClicked: stackView.push({
                    item: Qt.resolvedUrl("NavigationPage.qml"),
                    properties: { stackView: stackView }  // 👈 이렇게 넘겨줌
                })
            }
            IconButton { iconSource: "qrc:/images/music.svg"; onClicked: stackView.push(Qt.resolvedUrl("MusicPage.qml")) }
            IconButton { iconSource: "qrc:/images/time.svg"; onClicked: stackView.push(Qt.resolvedUrl("TimePage.qml")) }
            IconButton { iconSource: "qrc:/images/settings.svg"; onClicked: stackView.push(Qt.resolvedUrl("SettingsPage.qml")) }
            */
        }

}
