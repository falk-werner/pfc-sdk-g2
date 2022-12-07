add_executable(read-ordernumber-c main.c)
target_link_libraries(read-ordernumber-c PRIVATE wda_proxy)

install(TARGETS read-ordernumber-c RUNTIME DESTINATION bin)
