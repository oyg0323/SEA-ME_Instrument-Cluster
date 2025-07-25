import QtQuick 2.15

Item {
    id: root
    width: 500; height: 500
    property real value: 0

    //차
    Image {
        id: racecar
        source: "qrc:/images/Car.png"
        anchors.centerIn: parent.center
        z: 1
        transform: Rotation {
            origin.x: racecar.width  / 2
            origin.y: racecar.height / 2
            angle: 270
        }
    }

    Image {
        id: mesh
        anchors.centerIn: racecar
        source: "qrc:/images/mesh_3.png"
        scale: 5
        z: 0
    }
}
