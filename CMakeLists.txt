cmake_minimum_required(VERSION 3.15)
project(aws_s3_client)

configure_file(CMakeLists.txt.in aws_sdk_cpp-download/CMakeLists.txt)
execute_process(COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
        RESULT_VARIABLE result
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/aws_sdk_cpp-download )
if(result)
    message(FATAL_ERROR "CMake step for aws_sdk_cpp failed: ${result}")
endif()
execute_process(COMMAND ${CMAKE_COMMAND} --build .
        RESULT_VARIABLE result
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/aws_sdk_cpp-download )
if(result)
    message(FATAL_ERROR "Build step for aws_sdk_cpp failed: ${result}")
endif()

#add_subdirectory(${CMAKE_CURRENT_BINARY_DIR}/aws_sdk_cpp-src
#        ${CMAKE_CURRENT_BINARY_DIR}/aws_sdk_cpp-build
#        EXCLUDE_FROM_ALL)
