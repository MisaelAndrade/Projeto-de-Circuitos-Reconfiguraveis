# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {C:/Users/Misael/Desktop/UNB/7 SEMESTRE/PROJETO DE CIRCUITOS RECONFIGURAVEIS/Lista1/ex1_ping_pong/ex1_ping_pong.cache/wt} [current_project]
set_property parent.project_path {C:/Users/Misael/Desktop/UNB/7 SEMESTRE/PROJETO DE CIRCUITOS RECONFIGURAVEIS/Lista1/ex1_ping_pong/ex1_ping_pong.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo {c:/Users/Misael/Desktop/UNB/7 SEMESTRE/PROJETO DE CIRCUITOS RECONFIGURAVEIS/Lista1/ex1_ping_pong/ex1_ping_pong.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  {C:/Users/Misael/Desktop/UNB/7 SEMESTRE/PROJETO DE CIRCUITOS RECONFIGURAVEIS/Lista1/ex1_ping_pong/ex1_ping_pong.srcs/sources_1/imports/new/display.vhd}
  {C:/Users/Misael/Desktop/UNB/7 SEMESTRE/PROJETO DE CIRCUITOS RECONFIGURAVEIS/Lista1/ex1_ping_pong/ex1_ping_pong.srcs/sources_1/imports/new/divisor_clock.vhd}
  {C:/Users/Misael/Desktop/UNB/7 SEMESTRE/PROJETO DE CIRCUITOS RECONFIGURAVEIS/Lista1/ex1_ping_pong/ex1_ping_pong.srcs/sources_1/imports/new/logica.vhd}
  {C:/Users/Misael/Desktop/UNB/7 SEMESTRE/PROJETO DE CIRCUITOS RECONFIGURAVEIS/Lista1/ex1_ping_pong/ex1_ping_pong.srcs/sources_1/imports/new/registrador.vhd}
  {C:/Users/Misael/Desktop/UNB/7 SEMESTRE/PROJETO DE CIRCUITOS RECONFIGURAVEIS/Lista1/ex1_ping_pong/ex1_ping_pong.srcs/sources_1/imports/new/ping_pong_rtl.vhd}
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc {{C:/Users/Misael/Desktop/UNB/7 SEMESTRE/PROJETO DE CIRCUITOS RECONFIGURAVEIS/Lista1/ex1_ping_pong/ex1_ping_pong.srcs/constrs_1/imports/ping_pong/basys3.xdc}}
set_property used_in_implementation false [get_files {{C:/Users/Misael/Desktop/UNB/7 SEMESTRE/PROJETO DE CIRCUITOS RECONFIGURAVEIS/Lista1/ex1_ping_pong/ex1_ping_pong.srcs/constrs_1/imports/ping_pong/basys3.xdc}}]


synth_design -top ping_pong_rtl -part xc7a35tcpg236-1


write_checkpoint -force -noxdef ping_pong_rtl.dcp

catch { report_utilization -file ping_pong_rtl_utilization_synth.rpt -pb ping_pong_rtl_utilization_synth.pb }
