cmake_minimum_required(VERSION 3.28)

# include logic to cmake non-module files
# include(cmake/glsl_compiler.cmake)

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
set(CXX_STANDARD_REQUIRED ON)


# executable source folder
add_subdirectory(src)