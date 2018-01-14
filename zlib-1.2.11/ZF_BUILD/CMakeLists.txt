set(DEPNAME zlib)

set(VERSION "1.2.11")

option(ZLIB_ASM686 "Enable building i686 assembly implementation")
option(ZLIB_AMD64 "Enable building amd64 assembly implementation")

#file(GLOB SOURCES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "../*.c") 
#set(HEADERS zlib.h zconf.h)

set(ZLIB_PUBLIC_HDRS
	zconf.h
	zlib.h
)

set(ZLIB_PRIVATE_HDRS
	crc32.h
	deflate.h
	gzguts.h
	inffast.h
	inffixed.h
	inflate.h
	inftrees.h
	trees.h
	zutil.h
)

set(ZLIB_SRCS
	adler32.c
	compress.c
	crc32.c
	deflate.c
	gzclose.c
	gzlib.c
	gzread.c
	gzwrite.c
	inflate.c
	infback.c
	inftrees.c
	inffast.c
	trees.c
	uncompr.c
	zutil.c
)

if(ZLIB_ASM686)
	ENABLE_LANGUAGE(ASM_MASM)
	set(ZLIB_ASMS
		contrib/masmx86/inffas32.asm
		contrib/masmx86/match686.asm
		)
elseif (ZLIB_AMD64)
	ENABLE_LANGUAGE(ASM_MASM)
	set(ZLIB_ASMS
		contrib/masmx64/gvmat64.asm
		contrib/masmx64/inffasx64.asm
		)
endif()

if(ZLIB_ASMS)
	add_definitions(-DASMV -DASMINF)
endif()

message(STATUS "hdr is ${ZLIB_PUBLIC_HDRS}")
message(STATUS "srcs is ${ZLIB_SRCS}")

#set(SOURCES ${ZLIB_SRCS} ${ZLIB_ASMS})
#set(HEADERS ${ZLIB_PUBLIC_HDRS} ${ZLIB_PRIVATE_HDRS})

set(SOURCES)
foreach(_FILE ${ZLIB_SRCS} ${ZLIB_ASMS})
	string(CONCAT _REL "../" ${_FILE})
	list(APPEND SOURCES ${_REL})
endforeach()

set(HEADERS)
foreach(_FILE ${ZLIB_PUBLIC_HDRS} ${ZLIB_PRIVATE_HDRS})
	string(CONCAT _REL "../" ${_FILE})
	list(APPEND HEADERS ${_REL})
endforeach()


message(STATUS "sources is ${SOURCES}")
message(STATUS "headers is ${HEADERS}")

include_directories("../")

zf_add_library(${DEPNAME} SOURCES HEADERS)

set_target_properties(${DEPNAME} PROPERTIES DEFINE_SYMBOL ZLIB_DLL)

foreach(_H_FILE ${ZLIB_PUBLIC_HDRS}) 
	add_custom_command(TARGET ${DEPNAME} POST_BUILD 
		COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/../${_H_FILE}" 
		"${CMAKE_SOURCE_DIR}/deps/include/${_H_FILE}") 
endforeach()

add_custom_command(TARGET ${DEPNAME} POST_BUILD 
	COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/../README" 
	"${CMAKE_SOURCE_DIR}/deps/zlib-README.txt") 


add_executable(zlib_example ../test/example.c)
target_link_libraries(zlib_example zlib)

add_test(zlib_example zlib_example)
