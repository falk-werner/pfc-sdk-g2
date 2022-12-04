
add_library(wda_proxy SHARED src/wda_proxy)

target_include_directories(wda_proxy PUBLIC inc)
target_include_directories(wda_proxy PRIVATE ${PARAMCOM_INCLUDE_DIRS})
target_link_options(wda_proxy PUBLIC ${PARAMCOM_LDFLAGS})
target_link_libraries(wda_proxy PUBLIC Threads::Threads)
target_compile_options(wda_proxy PUBLIC ${PARAMCOM_CFLAGS} ${PARAMCOM_CFLAGS_OTHER})

install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/inc/wda_proxy.h DESTINATION include)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/libwda_proxy.pc DESTINATION lib/pkgconfig)
install(TARGETS wda_proxy LIBRARY DESTINATION lib)