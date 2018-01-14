set(DEPNAME jpeg)

set(VERSION "9b")

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/../jconfig.vc
                 ${CMAKE_CURRENT_SOURCE_DIR}/../jconfig.h
				 COPYONLY)


set(JPEG_PUBLIC_HDRS
	jerror.h 
	jconfig.h 
	jmorecfg.h 
	jpeglib.h
	)

set(JPEG_PRIVATE_HDRS
	cderror.h
	cdjpeg.h
	jdct.h
	jinclude.h
	jmemsys.h
	jpegint.h
	jversion.h
	transupp.h
	)


set(JPEG_SRCS
	jaricom.c
	jcapimin.c
	jcapistd.c
	jcarith.c
	jccoefct.c
	jccolor.c
	jcdctmgr.c
	jchuff.c
	jcinit.c
	jcmainct.c
	jcmarker.c
	jcmaster.c
	jcomapi.c
	jcparam.c
	jcprepct.c
	jcsample.c
	jctrans.c
	jdapimin.c
	jdapistd.c
	jdarith.c
	jdatadst.c
	jdatasrc.c
	jdcoefct.c
	jdcolor.c
	jddctmgr.c
	jdhuff.c
	jdinput.c
	jdmainct.c
	jdmarker.c
	jdmaster.c
	jdmerge.c
	jdpostct.c
	jdsample.c
	jdtrans.c
	jerror.c
	jfdctflt.c
	jfdctfst.c
	jfdctint.c
	jidctflt.c
	jidctfst.c
	jidctint.c
	jquant1.c
	jquant2.c
	jutils.c
	jmemmgr.c
	jmemnobs.c
	)


set(CJPEG_APP_SRCS
	cjpeg.c
	rdppm.c
	rdgif.c
	rdtarga.c
	rdrle.c
	rdbmp.c
	rdswitch.c
	cdjpeg.c
	)

set(DJPEG_APP_SRCS
	djpeg.c 
	wrppm.c 
	wrgif.c 
	wrtarga.c 
	wrrle.c 
	wrbmp.c 
	rdcolmap.c 
	cdjpeg.c
	)

set(JPEGTRAN_APP_SRCS
	jpegtran.c
	rdswitch.c 
	cdjpeg.c
	transupp.c
	)

set(RDJPEGCOM_APP_SRCS
	rdjpgcom.c
	)

set(WRJPEGCOM_APP_SRCS
	wrjpgcom.c
	)



message(STATUS "jpeg pub hdr is ${JPEG_PUBLIC_HDRS}")
message(STATUS "jpeg srcs is ${JPEG_SRCS}")

set(SOURCES)
foreach(_FILE ${JPEG_SRCS})
	string(CONCAT _REL "../" ${_FILE})
	list(APPEND SOURCES ${_REL})
endforeach()

set(HEADERS)
foreach(_FILE ${JPEG_PUBLIC_HDRS} ${JPEG_PRIVATE_HDRS})
	string(CONCAT _REL "../" ${_FILE})
	list(APPEND HEADERS ${_REL})
endforeach()


message(STATUS "jpeg sources is ${SOURCES}")
message(STATUS "jpeg headers is ${HEADERS}")

include_directories(../)

zf_add_library(${DEPNAME} SOURCES HEADERS)

set_target_properties(${DEPNAME} PROPERTIES 
						COMPILE_DEFINITIONS "JPEG_DLL;JPEG_INTERNAL")



foreach(_H_FILE ${JPEG_PUBLIC_HDRS}) 
	add_custom_command(TARGET ${DEPNAME} POST_BUILD 
		COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/../${_H_FILE}" 
		"${CMAKE_SOURCE_DIR}/deps/include/${_H_FILE}") 
endforeach()

add_custom_command(TARGET ${DEPNAME} POST_BUILD 
	COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/../README" 
	"${CMAKE_SOURCE_DIR}/deps/jpeg-README.txt") 



set(CJPEG_APP_SOURCES)
foreach(_FILE ${CJPEG_APP_SRCS})
	string(CONCAT _REL "../" ${_FILE})
	list(APPEND CJPEG_APP_SOURCES ${_REL})
endforeach()

add_executable(cjpeg_app ${CJPEG_APP_SOURCES})
target_link_libraries(cjpeg_app jpeg)
#set_target_properties(cjpeg_app PROPERTIES COMPILE_DEFINITIONS "JPEG_DLL")


set(DJPEG_APP_SOURCES)
foreach(_FILE ${DJPEG_APP_SRCS})
	string(CONCAT _REL "../" ${_FILE})
	list(APPEND DJPEG_APP_SOURCES ${_REL})
endforeach()

add_executable(djpeg_app ${DJPEG_APP_SOURCES})
target_link_libraries(djpeg_app jpeg)
#set_target_properties(djpeg_app PROPERTIES COMPILE_DEFINITIONS "JPEG_DLL")

set(JPEGTRAN_APP_SOURCES)
foreach(_FILE ${JPEGTRAN_APP_SRCS})
	string(CONCAT _REL "../" ${_FILE})
	list(APPEND JPEGTRAN_APP_SOURCES ${_REL})
endforeach()

add_executable(jpegtran_app ${JPEGTRAN_APP_SOURCES})
target_link_libraries(jpegtran_app jpeg)
#set_target_properties(jpegtran_app PROPERTIES COMPILE_DEFINITIONS "JPEG_DLL")


set(RDJPEGCOM_APP_SOURCES)
foreach(_FILE ${RDJPEGCOM_APP_SRCS})
	string(CONCAT _REL "../" ${_FILE})
	list(APPEND RDJPEGCOM_APP_SOURCES ${_REL})
endforeach()

add_executable(rdjpegcom_app ${RDJPEGCOM_APP_SOURCES})
target_link_libraries(rdjpegcom_app jpeg)
#set_target_properties(rdjpegcom_app PROPERTIES COMPILE_DEFINITIONS "JPEG_DLL")

set(WRJPEGCOM_APP_SOURCES)
foreach(_FILE ${WRJPEGCOM_APP_SRCS})
	string(CONCAT _REL "../" ${_FILE})
	list(APPEND WRJPEGCOM_APP_SOURCES ${_REL})
endforeach()

add_executable(wrjpegcom_app ${WRJPEGCOM_APP_SOURCES})
target_link_libraries(wrjpegcom_app jpeg)
#set_target_properties(wrjpegcom_app PROPERTIES COMPILE_DEFINITIONS "JPEG_DLL")


