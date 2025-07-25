import QtQuick 2.15

// 시간 페이지
Item {
    anchors.fill: parent                          // 전체 크기 채움

    Rectangle {
        anchors.fill: parent                      // 내부 배경 사각형
        color: "#222"                             // 어두운 회색 배경

        Text {
            text: "Time Screen"             // 표시할 텍스트
            color: "white"                        // 흰색 텍스트
            anchors.centerIn: parent              // 가운데 정렬
        }
    }
}
