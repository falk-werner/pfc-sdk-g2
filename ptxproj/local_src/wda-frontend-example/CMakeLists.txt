
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

# C++ executable

add_executable(wda-frontend-example
	src/main.cpp
)

target_include_directories(wda-frontend-example PRIVATE ${PARAMCOM_INCLUDE_DIRS})
target_link_options(wda-frontend-example PRIVATE ${PARAMCOM_LDFLAGS})
target_link_libraries(wda-frontend-example PRIVATE Threads::Threads)
target_compile_options(wda-frontend-example PRIVATE ${PARAMCOM_CFLAGS} ${PARAMCOM_CFLAGS_OTHER})

# C library

add_library(paramcom_c SHARED
	src/paramcom_c)

target_include_directories(paramcom_c PRIVATE ${PARAMCOM_INCLUDE_DIRS})
target_link_options(paramcom_c PUBLIC ${PARAMCOM_LDFLAGS})
target_link_libraries(paramcom_c PUBLIC Threads::Threads)
target_compile_options(paramcom_c PUBLIC ${PARAMCOM_CFLAGS} ${PARAMCOM_CFLAGS_OTHER})

# C executable

add_executable(read-ordernumber-c src/main.c)
target_link_libraries(read-ordernumber-c PRIVATE paramcom_c)


install(TARGETS wda-frontend-example RUNTIME DESTINATION bin)

