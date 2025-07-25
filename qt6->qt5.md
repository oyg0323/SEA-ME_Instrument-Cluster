**CMakeLists.txt수정**


cmake_minimum_required(VERSION 3.14)
&nbsp;&nbsp;&nbsp;&nbsp;
project(Practice LANGUAGES CXX)



set(CMAKE_CXX_STANDARD 17)
&nbsp;&nbsp;&nbsp;&nbsp;
set(CMAKE_CXX_STANDARD_REQUIRED ON)
&nbsp;&nbsp;&nbsp;&nbsp;
set(CMAKE_AUTOMOC ON)
&nbsp;&nbsp;&nbsp;&nbsp;
set(CMAKE_AUTORCC ON)

&nbsp;&nbsp;&nbsp;&nbsp;
find_package(Qt5 REQUIRED COMPONENTS Quick Qml QuickControls2)
&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;

#소스,리소스 

set(SRC
    main.cpp
    timeprovider.cpp
)

qt5_add_resources(QRC_SRCS resources.qrc)

&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;
##실행파일
&nbsp;&nbsp;&nbsp;&nbsp;
add_executable(${PROJECT_NAME}
    ${SRC}
    ${QRC_SRCS}
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt5::Quick
    Qt5::Qml
    Qt5::QuickControls2
)

#선택설치
include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

**main.cpp**


// 기존
const QUrl url(QStringLiteral("qrc:/qt/qml/Practice/Main.qml"));
// 수정
const QUrl url(QStringLiteral("qrc:/Main.qml"));

**resoures.qrc 내의 <filie>"name.qml"</file> 등등  추가 **
<RCC>
    <qresource prefix="/">
        <file>Main.qml</file>
	<file>IconButton.qml</file>
	<file>Neon.qml</file>
	<file>Car.qml</file>
	<file>Cluster_Circle.qml</file>
        <file>Main.qml</file>
	<file>MusicPage.qml</file>
	<file>NavigationPage.qml</file>
        <file>Cluster.qml</file>
    </qresource>
    <qresource prefix="/images">
        <file>framefffinal.png</file>
        <file>needle.png</file>
        <file>needle_battery.png</file>
        <file>low_battery.png</file>
        <file>ring.svg</file>
        <file>Ellipse1.svg</file>
        <file>Vector 70.svg</file>
        <file>car_background.png</file>
        <file>Car.png</file>
        <file>mesh_1.png</file>
        <file>mesh_2.png</file>
        <file>mesh_3.png</file>
        <file>nav.svg</file>
        <file>settings.svg</file>
        <file>time.svg</file>
        <file>music.svg</file>
        <file>back.svg</file>
        <file>right.svg</file>
        <file>left.svg</file>
        <file>red.svg</file>
    </qresource>
</RCC>

