set(DEPNAME libpng)

set(VERSION "1.6.29")

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/../scripts/pnglibconf.h.prebuilt
                 ${CMAKE_CURRENT_SOURCE_DIR}/../pnglibconf.h)

set(LIBPNG_PUBLIC_HDRS
	png.h
	pngconf.h
	pnglibconf.h
	)

set(LIBPNG_PRIVATE_HDRS
	pngdebug.h
	pnginfo.h
	pngpriv.h
	pngstruct.h
	)

set(LIBPNG_SRCS
	png.c
	pngerror.c
	pngget.c
	pngmem.c
	pngpread.c
	pngread.c
	pngrio.c
	pngrtran.c
	pngrutil.c
	pngset.c
	pngtrans.c
	pngwio.c
	pngwrite.c
	pngwtran.c
	pngwutil.c
	)

message(STATUS "libpng pub hdr is ${LIBPNG_PUBLIC_HDRS}")
message(STATUS "libpng srcs is ${LIBPNG_SRCS}")

set(SOURCES)
foreach(_FILE ${LIBPNG_SRCS})
	string(CONCAT _REL "../" ${_FILE})
	list(APPEND SOURCES ${_REL})
endforeach()

set(HEADERS)
foreach(_FILE ${LIBPNG_PUBLIC_HDRS} ${LIBPNG_PRIVATE_HDRS})
	string(CONCAT _REL "../" ${_FILE})
	list(APPEND HEADERS ${_REL})
endforeach()


message(STATUS "libpng sources is ${SOURCES}")
message(STATUS "libpng headers is ${HEADERS}")

include_directories(../ ${CMAKE_SOURCE_DIR}/deps/include)

zf_add_library(${DEPNAME} SOURCES HEADERS)

target_link_libraries(${DEPNAME} zlib)
target_link_libraries(${DEPNAME}_static zlib)

set_target_properties(${DEPNAME} PROPERTIES 
						COMPILE_DEFINITIONS "PNG_BUILD_DLL;ZLIB_DLL;$<$<CONFIG:Debug>:PNG_DEBUG=1>")

#set_target_properties(${DEPNAME} PROPERTIES
#					    COMPILE_DEFINITIONS $<$<CONFIG:Debug>:PNG_DEBUG=1>)



foreach(_H_FILE ${LIBPNG_PUBLIC_HDRS}) 
	add_custom_command(TARGET ${DEPNAME} POST_BUILD 
		COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/../${_H_FILE}" 
		"${CMAKE_SOURCE_DIR}/deps/include/${_H_FILE}") 
endforeach()

add_custom_command(TARGET ${DEPNAME} POST_BUILD 
	COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/../README" 
	"${CMAKE_SOURCE_DIR}/deps/libpng-README.txt") 


add_executable(pngtest ../pngtest.c)
target_link_libraries(pngtest libpng)
#set_target_properties(pngtest PROPERTIES COMPILE_DEFINITIONS "PNG_USE_DLL")

set(PNGTEST_PNG "${CMAKE_CURRENT_SOURCE_DIR}/../pngtest.png")

set(TEST_OPTIONS "")
set(TEST_FILES "${PNGTEST_PNG}")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/../scripts/test.cmake.in"
                 "${CMAKE_CURRENT_BINARY_DIR}/tests/pngtest.cmake" @ONLY)


add_test(NAME pngtest
		 COMMAND "${CMAKE_COMMAND}"
		 "-DLIBPNG=$<TARGET_FILE:libpng>"
		 "-DTEST_COMMAND=$<TARGET_FILE:pngtest>"
		 -P "${CMAKE_CURRENT_BINARY_DIR}/tests/pngtest.cmake")
