export DESIGN_NAME     = counter
export PLATFORM        = sky130hd
export DESIGN_NICKNAME = my_counter

export VERILOG_FILES   = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/counter.v
export SDC_FILE        = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/counter.sdc

# Use fixed die size for tiny design
export DIE_AREA    = 0 0 100 100
export CORE_AREA   = 10 10 90 90

# Clock port
export CLOCK_PORT = clk
