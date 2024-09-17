## Princeton University -- ELE 206/COS 306
## This file is a .xdc for the Basys3 board
## It is to be used for the PUnC Lab

## Voltage
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

## Clock signal
set_property PACKAGE_PIN W5 [get_ports sysclk]							
	set_property IOSTANDARD LVCMOS33 [get_ports sysclk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports sysclk]

## Clock Button
set_property PACKAGE_PIN U18 [get_ports pclk]						
	set_property IOSTANDARD LVCMOS33 [get_ports pclk]

## Reset Button
set_property PACKAGE_PIN T17 [get_ports rst]						
	set_property IOSTANDARD LVCMOS33 [get_ports rst]

## Data LEDs
set_property PACKAGE_PIN U16 [get_ports {pc_led[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pc_led[0]}]
set_property PACKAGE_PIN E19 [get_ports {pc_led[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pc_led[1]}]
set_property PACKAGE_PIN U19 [get_ports {pc_led[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pc_led[2]}]
set_property PACKAGE_PIN V19 [get_ports {pc_led[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pc_led[3]}]
set_property PACKAGE_PIN W18 [get_ports {pc_led[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pc_led[4]}]
set_property PACKAGE_PIN U15 [get_ports {pc_led[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pc_led[5]}]
set_property PACKAGE_PIN U14 [get_ports {pc_led[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pc_led[6]}]
set_property PACKAGE_PIN V14 [get_ports {pc_led[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pc_led[7]}]
set_property PACKAGE_PIN V13 [get_ports {pc_led[8]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pc_led[8]}]
set_property PACKAGE_PIN V3 [get_ports {pc_led[9]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pc_led[9]}]
set_property PACKAGE_PIN W3 [get_ports {pc_led[10]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pc_led[10]}]
set_property PACKAGE_PIN U3 [get_ports {pc_led[11]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pc_led[11]}]
set_property PACKAGE_PIN P3 [get_ports {pc_led[12]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pc_led[12]}]
set_property PACKAGE_PIN N3 [get_ports {pc_led[13]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pc_led[13]}]
set_property PACKAGE_PIN P1 [get_ports {pc_led[14]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pc_led[14]}]
set_property PACKAGE_PIN L1 [get_ports {pc_led[15]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pc_led[15]}]

## Program Counter Seven-Segment Display
set_property PACKAGE_PIN W7 [get_ports {SSEG_CA[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[0]}]
set_property PACKAGE_PIN W6 [get_ports {SSEG_CA[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[1]}]
set_property PACKAGE_PIN U8 [get_ports {SSEG_CA[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[2]}]
set_property PACKAGE_PIN V8 [get_ports {SSEG_CA[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[3]}]
set_property PACKAGE_PIN U5 [get_ports {SSEG_CA[4]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[4]}]
set_property PACKAGE_PIN V5 [get_ports {SSEG_CA[5]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[5]}]
set_property PACKAGE_PIN U7 [get_ports {SSEG_CA[6]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[6]}]
set_property PACKAGE_PIN V7 [get_ports {SSEG_CA[7]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[7]}]

set_property PACKAGE_PIN U2 [get_ports {SSEG_AN[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_AN[0]}]
set_property PACKAGE_PIN U4 [get_ports {SSEG_AN[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_AN[1]}]
set_property PACKAGE_PIN V4 [get_ports {SSEG_AN[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_AN[2]}]
set_property PACKAGE_PIN W4 [get_ports {SSEG_AN[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_AN[3]}]

## Memory Dubug Address Selection Switches
set_property PACKAGE_PIN V17 [get_ports {mem_debug_addr[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {mem_debug_addr[0]}]
set_property PACKAGE_PIN V16 [get_ports {mem_debug_addr[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {mem_debug_addr[1]}]
set_property PACKAGE_PIN W16 [get_ports {mem_debug_addr[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {mem_debug_addr[2]}]
set_property PACKAGE_PIN W17 [get_ports {mem_debug_addr[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {mem_debug_addr[3]}]
set_property PACKAGE_PIN W15 [get_ports {mem_debug_addr[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {mem_debug_addr[4]}]
set_property PACKAGE_PIN V15 [get_ports {mem_debug_addr[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {mem_debug_addr[5]}]
set_property PACKAGE_PIN W14 [get_ports {mem_debug_addr[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {mem_debug_addr[6]}]
set_property PACKAGE_PIN W13 [get_ports {mem_debug_addr[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {mem_debug_addr[7]}]

## Unused Switches
# set_property PACKAGE_PIN V2 [get_ports {sw[8]}]					
# 	set_property IOSTANDARD LVCMOS33 [get_ports {sw[8]}]
# set_property PACKAGE_PIN T3 [get_ports {sw[9]}]					
# 	set_property IOSTANDARD LVCMOS33 [get_ports {sw[9]}]
# set_property PACKAGE_PIN T2 [get_ports {sw[10]}]					
# 	set_property IOSTANDARD LVCMOS33 [get_ports {sw[10]}]

## Register File Debug Address Selection Switches
set_property PACKAGE_PIN R3 [get_ports {rf_debug_addr[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {rf_debug_addr[0]}]
set_property PACKAGE_PIN W2 [get_ports {rf_debug_addr[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {rf_debug_addr[1]}]
set_property PACKAGE_PIN U1 [get_ports {rf_debug_addr[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {rf_debug_addr[2]}]

## Clock Selection Switch
set_property PACKAGE_PIN T1 [get_ports {clk_sel}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {clk_sel}]

## Display Selection Switch
set_property PACKAGE_PIN R2 [get_ports {disp_sel}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {disp_sel}]