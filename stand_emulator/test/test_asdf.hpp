/**
 * @file test/test_asdf.hpp
 * @author Pavan Dayal
 */
#ifndef TEST_ASDF_H
#define TEST_ASDF_H

#include "test.hpp"
//#include "../asdf.hpp"
#include <iostream>

namespace test_asdf {
    const int NUM_TESTS = 1;
    /* return 0 for success and 1 for failure */
    int test_create();
    /* returns number of failures */
    int run_all();
}

#endif /* TEST_ASDF_H */

