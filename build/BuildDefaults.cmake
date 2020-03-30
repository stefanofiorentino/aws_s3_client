# Append custom CMake modules.
list(APPEND CMAKE_MODULE_PATH /usr/local/lib)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

include(FetchContentAwsSdkCpp)
