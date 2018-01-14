set(DEPNAME minizip)

set(VERSION "1.2.11")

set(MINIZIP_PUBLIC_HDRS
	zip.h 
	unzip.h 
	ioapi.h
	)

set(MINIZIP_PRIVATE_HDRS
	)

set(MINIZIP_SRCS
	unzip.c
	zip.c
	ioapi.c
	iowin32.c
	)


message(STATUS "hdr is ${MINIZIP_PUBLIC_HDRS}")
message(STATUS "srcs is ${MINIZIP_SRCS}")


set(SOURCES)
foreach(_FILE ${MINIZIP_SRCS})
	string(CONCAT _REL "../" ${_FILE})
	list(APPEND SOURCES ${_REL})
endforeach()

set(HEADERS)
foreach(_FILE ${MINIZIP_PUBLIC_HDRS} ${MINIZIP_PRIVATE_HDRS})
	string(CONCAT _REL "../" ${_FILE})
	list(APPEND HEADERS ${_REL})
endforeach()

message(STATUS "sources is ${SOURCES}")
message(STATUS "headers is ${HEADERS}")

include_directories(../ ${CMAKE_SOURCE_DIR}/deps/include)

zf_add_library(${DEPNAME} SOURCES HEADERS)

#set_target_properties(${DEPNAME} PROPERTIES DEFINE_SYMBOL ZLIB_DLL)
set_target_properties(${DEPNAME} PROPERTIES COMPILE_DEFINITIONS "ZLIB_DLL;ZLIB_INTERNAL;USE_FILE32API")
set_target_properties(${DEPNAME}_static PROPERTIES COMPILE_DEFINITIONS USE_FILE32API)

target_link_libraries(${DEPNAME} zlib) 
add_dependencies(${DEPNAME}_static zlib) 

foreach(_H_FILE ${MINIZIP_PUBLIC_HDRS}) 
	add_custom_command(TARGET ${DEPNAME} POST_BUILD 
		COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/../${_H_FILE}" 
		"${CMAKE_SOURCE_DIR}/deps/include/${_H_FILE}") 
endforeach()


