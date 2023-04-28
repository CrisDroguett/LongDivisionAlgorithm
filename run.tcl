# Noah Fishman & Cris Droguett
# EECE 573 - run.tcl - Final Project

read_xdc clock.xdc
source report_area.tcl
read_verilog divider.v
read_verilog controller.v
read_verilog datapath.v
synth_design -top divider -part xc7a35tcpg236-1

file mkdir Reports

report_utilization -file ./Reports/divider.rpt

report_area ./Reports/divider.rpt
file rename -force ./area.rpt ./Reports/
report_timing_summary -file ./Reports/timing.rpt