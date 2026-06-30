cmake_minimum_required(VERSION 3.25)

project(ossia_remote
  VERSION 1.0
  DESCRIPTION "ossia score remote control"
  LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

# Building against the static ossia SDK: point CMake at its bundled static Qt6
# and the sysroot deps (zlib / freetype / harfbuzz), like ossia/score does.
if(OSSIA_SDK)
  list(PREPEND CMAKE_PREFIX_PATH
    "${OSSIA_SDK}/qt6-static"
    "${OSSIA_SDK}/sysroot")
endif()

find_package(Qt6 6.11 REQUIRED COMPONENTS Quick Gui Qml WebSockets)

qt_standard_project_setup(REQUIRES 6.11)

qt_add_executable(ossia_remote
  main.cpp
  qml.qrc
)

target_link_libraries(ossia_remote PRIVATE
  Qt6::Quick
  Qt6::Gui
  Qt6::Qml
  Qt6::WebSockets
)

# Also import the offscreen platform plugin so the binary can run headless for
# CI smoke tests. No-op for shared builds; for static builds (ossia SDK) it is
# linked in alongside the auto-imported native platform plugin.
qt_import_plugins(ossia_remote INCLUDE Qt6::QOffscreenIntegrationPlugin)

# Desktop install rules (Android/WASM use Qt's own deployment integration).
include(GNUInstallDirs)
install(TARGETS ossia_remote
  BUNDLE  DESTINATION .
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
