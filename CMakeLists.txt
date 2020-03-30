cmake_minimum_required(VERSION 3.15)
project(aws_s3_client)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()

set(CMAKE_CXX_STANDARD 17)

include(build/BuildDefaults.cmake)
