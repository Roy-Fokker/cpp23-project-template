module;

#include <fmt/core.h>
#include <print>

export module example;

export void print_test()
{
	std::println("Example Module: Hello World! -std");

	fmt::println("Example Module: Hello World! -fmt");
}