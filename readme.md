# C++23 Project Template

## Uses
- ~~vcpkg for package management~~
- CPM.cmake for package management
- ninja for build engine
- cmake with cmakepresets for configuration and build
- cmake min_ver 4.0
- C++ modules enabled
- Uses C++ Standard Library modules
  - MSVC (Windows only)
  - Clang (Linux with libc++ only)

## to be figured out
- Intellisense and clangd both cannot handle modules so don't work correctly

## Example project
- uses fmt from github via CPM.cmake

## references
- Building on linux with Clang and libc++ for module support, https://mattbolitho.github.io/posts/vcpkg-with-libcxx/
- CMake 3.30 magic encantations,
  - v3.30 https://www.kitware.com/import-std-in-cmake-3-30/
  - v4.0  https://github.com/Kitware/CMake/blob/master/Help/dev/experimental.rst#c-import-std-support
- CMake module compilations, https://www.kitware.com/import-cmake-the-experiment-is-over/
