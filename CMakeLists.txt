cmake_minimum_required(VERSION 3.15)

#
# Building in-tree is not allowed (we take care of your craziness).
#

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
    message(FATAL_ERROR "Prevented in-tree built. Please create a build directory outside of the source code and call cmake from there. Thank you.")
endif()

project(
        aws_s3_client
        LANGUAGES C CXX
)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()

set(CMAKE_CXX_STANDARD 17)

set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH}"
        "${CMAKE_CURRENT_BINARY_DIR}/aws_sdk_cpp-install/lib/aws-checksums/cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/aws_sdk_cpp-install/lib/aws-c-event-stream/cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/aws_sdk_cpp-install/lib/aws-c-common/cmake")
string(REPLACE ";" "|" CMAKE_PREFIX_PATH_ALT_SEP ${CMAKE_PREFIX_PATH})

configure_file(CMakeLists.txt.in aws_sdk_cpp-download/CMakeLists.txt)
execute_process(COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
        RESULT_VARIABLE result
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/aws_sdk_cpp-download)
if(result)
    message(FATAL_ERROR "CMake step for aws_sdk_cpp failed: ${result}")
endif()
execute_process(COMMAND ${CMAKE_COMMAND} --build .
        RESULT_VARIABLE result
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/aws_sdk_cpp-download)
if(result)
    message(FATAL_ERROR "Build step for aws_sdk_cpp failed: ${result}")
endif()

add_subdirectory(${CMAKE_CURRENT_BINARY_DIR}/aws_sdk_cpp-src
        ${CMAKE_CURRENT_BINARY_DIR}/aws_sdk_cpp-build
        EXCLUDE_FROM_ALL)

add_executable(main main.cpp)
target_include_directories(main PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/aws_sdk_cpp-install/include)
target_link_libraries(main PRIVATE aws-cpp-sdk-s3 aws-cpp-sdk-core)
