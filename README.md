# Setting up Continuous Integration for GCC-5

[![Build Status](https://travis-ci.org/jamlamberti/gcc5-ci-example.svg?branch=master)](https://travis-ci.org/jamlamberti/gcc5-ci-example)
[![Coverage Status](https://coveralls.io/repos/github/jamlamberti/gcc5-ci-example/badge.svg?branch=master)](https://coveralls.io/github/jamlamberti/gcc5-ci-example?branch=master)


This guide will cover setting up a testing environment locally as well as a hosted CI environment. The CI part will leverage Travis CI for building and testing code and Coveralls for hosting code coverage reports. 

# Local Install

## Grabbing the Dependencies

First, we need to install Google Test (Google’s C/C++ testing framework). GoogleTest requires cmake, which is included in the APT repository. To install:

```sudo apt-get install cmake```

If we don’t have root, we can download a pre-compiled binary or build it from source (see [https://cmake.org/download/](https://cmake.org/download/) or [https://cmake.org/install/](https://cmake.org/install/) for more information). 

Once you have cmake installed, clone the GoogleTest Github repo.

```git clone https://github.com/google/googletest.git```

Next, we need to build their code into an archive library:

```
cd googletest
cmake .
make -j8
```

Running make with the j option enables parallel builds (in this case using up to 8 threads). 


Next we need to install gcc-5 on our Ubuntu image. Fortunately, Ubuntu provides backports for APT so all we need to do is add their ppa key into the APT repository. 

```sudo add-apt-repository ppa:Ubuntu-toolchain-r/test –y```

Then we need to update APT to fetch the new packages.

```sudo apt-get update –q```

The -q "quiets" apt so the log file doesn’t get too large. With that being said, Travis CI will kill any builds where no output is produced in a 10 minute period.

Finally, we can install the 5.3 compiler:

```sudo apt-get install gcc-5 g++-5 –y```

Before we build our code, it is useful to see code coverage and check for issues like memory leaks. To do this, we can use lcov and cppcheck. To install:

```sudo apt-get install cppcheck lcov```

## Building the Sample Application

By now, you should be able to build the sample application! If you take a look in the Makefile, I link in the two archive libraries from GoogleTest. I also pass the --coverage flag in when building to enable coverage reports.

```
make
```

And to run:

```
./bin/main
```

Alternatively, we can build the testing version!

```
make clean
make TESTING=1
./bin/main
```

cppcheck performs static analysis of our code. To run:

```cppcheck src/```

By default cppcheck always exits with 0, but if we want builds to fail if any issues are detected we can run:

```cppcheck src/ --error-exitcode=1```

And finally we can generate code coverage results:

```lcov --directory . --capture --output-file coverage.info```

Once we have the coverage information, we want to remove the coverage results for the GoogleTest code base and other external C/C++ code.

```lcov --remove coverage.info '/usr/*' 'googletest/*' --output-file coverage.info```

We can output a summary of the results

```lcov --list coverage.info```

Or we can generate a report (to the reports directory) and open it up in our browser!

```
mkdir -p reports
genhtml –o reports coverage.info
```

# Enabling CI

We want to automate the whole process from above (plus some other things). To do this, we can create a .travis.yml file. This file declares the language our project uses as well as any commands to run. The order is before_install, install, script and finally after_success. We want to install all of our dependencies in before_install. Then we can install our own project in install (not used here). Finally we want to build and run our code. If this works, we can upload our coverage reports!

I broke out installing GoogleTest and Code Coverage to their own bash scripts. These are called from within the .travis.yml file. 

# Enabling Travis-CI

In your Github repo, click on Settings, then on the left hand side browse to the Webhooks & Services (github.com/\<username\>/\<repo-name\>/settings/hooks). Next browse to [https://travis-ci.org/profile/](https://travis-ci.org/profile/) and turn on the switch for the repository. 

Click on add service and add Travis CI. Leave the User, Token and Domain fields blank and make sure the Active checkbox is selected. 

# Enabling Coveralls

Sign into [https://coveralls.io](https://coveralls.io) with your Github Account then click on Repos then click on Add Repo. Turn on your repository and you should be good to go! You do not need to do anything with the secret token.

# Testing the Integration

Try pushing code to your repo and refresh the Webhooks page (github.com/\<username\>/\<repo-name\>/settings/hooks). There should be a checkmark next to Travis CI if the request when through successfully. Now you can browse to [https://travis-ci.org/](https://travis-ci.org/) and should see your repo listed along the left side menu. 

