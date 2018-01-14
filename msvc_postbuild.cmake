file(GLOB_RECURSE UNWANTED 
    ${CMAKE_SOURCE_DIR}/../deps/*manifest*
    ${CMAKE_SOURCE_DIR}/../deps/bin/*.txt
    ${CMAKE_SOURCE_DIR}/../deps/*.ilk
    ${CMAKE_SOURCE_DIR}/../deps/*.in
    ${CMAKE_SOURCE_DIR}/../deps/Makefile*)

message(STATUS "del ${UNWANTED}")

if (UNWANTED)
    file(REMOVE ${UNWANTED})
endif()

