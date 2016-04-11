#include <iostream>
#include <gtest/gtest.h>

TEST(SomeTestClass, SpecificTest)
{
    EXPECT_EQ(3+3, 6);
    EXPECT_NE(2+2, 5);
}

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
