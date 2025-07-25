import QtQuick 2.15
import QtQuick.Controls 2.15

// 커스텀 아이콘 버튼 컴포넌트 정의
Item {
    property alias iconSource: icon.source  // 외부에서 아이콘 이미지 설정할 수 있도록 바인딩
    signal clicked()                        // 클릭 이벤트 시그널 선언

    width: 64; height: 64                   // 버튼의 크기 설정

    // 클릭 영역 정의
    MouseArea {
        anchors.fill: parent               // 전체 버튼 영역 클릭 가능
        onClicked: parent.clicked()        // 클릭 시 외부 시그널로 연결
    }

    // 아이콘 이미지 표시
    Image {
        id: icon
        anchors.centerIn: parent           // 가운데 정렬
        width: 48; height: 48              // 아이콘 크기
        source: ""                         // 외부에서 설정할 예정
    }
}

