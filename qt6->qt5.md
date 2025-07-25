
## 📁 1. CMakeLists.txt 수정

```cmake
cmake_minimum_required(VERSION 3.14)

project(Practice LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt5 REQUIRED COMPONENTS Quick Qml QuickControls2)

# 소스 및 리소스 파일 지정
set(SRC
    main.cpp
    timeprovider.cpp
)

qt5_add_resources(QRC_SRCS resources.qrc)

# 실행 파일 생성
add_executable(${PROJECT_NAME}
    ${SRC}
    ${QRC_SRCS}
)

# Qt 라이브러리 연결
target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt5::Quick
    Qt5::Qml
    Qt5::QuickControls2
)

# 선택적 설치 경로 설정
include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
````

---

## 🧠 2. main.cpp 변경

**Before:**

```cpp
const QUrl url(QStringLiteral("qrc:/qt/qml/Practice/Main.qml"));
```

**After:**

```cpp
const QUrl url(QStringLiteral("qrc:/Main.qml"));
```

---

## 🎨 3. resources.qrc 구성

```xml
<RCC>
    <qresource prefix="/">
        <file>Main.qml</file>
        <file>IconButton.qml</file>
        <file>Neon.qml</file>
        <file>Car.qml</file>
        <file>Cluster_Circle.qml</file>
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


