# cmake version needs to be above 3.28 for module support
cmake_minimum_required(VERSION 3.28 FATAL_ERROR)

# must have C++ Standard version 23 or better
if (CMAKE_CXX_STANDARD LESS 23)
	message(FATAL_ERROR "C++23 or newer is required.")
endif()

# must ensure extensions are off
if ((NOT CMAKE_CXX_STANDARD_REQUIRED) OR (CMAKE_CXX_EXTENSIONS))
	message(FATAL_ERROR "Standards conformance is required.")
endif()

# figure out path to STD Module path for current compiler
if (CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
	# using visual studio C++ compiler
	if (CMAKE_CXX_COMPILER_VERSION VERSION_LESS "19.36")
		message(FATAL_ERROR "MSVC version greater than 19.36 is required.")
	endif()

	if (NOT ("$ENV{VCToolsInstallDir}" STREQUAL ""))
		# get MSVC install path
		set(VC_INSTALL_DIR $ENV{VCToolsInstallDir})
		string(REPLACE "\\" "/" VC_INSTALL_DIR "${VC_INSTALL_DIR}")
		
	else ()
		# get MSVC install path
		set(VC_INSTALL_DIR $ENV{VCInstallDir}Tools/MSVC/${MSVC_TOOLS_VERSION})
		string(REPLACE "\\" "/" VC_INSTALL_DIR "${VC_INSTALL_DIR}")
	endif()

	# Std module file path for this compiler
	set(STD_MODULE_PATH "${VC_INSTALL_DIR}/modules")
	set(STD_MODULE_FILE_EXT "ixx") # MSVC STL uses .ixx extensions for modules

elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")  # using LLVM Clang C++ compiler
	if (CMAKE_CXX_COMPILER_VERSION VERSION_LESS "17.0.0")
		message(FATAL_ERROR "Clang++ version greater than 17.0.0 is required.")
	endif()

	message(FATAL_ERROR "Clang++ usage not implemented.")

	# Std module file path for this compiler
	set(STD_MODULE_PATH "")
	set(STD_MODULE_FILE_EXT "cppm") # clang uses .cppm extensions for modules

elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")  # using GNU Compiler Collection C++ compiler
	if (CMAKE_CXX_COMPILER_VERSION VERSION_LESS "14.0.0")
		message(FATAL_ERROR "GCC version greater than 14.0.0 is required.")
	endif()

	message(FATAL_ERROR "GCC usage not implemented.")

	# Std module file path for this compiler
	set(STD_MODULE_PATH "")
	set(STD_MODULE_FILE_EXT "cppm") # GNU GCC uses .cppm extensions for modules
endif()

include(FetchContent)
# copy files from compiler's directory to our project directory
FetchContent_Declare(
	stdmodules
	URL "file://${STD_MODULE_PATH}"
	DOWNLOAD_EXTRACT_TIMESTAMP TRUE
	FIND_PACKAGE_ARGS NAMES stdmodules # tell cmake to make it available via find_package
	SYSTEM
)
FetchContent_MakeAvailable(stdmodules)

# # create stdmodules library for consumption 
add_library(stdmodules STATIC)
target_sources(stdmodules
	PUBLIC 
	FILE_SET std_modules TYPE CXX_MODULES
	BASE_DIRS ${stdmodules_SOURCE_DIR}
	FILES
		${stdmodules_SOURCE_DIR}/std.${STD_MODULE_FILE_EXT}
		${stdmodules_SOURCE_DIR}/std.compat.${STD_MODULE_FILE_EXT}
)

# message("\n"
# 	"The package stdmodules provides CMake targets: \n\n"
# 	"	find_package(stdmodules)\n"
# 	"	target_link_libraries(main PRIVATE stdmodules)\n"
# )