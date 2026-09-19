IVERILOG ?= iverilog
VVP ?= vvp

BUILD_DIR := build
TARGET := $(BUILD_DIR)/vm_test
SOURCES := VM.v VM_tb.v

.PHONY: all test clean

all: test

test: $(TARGET)
	$(VVP) $(TARGET)

$(TARGET): $(SOURCES)
	mkdir -p $(BUILD_DIR)
	$(IVERILOG) -g2012 -Wall -o $(TARGET) $(SOURCES)

clean:
	rm -rf $(BUILD_DIR)
	rm -f *.vcd
