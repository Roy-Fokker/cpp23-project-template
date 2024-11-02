# C++23 Project Template

## Uses
- vcpkg for package management
- ninja for build engine
- cmake with cmakepresets for configuration and build
- cmake min_ver 3.30
- C++ modules enabled
- Uses C++ Standard Library modules
  - MSVC (Windows only)
  - Clang (Linux with libc++ only)

## to be figured out
- Intellisense and clangd both cannot handle modules so don't work correctly

## Example project
- uses fmt from vcpkg

## references
- Building on linux with Clang and libc++ for module support, https://mattbolitho.github.io/posts/vcpkg-with-libcxx/
