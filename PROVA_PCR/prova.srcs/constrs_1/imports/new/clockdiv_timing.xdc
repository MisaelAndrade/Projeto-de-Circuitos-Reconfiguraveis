
create_clock -period 14.000 -waveform {0.000 7.000} -name clkin [get_ports clk]

set_input_delay -clock clkin -max 2.000 [get_ports reset]
set_input_delay -clock clkin -min 1.000 [get_ports reset]

set_input_delay -clock clkin -max 0.750 [get_ports reset]
set_input_delay -clock clkin -min 0.500 [get_ports reset]

#assume que o -min é 2
set_output_delay -clock clkin 2.000 [get_ports led]
