SDIR = src
ODIR = bin
CXXFILES = main
CXX = g++

ifeq ($(TRAVIS), 1)
	CXX = g++-5
endif

CXXFLAGS = -std=c++11 -O1 -I googletest/googletest/include --coverage -Wall -Werror
ifeq ($(TESTING), 1)
	CXXFLAGS = $(CXXFLAGS) -DTESTING
endif

LDFLAGS = googletest/googlemock/gtest/libgtest.a googletest/googlemock/gtest/libgtest_main.a -lpthread

TARGET = $(ODIR)/main

OFILES = $(patsubst %, $(ODIR)/%.o, $(CXXFILES))


.PHONY: all clean

tmp := $(shell mkdir -p $(ODIR))

all: $(TARGET)

$(ODIR)/%.o: $(SDIR)/%.cc
	@echo [CXX] $< "-->" $@
	@$(CXX) $(CXXFLAGS) -c $< -o $@

$(TARGET): $(OFILES)
	@echo [LD} $< "-->" $@
	@$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)

clean:
	@echo cleaning up
	@rm -rf $(ODIR)
