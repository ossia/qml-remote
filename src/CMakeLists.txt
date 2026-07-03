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

# Building against the static ossia SDK: point CMake exclusively at the SDK's
# bundled Qt6 + dependencies, and never fall back to Homebrew / system libs
# (which are the wrong architecture when cross-compiling x86_64 on Apple
# Silicon). Mirrors ossia/score. Non-existent dirs are simply ignored, so the
# same list covers the macOS layout (freetype/harfbuzz as top-level dirs) and
# the mingw/linux layout (deps under sysroot).
if(OSSIA_SDK)
  list(PREPEND CMAKE_PREFIX_PATH
    "${OSSIA_SDK}"
    "${OSSIA_SDK}/qt6-static"
    "${OSSIA_SDK}/zlib"
    "${OSSIA_SDK}/openssl"
    "${OSSIA_SDK}/freetype"
    "${OSSIA_SDK}/harfbuzz"
    "${OSSIA_SDK}/sysroot"
    "${OSSIA_SDK}/sysroot/lib"
    "${OSSIA_SDK}/sysroot/lib/cmake"
    "${OSSIA_SDK}/sysroot/lib/cmake/freetype"
    "${OSSIA_SDK}/sysroot/lib/cmake/harfbuzz"
    "${OSSIA_SDK}/qt6-static/lib64"
    "${OSSIA_SDK}/zlib/lib64"
    "${OSSIA_SDK}/freetype/lib64"
    "${OSSIA_SDK}/harfbuzz/lib64")

  # Never search Homebrew / other system prefixes for libraries or packages.
  set(_ossia_ignore "/opt/homebrew;/usr/local;/usr/X11R6;/usr/pkg;/sw;/opt/local")
  set(CMAKE_IGNORE_PATH "${_ossia_ignore}")
  set(CMAKE_SYSTEM_IGNORE_PATH "${_ossia_ignore}")
  set(CMAKE_IGNORE_PREFIX_PATH "${_ossia_ignore}")
  set(CMAKE_SYSTEM_IGNORE_PREFIX_PATH "${_ossia_ignore}")
  foreach(_xp "/opt/homebrew" "/usr/local" "/usr/X11R6" "/usr/pkg" "/opt" "/sw" "/opt/local")
    list(REMOVE_ITEM CMAKE_SYSTEM_PREFIX_PATH "${_xp}")
    list(REMOVE_ITEM CMAKE_PREFIX_PATH "${_xp}")
  endforeach()
endif()

find_package(Qt6 6.11 REQUIRED COMPONENTS Quick Gui Qml WebSockets)

qt_standard_project_setup(REQUIRES 6.11)

qt_add_executable(ossia_remote
  main.cpp
  qml.qrc
  fonts.qrc
)

target_link_libraries(ossia_remote PRIVATE
  Qt6::Quick
  Qt6::Gui
  Qt6::Qml
  Qt6::WebSockets
)

# The ossia SDK's llvm-mingw clang links its C++ runtime (libc++, libc++abi,
# libunwind, libwinpthread) as DLLs by default, so the produced .exe would only
# run with those DLLs alongside it. -static pulls in the static (.a) variants
# instead — all present in the SDK — yielding a single self-contained binary.
# The Qt in the SDK is already static, so every other dependency is .a too.
if(OSSIA_SDK AND WIN32)
  target_link_options(ossia_remote PRIVATE -static)
endif()

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
