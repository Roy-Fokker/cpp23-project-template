cmake_minimum_required(VERSION 3.28)

# project and language to be used
project(cpp23-project-template
	LANGUAGES CXX
	HOMEPAGE_URL "https://roy-fokker.github.io/cpp23-project-template/"
	DESCRIPTION "C++23 based Project Template.")

# Enable scan for dependencies
set(CXX_SCAN_FOR_MODULES ON)
# disable C++ extensions
set(CMAKE_CXX_EXTENSIONS OFF)
# force C++ version to 23
set(CMAKE_CXX_STANDARD 23)
# standard is required
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Include Std Modules cmake
include(${CMAKE_MODULE_PATH}/StdModules.cmake)

# executable source folder
add_subdirectory(src)