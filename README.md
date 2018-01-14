# ThirdPartyModules
This project creates one library which contains several open source projects. CMake tools is used to configure.

Now the following open source modules are included,
	zlib
	jpeg
	libpng
	tinyxml

## How to build
1. Drag CMakeLists.txt into CMake (ok v3.7.0 at least) to generate Visual Studio solution files. (vs2008 ok at least)
2. Use Visual Studio to compile.  (vs2008 ok at least)
3. The result is in deps/ directory.

Now the library built on vs2008 is placed in deps/ directory. It can be used directly.

**Requests and Bug reports**

- [GitHub issues](https://github.com/zcatt/test/issues)

**Git the source**

- [Git and GitHub](https://github.com/zcatt/ThirdPartyModules)



**More Chinese comments**

vc2008编译的第三方库
===============================================================

目录
-------------------------
.目录说明
.一般说明
.zlib-1.2.11编译说明
.tinyxml-2.6.3编译说明
.libpng-1.6.29编译说明
.ijg jpeg-9b编译说明

-------------------------



.目录说明
============================
说明.txt                    项目说明文件
Readme.md                   项目说明文件
CMakeLists.txt              cmake主文件，使用cmake工具生成vs工程文件
cmake/                      cmake附带文件
build/                      cmake生成的vs工程文件
deps/                       最终生成的h,lib,dll文件，
    /h                      头文件
    /bin                    dll文件
    /lib                    库文件
    /static/                静态库文件
    /dynamic/               dll的import lib
<module>/                   各第3方模块
    /ZF_BUILD               各模块的cmake文件
OrigPackage/                原始文件
	

.一般说明
============================
1.配制环境变量PATH，加入deps/bin/
注意，由于dll可能冲突，例如zlib_d.dll可能被path中之前的dll干扰，而导致zlib_example执行失败，此时可以尝试将zlib_d.dll直接放到debug目录下确认.

2.
cmake-gui中，
设置"where to build the binaries:"路径到build/
设置"where is the source code:"路径到./

点击configure, 选vs2008
设置列表中各选项
点击generate，生成各vs工程到build/


.zlib-1.2.11编译说明
============================

zlib-1.2.11中包括3个target

1.zlib						zlib dll库
1.zlib_static				zlib static库
2.zlib_example				zlib测试例
3.minizip					minizip dll
3.minizip_static			minizip static


.关于zlib 和zlib_static

选自.\contrib\vstudio\readme.txt:

Build instructions for Visual Studio 2008 (32 bits or 64 bits)
--------------------------------------------------------------
- Decompress current zlib, including all contrib/* files
- Compile assembly code (with Visual Studio Command Prompt) by running:
   bld_ml64.bat (in contrib\masmx64)
   bld_ml32.bat (in contrib\masmx86)
- Open contrib\vstudio\vc9\zlibvc.sln with Microsoft Visual C++ 2008
- Or run: vcbuild /rebuild contrib\vstudio\vc9\zlibvc.sln "Release|Win32"

cmake-gui中有两个选项ZLIB_AMD64和ZLIB_ASM686。
实际运行example发现ZLIB_ASM686无法通过.故不要勾选这两个选项.



.关于minizip
为了支持DLL，修改了zip.h和unzip.h




.tinyxml-2.6.3编译说明
============================
包括3个target
1. tinyxml						dll
2. tinyxml_static				static lib
3. tinyxml_example				example

为了支持DLL，修改了tinystr.h, tinyxml.h。




.libpng-1.6.29编译说明
============================
包括3个target
1. libpng						dll
2. libpng_static				static lib
3. pngtest						example. 格式 pngtest xxx.png


生成dll时需要定义宏PNG_BUILD_DLL.


.ijg jpeg-9b编译说明
============================



