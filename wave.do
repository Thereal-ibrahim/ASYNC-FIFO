onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Yellow /FIFO_tb/WR_CLK
add wave -noupdate -color Cyan /FIFO_tb/RD_CLK
add wave -noupdate -color Red /FIFO_tb/RST
add wave -noupdate -color Orange /FIFO_tb/Wr_Req
add wave -noupdate -color Magenta /FIFO_tb/Rd_Req
add wave -noupdate -color Gold /FIFO_tb/Rd_En
add wave -noupdate -color Brown /FIFO_tb/dut/Empty_Flag
add wave -noupdate -color Red /FIFO_tb/dut/FIFO_FULL
add wave -noupdate -color Violet -radix unsigned /FIFO_tb/dut/fifo_rd_inst/next_gray_rd_ptr
add wave -noupdate -radix unsigned /FIFO_tb/dut/data_sync_inst/DATA_IN
add wave -noupdate -radix unsigned /FIFO_tb/dut/data_sync_inst/DATA_OUT
add wave -noupdate -radix unsigned /FIFO_tb/dut/fifo_rd_inst/Gray_Wr_Ptr
add wave -noupdate -color Green -radix hexadecimal /FIFO_tb/Wr_Data
add wave -noupdate -color Blue -radix hexadecimal /FIFO_tb/Rd_Data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {102119 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 120
configure wave -valuecolwidth 90
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {7943250 ps}
