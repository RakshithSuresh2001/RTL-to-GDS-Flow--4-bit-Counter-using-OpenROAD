# Try 300 MHz (3.33 ns period) - close to the limit!
create_clock -name clk -period 3.33 [get_ports clk]

set_input_delay  0.5 -clock clk [get_ports rst_n]
set_output_delay 0.5 -clock clk [get_ports count*]

set_load 0.05 [all_outputs]
