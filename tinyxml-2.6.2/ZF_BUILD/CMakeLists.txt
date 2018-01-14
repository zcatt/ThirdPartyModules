set(DEPNAME tinyxml)

set(VERSION "2.6.2")


set(TINYXML_PUBLIC_HDRS
	tinystr.h
	tinyxml.h
	)

set(TINYXML_PRIVATE_HDRS
	)

set(TINYXML_SRCS
	tinystr.cpp
	tinyxml.cpp
	tinyxmlerror.cpp
	tinyxmlparser.cpp
	)



message(STATUS "tinyxml pub hdr is ${TINYXML_PUBLIC_HDRS}")
message(STATUS "tinyxml srcs is ${TINYXML_SRCS}")

set(SOURCES)
foreach(_FILE ${TINYXML_SRCS})
	string(CONCAT _REL "../" ${_FILE})
	list(APPEND SOURCES ${_REL})
endforeach()

set(HEADERS)
foreach(_FILE ${TINYXML_PUBLIC_HDRS} ${TINYXML_PRIVATE_HDRS})
	string(CONCAT _REL "../" ${_FILE})
	list(APPEND HEADERS ${_REL})
endforeach()


message(STATUS "tiny sources is ${SOURCES}")
message(STATUS "tiny headers is ${HEADERS}")

include_directories("../")

zf_add_library(${DEPNAME} SOURCES HEADERS)
set_target_properties(${DEPNAME} PROPERTIES COMPILE_DEFINITIONS "TINYXML_DLL;TINYXML_INTERNAL")

foreach(_H_FILE ${TINYXML_PUBLIC_HDRS}) 
	add_custom_command(TARGET ${DEPNAME} POST_BUILD 
		COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/../${_H_FILE}" 
		"${CMAKE_SOURCE_DIR}/deps/include/${_H_FILE}") 
endforeach()

add_custom_command(TARGET ${DEPNAME} POST_BUILD 
	COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/../readme.txt" 
	"${CMAKE_SOURCE_DIR}/deps/tinyxml-readme.txt") 



add_executable(tinyxml_example ../xmltest.cpp)
set_target_properties(tinyxml_example PROPERTIES COMPILE_DEFINITIONS "TINYXML_DLL")
set_property(TARGET tinyxml_example APPEND PROPERTY COMPILE_DEFINITIONS $<$<CONFIG:Debug>:TUNE>)
target_link_libraries(tinyxml_example tinyxml)

add_test(tinyxml_example tinyxml_example)
