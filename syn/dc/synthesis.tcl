#####################################################
###   Compile Script for Synopsys                  ##
###   csh run			 	           ##
#####################################################
################################################################# 
#    setup global variables
################################################################# 
set	ProjHomePath /home/IC/SIMPLE_RISC_CPU
set DesignTopName RISC_CPU
#################################################################
#   BEGIN PROJECT COMMON VARIABLES SETTING
#################################################################
set ProjRTLPath     /home/IC/SIMPLE_RISC_CPU/rtl
set ProjSYNPath     /home/IC/SIMPLE_RISC_CPU/syn

set	DesignWarePath	/opt/Synopsys/Synplify2015/libraries/syn
#####################################################
#set	TestReadySyn	true
set	ClockGatingSyn	ture

set 	hdlin_work_directory 			./temp/
define_design_lib DEFAULT -path 		./temp/

######################################################
#    SYNTHESIS LIBRARY VARIABLES DEFINE
######################################################
set target_library      "../../lib/scc28nhkcp_hsc35p140_rvt_ss_v0p81_125c_basic.db"

set synthetic_library [list \
                  dw_foundation.sldb ]

set link_library [list * ../../lib/scc28nhkcp_hsc35p140_rvt_ss_v0p81_125c_basic.db ]

#################################################################
#    read in project verilog source code
#################################################################
set RTLFileList [exec cat ./dc_filelist.f]
	foreach rtlfile $RTLFileList {
      			analyze -f verilog  $rtlfile
 	}

#analyze -f verilog  $RTL_files

elaborate $DesignTopName 
	
current_design 	$DesignTopName

 link
 uniquify

set_svf ./work/$DesignTopName.svf
#################################################################
#    constant 
#################################################################

	create_clock -name clk [get_port clk] -period  5.0 -waveform {0 2.5}
	set_clock_uncertainty -setup 0.15  [get_clocks clk]
	set_clock_uncertainty -hold  0.05  [get_clocks clk]
	set_dont_touch_network		   [get_clocks clk]
#	set_ideal_network 		   [get_ports clk]
#################################################################
#    input_delay output_delay and  load
#################################################################
set   CLK_NAME	     clk  
set   ALL_IN_EXCEPT_CLK [remove_from_collection [all_inputs] [get_ports "$CLK_NAME"]]
set_input_delay        1.5   -clock  $CLK_NAME     $ALL_IN_EXCEPT_CLK

set_output_delay       0.75  -clock $CLK_NAME [all_outputs]

set_load       1     [all_inputs]
set_load       1     [all_outputs]
set_load  -min 0.5   [all_inputs]
set_load  -min 0.5   [all_outputs]    

###########################################################
# Set DRC constraint
###########################################################
	set_max_transition 	0.2 	[current_design]
	set_max_fanout 		20 	[current_design]
	set_max_capacitance 	2	[current_design]


    set verilogout_no_tri true
	set_fix_multiple_port_nets -all  -buffer_constants
	set_auto_disable_drc_nets -clock true -constant true
	
	current_design	$DesignTopName
	link

	compile	 -map medium

#################################################################
#    set library and synthesis variables
#################################################################

	write 		-f verilog	-hier 	-output ./work/$DesignTopName.v
	write_sdc  					./work/$DesignTopName.sdc
	write_sdf					./work/$DesignTopName.sdf

    set_svf -off
    
	report_constraint -all 
	report_timing
#################################################################
#    set library and synthesis variables
#################################################################

	redirect [file join ./rpts reportdesign.rpt] 		{ report_design }
        redirect [file join ./rpts reportcell.rpt]    		{ report_cell   }
        redirect [file join ./rpts reportarea.rpt]    		{ report_area   }
        redirect [file join ./rpts reportQOR.rpt]     		{ report_qor    }
	redirect [file join ./rpts reportcheckdesign.rpt]  	{ check_design  }
        redirect [file join ./rpts reporttiming.rpt]    	{ check_timing  }
        redirect [file join ./rpts reportconstraint.rpt]        { report_constraint -all_violators}
        redirect [file join ./rpts reporttimingmax.rpt]         { report_timing -delay_type max   }
	redirect [file join ./rpts reporttimingmin.rpt]    	{ report_timing -delay_type min   }
###############################################################
quit
#################################################################
	

