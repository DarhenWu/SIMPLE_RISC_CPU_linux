##     fm_shell -file fm.tcl           ##
#########################################
set hdlin_unresolved_modules "black_box"
set verification_failing_point_limit 0

read_db   -libname  tech_lib  -technology_library "/home/IC/SIMPLE_RISC_CPU/lib/scc28nhkcp_hsc35p140_rvt_ss_v0p81_125c_basic.db"

set hdlin_error_on_mismatch_message  false
set hdlin_warn_on_mismatch_message  {FMR_ELAB-147 FMR_ELAB-115}
suppress_message FMR_ELAB-147
# set hdlin_sv_blackbox_modules "sirv_sim_ram"
#set hdlin_verilog_directive_prefixes "synopsys"
# set hdlin_ignore_full_case "false"
# set hdlin_ignore_parallel_case "false"

set_svf  ../dc/work/RISC_CPU.svf
read_verilog -r  -libname design_lib { ../../rtl/RISC_CPU.v \
					../../rtl/accum.v  \
					../../rtl/addr_mux.v  \
					../../rtl/clk_gen.v  \
					../../rtl/data_control.v \
					../../rtl/fsm.v  \
					../../rtl/instr_register.v \
					../../rtl/alu.v  \
					../../rtl/program_counter.v  \
					../../rtl/fsm_ctrl.v}

set_top RISC_CPU

read_verilog -i -libname design_lib [list ../dc/work/*.v  ]

set_top RISC_CPU

set verification_set_undriven_signals synthesis
##The isolation condition has not been considered in the original RTL, need to assume normal function during formality //not needed as no isolation cell has been inserted

match 

report_matched_points > ./log/matched.info

report_unmatched_points > ./log/unmatched.info

verify 

report_passing_points > ./log/verify_passing_points.info

report_failing_points > ./log/verify_failing_points.info

report_aborted_points > ./log/verify_aborted_points.info

quit

