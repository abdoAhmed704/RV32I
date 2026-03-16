vlib work

vlog register_file.sv
vlog register_file_tb.sv

vsim -voptargs=+acc work.register_file_tb
add wave *
run -all
#quit -sim