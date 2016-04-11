#!/bin/bash
lcov --directory . --capture --output-file coverage.info
lcov --remove coverage.info '/usr/*' 'googletest/*' --output-file coverage.info
lcov --list coverage.info
mkdir -p reports
genhtml -o reports coverage.info
