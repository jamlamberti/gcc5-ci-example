SDIR = src
ODIR = bin
CXXFILES = main
CXX = g++-1

ifneq "$(shell which g++-6)" ""
	CXX = g++-6
endif

CXXFLAGS = -std=c++11 -O1 -I googletest/googletest/include --coverage -Wall -Werror

ifeq ($(TESTING), 1)
	CXXFLAGS += -DTESTING
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
