cmake_minimum_required(VERSION 3.29.0 FATAL_ERROR)

# set library name variable
set(PRJ_LIB_NAME "std23modules")

# if the compiler being used is MSVC
if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC" AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "19.36")
	if (CMAKE_CXX_STANDARD VERSION_LESS 20)
		message(FATAL_ERROR "C++20 or newer is required.")
	elseif (CMAKE_CXX_STANDARD VERSION_LESS 23 AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS "19.38")
		message(FATAL_ERROR "C++23 Standard library module in C++20 is only supported with MSVC 19.38 or newer.")
	endif()

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
		${PRJ_LIB_NAME}
		URL "file://${STD_MODULES_DIR}"
		DOWNLOAD_EXTRACT_TIMESTAMP TRUE
		SYSTEM
	)
	FetchContent_MakeAvailable(${PRJ_LIB_NAME})

	# create library
	add_library(${PRJ_LIB_NAME} STATIC)

	# add .ixx files to our std modules library
	target_sources(${PRJ_LIB_NAME}
		PUBLIC
			# magic encantations for C++ Modules Support in CMake
			FILE_SET std_modules TYPE CXX_MODULES 
			BASE_DIRS ${${PRJ_LIB_NAME}_SOURCE_DIR}
			FILES 
				${${PRJ_LIB_NAME}_SOURCE_DIR}/std.ixx 
				${${PRJ_LIB_NAME}_SOURCE_DIR}/std.compat.ixx
	)

	message("C++ Standard Library Modules available. Link to '${PRJ_LIB_NAME}'")
else()
	message(FATAL_ERROR "C++23 Standard library module is not supported with current compiler.")
endif()