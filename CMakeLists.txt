cmake_minimum_required(VERSION 3.7.0)
include(CMakeDependentOption) 

project(ThirdPartyModules)

if (NOT WIN32 OR NOT MSVC)
message(FATAL_ERROR "This third module is intended for use on MS Windows and Visual Studio only.")
endif()

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")
#include(ZF_deps_macros)

message(STATUS "prj source dir is ${PROJECT_SOURCE_DIR}")
message(STATUS "prj bin dir is ${PROJECT_BINARY_DIR}")
message(STATUS "module dir is ${CMAKE_MODULE_PATH}")

set(CMAKE_DEBUG_POSTFIX _d)


#set static or dll

cmake_dependent_option( ZF_MSVC_STATIC_RUNTIME "Specifies whether to the static runtime (/MT and /MTd) or the DLL runtime (/MD and /MDd)." FALSE "MSVC" FALSE )
mark_as_advanced(ZF_MSVC_STATIC_RUNTIME)

if (ZF_MSVC_STATIC_RUNTIME)
	foreach(_BUILD_CONFIG DEBUG RELEASE REWITHDEBINFO MINSIZEREL)
		foreach(_BUILD_VARS CMAKE_CXX_FLAGS_${_BUILD_CONFIG} CMAKE_C_FLAGS_${_BUILD_CONFIG})
			string(REGEX REPLACE /MD /MT ${_BUILD_VARS} ${{_BUILD_VARS}})
		endforeach()
	endforeach()
endif()

add_definitions(-D_CRT_SECURE_NO_WARNINGS) 
add_definitions(-D_CRT_NONSTDC_NO_DEPRECATE)


macro(zf_add_library _NAME _SOURCES_VAR _HEADERS_VAR)
    
	add_library(${_NAME} SHARED ${${_SOURCES_VAR}} ${${_HEADERS_VAR}})

	set_target_properties(${_NAME} PROPERTIES 
		ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/deps/lib/dynamic" 
		ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${CMAKE_SOURCE_DIR}/deps/lib/dynamic" 
		ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${CMAKE_SOURCE_DIR}/deps/lib/dynamic" 
		ARCHIVE_OUTPUT_DIRECTORY_MINSIZEREL "${CMAKE_SOURCE_DIR}/deps/lib/dynamic" 
		ARCHIVE_OUTPUT_DIRECTORY_RELWITHDEBINFO "${CMAKE_SOURCE_DIR}/deps/lib/dynamic"

		LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/deps/lib/dynamic" 
		LIBRARY_OUTPUT_DIRECTORY_DEBUG "${CMAKE_SOURCE_DIR}/deps/lib/dynamic" 
		LIBRARY_OUTPUT_DIRECTORY_RELEASE "${CMAKE_SOURCE_DIR}/deps/lib/dynamic" 
		LIBRARY_OUTPUT_DIRECTORY_MINSIZEREL "${CMAKE_SOURCE_DIR}/deps/lib/dynamic" 
		LIBRARY_OUTPUT_DIRECTORY_RELWITHDEBINFO "${CMAKE_SOURCE_DIR}/deps/lib/dynamic"

		RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/deps/bin" 
		RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_SOURCE_DIR}/deps/bin" 
		RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_SOURCE_DIR}/deps/bin" 
		RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL "${CMAKE_SOURCE_DIR}/deps/bin" 
		RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO "${CMAKE_SOURCE_DIR}/deps/bin")

	add_library(${_NAME}_static STATIC ${${_SOURCES_VAR}} ${${_HEADERS_VAR}})

	set_target_properties(${_NAME}_static PROPERTIES 
		ARCHIVE_OUTPUT_NAME ${_NAME}
		LIBRARY_OUTPUT_NAME ${_NAME}
		RUNTIME_OUTPUT_NAME ${_NAME}

		ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/deps/lib/static" 
		ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${CMAKE_SOURCE_DIR}/deps/lib/static" 
		ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${CMAKE_SOURCE_DIR}/deps/lib/static" 
		ARCHIVE_OUTPUT_DIRECTORY_MINSIZEREL "${CMAKE_SOURCE_DIR}/deps/lib/static" 
		ARCHIVE_OUTPUT_DIRECTORY_RELWITHDEBINFO "${CMAKE_SOURCE_DIR}/deps/lib/static"

		LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/deps/lib/static" 
		LIBRARY_OUTPUT_DIRECTORY_DEBUG "${CMAKE_SOURCE_DIR}/deps/lib/static" 
		LIBRARY_OUTPUT_DIRECTORY_RELEASE "${CMAKE_SOURCE_DIR}/deps/lib/static" 
		LIBRARY_OUTPUT_DIRECTORY_MINSIZEREL "${CMAKE_SOURCE_DIR}/deps/lib/static" 
		LIBRARY_OUTPUT_DIRECTORY_RELWITHDEBINFO "${CMAKE_SOURCE_DIR}/deps/lib/static"

		RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/deps/bin" 
		RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_SOURCE_DIR}/deps/bin" 
		RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_SOURCE_DIR}/deps/bin" 
		RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL "${CMAKE_SOURCE_DIR}/deps/bin" 
		RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO "${CMAKE_SOURCE_DIR}/deps/bin")
endmacro() 

file(MAKE_DIRECTORY "${CMAKE_SOURCE_DIR}/deps/include") 
file(MAKE_DIRECTORY "${CMAKE_SOURCE_DIR}/deps/bin") 
file(MAKE_DIRECTORY "${CMAKE_SOURCE_DIR}/deps/lib/static") 
file(MAKE_DIRECTORY "${CMAKE_SOURCE_DIR}/deps/lib/dynamic") 

enable_testing()

option(ZF_BUILD_ZLIB "To build the zlib library." TRUE) 
option(ZF_BUILD_MINIZIP "To build the minizip library. Auto build zlib" TRUE) 
option(ZF_BUILD_TINYXML "To build the tinyxml library." TRUE) 
option(ZF_BUILD_LIBPNG "To build the png library.  Auto build zlib" TRUE) 
option(ZF_BUILD_JPEG "To build the jpeg library." TRUE) 



if (ZF_BUILD_PCRE OR ZF_BUILD_LIBPNG OR ZF_BUILD_LIBTIFF OR ZF_BUILD_MINIZIP)
	set(CEGUI_BUILD_ZLIB TRUE) 
endif()

if (ZF_BUILD_ZLIB)
	add_subdirectory(zlib-1.2.11/ZF_BUILD)
	set(zlibDep zlib)
endif()

if (ZF_BUILD_MINIZIP)
	add_subdirectory(zlib-1.2.11/contrib/minizip/ZF_BUILD)
	set(minizipDep minizip)
endif()

if (ZF_BUILD_TINYXML)
	add_subdirectory(tinyxml-2.6.2/ZF_BUILD)
	set(tinyxmlDep tinyxml)
endif()

if (ZF_BUILD_LIBPNG)
	add_subdirectory(libpng-1.6.29/ZF_BUILD)
	set(libpngDep libpng)
endif()

if (ZF_BUILD_JPEG)
	add_subdirectory(jpeg-9b/ZF_BUILD)
	set(jpegDep jpeg)
endif()





add_custom_target(POST_BUILD_CLEANUP ALL DEPENDS ${zlibDep} ${minizipDep} ${tinyxmlDep} ${libpngDep} ${jpegDep})
add_custom_command(TARGET POST_BUILD_CLEANUP COMMAND ${CMAKE_COMMAND} -P "${CMAKE_SOURCE_DIR}/msvc_postbuild.cmake")

#delete all of heades,lib, and dll file from deps/
add_custom_target(ALL_CLEANUP)
add_custom_command(TARGET ALL_CLEANUP COMMAND ${CMAKE_COMMAND} -P "${CMAKE_SOURCE_DIR}/msvc_cleanup.cmake")

#remove does not support wild char.
#add_custom_command(TARGET ALL_CLEANUP COMMAND ${CMAKE_COMMAND} -E chdir ${CMAKE_SOURCE_DIR}/deps ${CMAKE_COMMAND} -E remove * bin/* include/* lib/* lib/dynamic/* lib/static/*)

