set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH}"
        "${CMAKE_CURRENT_BINARY_DIR}/aws_sdk_cpp-install/lib/aws-checksums/cmake")

string(REPLACE ";" "|" CHAME_PREFIX_PATH_ALT_SEP "${CMAKE_PREFIX_PATH}")

include(FetchContent)
FetchContent_Declare(
        aws_sdk_cpp
        GIT_REPOSITORY https://github.com/aws/aws-sdk-cpp.git
        GIT_TAG 1.7.306
        GIT_SHALLOW 1
        SOURCE_DIR "${CMAKE_CURRENT_BINARY_DIR}/aws_sdk_cpp-src"
        BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/aws_sdk_cpp-build"
        LIST_SEPARATOR |
        CMAKE_CACHE_ARGS
        -DBUILD_ONLY:STRING="s3|email"
        -DBUILD_SHARED_LIBS:BOOL=OFF
        -DMINIMIZE_SIZE:BOOL=ON
        -DENABLE_TESTING:BOOL=OFF
        -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
        -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/aws_sdk_cpp-install
        -DCMAKE_PREFIX_PATH:STRING="${CHAME_PREFIX_PATH_ALT_SEP}"
)

FetchContent_GetProperties(aws_sdk_cpp)

if(NOT aws_sdk_cpp_POPULATED)
    FetchContent_Populate(aws_sdk_cpp)
    add_subdirectory(${aws_sdk_cpp_SOURCE_DIR} ${aws_sdk_cpp_BINARY_DIR} EXCLUDE_FROM_ALL)
endif()
