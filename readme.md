# C++23 Project Template

## Uses
- vcpkg for package management
- ninja for build engine
- cmake with cmakepresets for configuration and build
- cmake min_ver 3.29
- C++ modules enabled
- Uses C++ Standard Library modules
  - MSVC

## to be figured out
- linux configuration
- Non MSVC compilers
- Intellisense and clangd both cannot handle modules so don't work correctly

## Example project
- uses fmt from vcpkg

## references
- Building on linux with Clang and libc++ for module support, https://mattbolitho.github.io/posts/vcpkg-with-libcxx/
- CMake 3.30 magic encantations, https://www.kitware.com/import-std-in-cmake-3-30/
- CMake module compilations, https://www.kitware.com/import-cmake-the-experiment-is-over/
