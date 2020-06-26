cmake_minimum_required(VERSION 3.10)
project(happly VERSION 1.0)

list(APPEND happly_PUBLIC_HEADERS
    happly.h
)

add_library(happly INTERFACE)
set_target_properties(happly PROPERTIES
    INTERFACE_PUBLIC_HEADER "${happly_PUBLIC_HEADERS}"
)
target_include_directories(happly INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:include/happly>
)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/install_helper.cmake)
install_target(happly)



