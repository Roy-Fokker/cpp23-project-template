# cmake version needs to be above 3.29 for module support
cmake_minimum_required(VERSION 4.0 FATAL_ERROR)

# must have C++ Standard version 23 or better
if (CMAKE_CXX_STANDARD LESS 23)
	message(FATAL_ERROR "C++23 or newer is required.")
endif()

# must ensure extensions are off
if ((NOT CMAKE_CXX_STANDARD_REQUIRED) OR (CMAKE_CXX_EXTENSIONS))
	message(FATAL_ERROR "Standards conformance is required. No C++ compiler extensions.")
endif()

# which compiler is being used?
# if MSVC v19.38+
if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC" 
	AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "19.38")
	# copy the module .ixx file from MSVC's folder
	# if the environment variable is defined. Done if cmake is run from MSVS Developer Console.
	if (DEFINED ENV{VCToolsInstallDir})  
		string(REPLACE "\\" "/" STD_MODULES_DIR "$ENV{VCToolsInstallDir}")
		set(STD_MODULES_DIR "${STD_MODULES_DIR}modules")
	else()
		# use a hacky method to get MSVC install directory from compiler path
		string(REGEX REPLACE "\/bin\/Host(x|X)(64|86)\/x(64|86)\/cl\.exe" "" STD_MODULES_DIR "${CMAKE_CXX_COMPILER}")
		set(STD_MODULES_DIR "${STD_MODULES_DIR}/modules")
	endif()

	# get the files for std module using Fetch Content
	include(FetchContent)
	FetchContent_Declare(
		std23modules
		URL "file://${STD_MODULES_DIR}"
		DOWNLOAD_EXTRACT_TIMESTAMP TRUE
		SYSTEM
	)
	FetchContent_MakeAvailable(std23modules)

	set(std23modules_SOURCES 
		${std23modules_SOURCE_DIR}/std.ixx 
		${std23modules_SOURCE_DIR}/std.compat.ixx
	)
else()
	message(FATAL_ERROR "C++23 Standard library module is not supported with current compiler.")
endif()

# set library name variables
set(STD_LIB_NS "Std") # Namespace we want
set(STD_LIB_MODULE "Modules") # Library name
set(PRJ_LIB_NAME ${STD_LIB_NS}${STD_LIB_MODULE}) 

# check against duplicate include
if (NOT TARGET ${STD_LIB_NS}::${STD_LIB_MODULE})
	# create library
	add_library(${PRJ_LIB_NAME} STATIC)
	add_library(${STD_LIB_NS}::${STD_LIB_MODULE} ALIAS ${PRJ_LIB_NAME})

	# add std module source files to our std modules library
	target_sources(${STD_LIB_NS}${STD_LIB_MODULE}
		PUBLIC 
			FILE_SET std_modules TYPE CXX_MODULES
			BASE_DIRS ${std23modules_SOURCE_DIR}
			FILES
				${std23modules_SOURCES}
	)

	# Copy ifc files for IntelliSense
	install(
		DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${PRJ_LIB_NAME}.dir/
		DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/ifc
		FILES_MATCHING PATTERN "*.ifc"
	)

	message("\n"
		"The StdModules.cmake usage: \n"
		"\ttarget_link_libraries(main PRIVATE ${STD_LIB_NS}::${STD_LIB_MODULE})\n"
	)
endif()
