vlib work

vlog *.sv

# simulate
vsim -voptargs=+acc work.top_tb

# add waves
add wave *

# run simulation
run -all