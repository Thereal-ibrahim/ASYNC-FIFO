transcript on

if {![file exists work]} {
    vlib work
}
vmap work work

vlog -sv DATA_SYNC.sv
vlog -sv MEMORY.sv
vlog -sv FIFO_WR.sv
vlog -sv FIFO_RD.sv
vlog -sv FIFO_TOP.sv
vlog -sv FIFO_tb.sv

vsim -voptargs=+acc work.FIFO_tb
do [file join [file dirname [info script]] wave.do]
run -all
