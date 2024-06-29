# cmake version needs to be above 3.29 for module support
cmake_minimum_required(VERSION 3.29 FATAL_ERROR)

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

	# set library name variable
	set(PRJ_LIB_NAME "StdModules")

	# check against duplicate include
	if (NOT TARGET ${PRJ_LIB_NAME})
		# create library
		add_library(${PRJ_LIB_NAME} STATIC)

		# add std module source files to our std modules library
		target_sources(${PRJ_LIB_NAME}
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
			"The package ${PRJ_LIB_NAME} provides CMake targets: \n"
			"\tfind_package(${PRJ_LIB_NAME})\n"
			"\ttarget_link_libraries(main PRIVATE ${PRJ_LIB_NAME})\n"
		)
	endif()

elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" 
	AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "18.0.0")

	# Assuming LibC++ is also installed for this version
	set(STD_MODULES_DIR "/usr/lib/llvm-18/share/libc++/v1/")

	find_file(cppm_file NAMES "std.cppm" PATHS "${STD_MODULES_DIR}" NO_CACHE REQUIRED)
	if (cppm_file_NOTFOUND)
		message(FATAL_ERROR "Cannot file std module source or LibC++: Looked in ${STD_MODULES_DIR}.") 
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
		${std23modules_SOURCE_DIR}/std.cppm
		${std23modules_SOURCE_DIR}/std.compat.cppm
	)

	# set library name variable
	set(PRJ_LIB_NAME "StdModules")

	# check against duplicate include
	if (NOT TARGET ${PRJ_LIB_NAME})
		# create library
		add_library(${PRJ_LIB_NAME} STATIC)

		# add std module source files to our std modules library
		target_sources(${PRJ_LIB_NAME}
			PUBLIC 
				FILE_SET std_modules TYPE CXX_MODULES
				BASE_DIRS ${std23modules_SOURCE_DIR}
				FILES
					${std23modules_SOURCES}
		)

		# clang specific compiler options
		target_compile_options(${PRJ_LIB_NAME}
			PUBLIC
				-Wno-reserved-module-identifier 
				-Wno-reserved-user-defined-literal
		)

		# clang specific linker options
		target_link_options(${PRJ_LIB_NAME}
			PUBLIC
				-stdlib=libc++
				-Wl
		)

		# clang should link to C++ libs
		target_link_libraries(${PRJ_LIB_NAME}
			INTERFACE
				c++
		)

		message("\n"
			"The package ${PRJ_LIB_NAME} provides CMake targets: \n"
			"\tfind_package(${PRJ_LIB_NAME})\n"
			"\ttarget_link_libraries(main PRIVATE ${PRJ_LIB_NAME})\n"
		)
	endif()
else()
	message(FATAL_ERROR "C++23 Standard library module is not supported with current compiler.")
endif()

