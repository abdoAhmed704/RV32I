vlib work

vlog *.sv

# simulate
vsim -voptargs=+acc work.top_tb

# add waves
add wave *

add wave -position insertpoint  \
sim:/top_tb/top_ins/PCF \
sim:/top_tb/top_ins/PCE \
sim:/top_tb/top_ins/PCD \
sim:/top_tb/top_ins/pc

add wave -position insertpoint  \
sim:/top_tb/top_ins/fet/PCFx
add wave -position insertpoint  \
sim:/top_tb/top_ins/fet/rst_n

# run simulation
run -all