SDIR = src
ODIR = bin
CXXFILES = main
CXX = g++

ifneq "$(shell which g++-5)" ""
	CXX = g++-5
endif

CXXFLAGS = -std=c++11 -O1 -I googletest/googletest/include -Wall -Werror

ifeq ($(TESTING), 1)
	CXXFLAGS += -DTESTING --coverage
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
