/**
 * @file test/test_asdf.cpp
 * @author Pavan Dayal
 */

#include "test_asdf.hpp"
#include <sstream>
#include <cstring>

int test_asdf::test_create() {
    //tree::Tree* t;
    //testequal("0 children", 0, t->n);
    //testnull("children array not null", t->children);
    //tree::freeTree(t);
    return EXIT_SUCCESS;
}

int test_asdf::run_all() {
    int fails = 0;
    testfn(test_asdf::test_create, "asdf::something()");
    return fails;
}
