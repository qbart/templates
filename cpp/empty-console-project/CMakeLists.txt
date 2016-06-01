cmake_minimum_required(VERSION 3.4.3)

project(MyProject)

set(VERSION_MAJOR 0)
set(VERSION_MINOR 0)
set(VERSION_PATCH 1)
set(VERSION "\"${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}\"")

configure_file (
  "${PROJECT_SOURCE_DIR}/src/Config.h.in"
  "${PROJECT_BINARY_DIR}/Config.h"
)
include_directories("${PROJECT_BINARY_DIR}")

add_executable(MyProject src/main.cpp)

