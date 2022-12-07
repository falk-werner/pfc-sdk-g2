
add_executable(read-ordernumber-cpp main.cpp)

target_include_directories(read-ordernumber-cpp PRIVATE ${PARAMCOM_INCLUDE_DIRS})
target_link_options(read-ordernumber-cpp PRIVATE ${PARAMCOM_LDFLAGS})
target_link_libraries(read-ordernumber-cpp PRIVATE Threads::Threads)
target_compile_options(read-ordernumber-cpp PRIVATE ${PARAMCOM_CFLAGS} ${PARAMCOM_CFLAGS_OTHER})

install(TARGETS read-ordernumber-cpp RUNTIME DESTINATION bin)
