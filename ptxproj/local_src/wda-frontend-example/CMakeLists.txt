
cmake_minimum_required(VERSION 3.13.0)
project(wda-frontend-example VERSION 1.0.0)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_EXTENSIONS ON)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_EXTENSIONS ON)

find_package(PkgConfig REQUIRED)
pkg_check_modules(PARAMCOM REQUIRED libparamcom)

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

add_subdirectory(cpp)
add_subdirectory(libwda_proxy)
add_subdirectory(c)
add_subdirectory(python)
