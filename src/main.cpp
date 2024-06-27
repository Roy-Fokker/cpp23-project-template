#include <fmt/core.h> // Must be included before import std;

import std;
import example;

auto main() -> int
{
	std::println("Hello World! -std");

	fmt::println("Hello World! -fmt");

	example::print_test();
}