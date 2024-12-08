# Relax the setup timing to 2 cycles
set_multicycle_path 2 -from [get_pins -hierarchical {Memory_Interface/addrb_reg[*]}] -to [get_pins -hierarchical {Memory_Interface/MB_flat_reg[*]}]

set_max_delay -datapath_only <delay_value> -from [get_pins -hierarchical {Memory_Interface/addra_reg[*]}] -to [get_pins -hierarchical {Memory_Interface/RAM_4/U0/*}]
set_property SLACK_WEIGHT 100 [get_pins -hierarchical {Memory_Interface/addra_reg[*]}]