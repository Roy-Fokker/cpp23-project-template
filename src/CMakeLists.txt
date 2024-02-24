# find vcpkg installed library
find_package(fmt CONFIG REQUIRED)

# name of this application/library
set(PRJ_APP_NAME "cpp23-application")

# create executable for initial setup
add_executable(${PRJ_APP_NAME})

# ensure it's Standard C++ 23
target_compile_features(${PRJ_APP_NAME} PRIVATE cxx_std_23)

# set preprocessor defines
target_compile_definitions(${PRJ_APP_NAME}
	PRIVATE 
		UNICODE _UNICODE            # Tell compiler we are using UNICODE
		_CRT_SECURE_NO_WARNINGS     # Don't want MSVC's CRT warnings
		NOMINMAX                    # Don't want Window.h to define min and max macros
		WIN32_LEAN_AND_MEAN         # Windows.h should only include the basics
)

# source files for this application
target_sources(${PRJ_APP_NAME}
	# Non C++ module source files
	PRIVATE
		main.cpp

	# magic encantations for C++ Modules Support in CMake
	PRIVATE FILE_SET app_modules TYPE CXX_MODULES FILES
		example.ixx
)

# libraries used by this application
target_link_libraries(${PRJ_APP_NAME}
	PRIVATE
		fmt::fmt
)