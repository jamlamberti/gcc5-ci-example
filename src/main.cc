#include <iostream>
#include <gtest/gtest.h>

int main(int argc, char** argv)
{
    #ifdef TESTING
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
    #else
    std::cout << "Hello World" << std::endl;
    return 0;
    #endif
}
