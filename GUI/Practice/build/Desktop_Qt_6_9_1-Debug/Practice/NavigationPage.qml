import QtQuick 2.15
import QtQuick.Controls 2.15

// 네비게이션 페이지
Item {
    anchors.fill: parent                          // 전체 크기 채움

    Rectangle {
        anchors.fill: parent                      // 내부 배경 사각형
        color: "#222"                             // 어두운 회색 배경

        MouseArea {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 20
            width: 48
            height: 48

            onClicked: {
                // 메인 StackView ID를 직접 찾아서 clear()
                const rootWindow = Qt.application.activeWindow
                if (rootWindow && rootWindow.stackView) {
                    rootWindow.stackView.clear()
                }
            }

            Image {
                source: "qrc:/images/back.svg"  // 뒤로가기 아이콘 이미지
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
            }
        }

        Text {
            text: "Navigation Screen"             // 표시할 텍스트
            color: "white"                        // 흰색 텍스트
            anchors.centerIn: parent              // 가운데 정렬
        }
    }
}
