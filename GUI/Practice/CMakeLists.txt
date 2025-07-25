cmake_minimum_required(VERSION 3.16)

project(Practice VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2)
qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appPractice
    main.cpp
    resources.qrc
)

qt_add_qml_module(appPractice
    URI Practice
    VERSION 1.0

    QML_FILES
        Cluster.qml
        Main.qml
        QML_FILES
        QML_FILES Car.qml
        QML_FILES Neon.qml
        QML_FILES IconButton.qml
        QML_FILES NavigationPage.qml
        QML_FILES MusicPage.qml
        QML_FILES TimePage.qml
        QML_FILES SettingPage.qml
        SOURCES timeprovider.h timeprovider.cpp
)

qt_add_resources(appPractice
    app_resources    # 임의 이름
    PREFIX "/"         # qrc:/ 경로의 루트로 매핑
    FILES
        resources.qrc    # 실제 존재하는 경로를 지정
)
# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.


target_link_libraries(appPractice
    PRIVATE Qt6::Quick Qt6::QuickControls2
)

include(GNUInstallDirs)
install(TARGETS appPractice
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
