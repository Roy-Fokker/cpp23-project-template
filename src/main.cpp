#include <fmt/core.h>
#include <print>

import example;

auto main() -> int
{
	std::println("Hello World! -std");

	fmt::println("Hello World! -fmt");

	example::print_test();
}