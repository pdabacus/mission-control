/**
 * @file test/main.cpp
 * @author Pavan Dayal
 */

#include <cstdio>
#include <iostream>
#include <string>
#include "test_asdf.hpp"

std::string indent = " * ";

int main() {
    int fails = 0;
    int total = 0;
    int f, t;

    std::cerr << "testing asdf.hpp:" << std::endl;
    f = test_asdf::run_all();
    t = test_asdf::NUM_TESTS;
    fprintf(stderr, "passed (%d/%d): %.2f%%\n", t-f, t, 100.0*(t-f)/t);
    fails += f;
    total += t;

    return f;
}
