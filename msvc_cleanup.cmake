#When run in -P script mode, CMake sets the variables CMAKE_BINARY_DIR, CMAKE_SOURCE_DIR, CMAKE_CURRENT_BINARY_DIR and CMAKE_CURRENT_SOURCE_DIR to the current working directory.
#We suppose the current working directory is build/

file(GLOB_RECURSE UNWANTED 
    ${CMAKE_SOURCE_DIR}/../deps/*.txt
    ${CMAKE_SOURCE_DIR}/../deps/bin/*
    ${CMAKE_SOURCE_DIR}/../deps/include/*
    ${CMAKE_SOURCE_DIR}/../deps/lib/*
    ${CMAKE_SOURCE_DIR}/../deps/lib/dynamic/*
    ${CMAKE_SOURCE_DIR}/../deps/lib/static/*)

#message(STATUS "delete ${UNWANTED}")
#message(STATUS "path: ${CMAKE_SOURCE_DIR}/../deps/*.txt")
#message(STATUS "path: ${CMAKE_SOURCE_DIR}/../deps/*.txt")

if (UNWANTED)
    file(REMOVE ${UNWANTED})
endif()

