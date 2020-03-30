Confirm by changing [ ] to [x] below:
- [x] I've gone though [Developer Guide](https://docs.aws.amazon.com/sdk-for-cpp/v1/developer-guide/welcome.html) and [API reference](http://sdk.amazonaws.com/cpp/api/LATEST/index.html)
- [x] I've searched for [previous similar issues](https://github.com/aws/aws-sdk-cpp/issues) and didn't find any solution

**Platform/OS/Hardware/Device**
Linux fiorentinoing 4.15.0-91-generic #92-Ubuntu 18.04 x86_64 GNU/Linux

**Describe the question**
I would like to "import" the sdk dependency through ExternalProject or FetchContent. Here is the *template*
```
# CMakeLists.txt.in
project(aws_sdk_cpp-download NONE)

include(ExternalProject)
ExternalProject_Add(aws_sdk_cpp
        GIT_REPOSITORY      https://github.com/aws/aws-sdk-cpp.git
        GIT_TAG             master
        GIT_SHALLOW         1
        SOURCE_DIR          "${CMAKE_CURRENT_BINARY_DIR}/aws_sdk_cpp-src"
        BINARY_DIR          "${CMAKE_CURRENT_BINARY_DIR}/aws_sdk_cpp-build"
        CONFIGURE_COMMAND   ""
        BUILD_COMMAND       ""
        INSTALL_COMMAND     ""
        TEST_COMMAND        ""
        )
```
and here is the principal cmake file
```
# CMakeLists.txt
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
```
Now, once I `add_subdirectory` as 
```
add_subdirectory(${CMAKE_CURRENT_BINARY_DIR}/aws_sdk_cpp-src
        ${CMAKE_CURRENT_BINARY_DIR}/aws_sdk_cpp-build
        EXCLUDE_FROM_ALL)
```
the step `AwsCCommon` tries to *install* headers to /usr/local/include yielding a permission denied.

**Logs/output**
```
[  4%] Performing install step for 'AwsCCommon'
[ 41%] Built target aws-c-common
[ 97%] Built target aws-c-common-tests
[100%] Built target aws-c-common-assert-tests
Install the project...
-- Install configuration: "Debug"
-- Installing: /usr/local/include/aws/common/allocator.h
CMake Error at cmake_install.cmake:41 (file):
  file INSTALL cannot copy file
  "/home/fiorentinoing/devel/aws-s3-client/cmake-build-debug/aws_sdk_cpp-build/.deps/build/src/AwsCCommon/include/aws/common/allocator.h"
  to "/usr/local/include/aws/common/allocator.h".


Makefile:128: recipe for target 'install' failed
make[3]: *** [install] Error 1
CMakeFiles/AwsCCommon.dir/build.make:73: recipe for target 'build/src/AwsCCommon-stamp/AwsCCommon-install' failed
make[2]: *** [build/src/AwsCCommon-stamp/AwsCCommon-install] Error 2
CMakeFiles/Makefile2:107: recipe for target 'CMakeFiles/AwsCCommon.dir/all' failed
make[1]: *** [CMakeFiles/AwsCCommon.dir/all] Error 2
Makefile:83: recipe for target 'all' failed
make: *** [all] Error 2
CMake Error at cmake-build-debug/aws_sdk_cpp-src/CMakeLists.txt:235 (message):
  Failed to build third-party libraries.


-- Configuring incomplete, errors occurred!
```
