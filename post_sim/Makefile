# makefile for post simulation
.PHONY:com sim verdi cov debug clean

OUTPUT = RISC_CPU
tbTop = tb_RISC_CPU
ALL_DEFINE = +define+DUMP_VPD	\
			 +define+DUMP_FSDB	\
			 +NET_SIM           #About netlist simulation after DC synthesis
VPD_NAME = +vpdfile+${OUTPUT}.vpd
LIB_FILE = -v ../lib/scc28nhkcp_hsc35p140_rvt.v	 	   #Can be changed

#compile command
VCS = vcs	-sverilog +v2k			\
					-timescale=1ns/1ps 	\
					-full64							\
					-fsdb								\
					-debug_all			    \
					+notimingcheck			\
					+nospecify          \
					-P /opt/Synopsys/Verdi2015/share/PLI/VCS/LINUXAMD64/novas.tab  	\
					/opt/Synopsys/Verdi2015/share/PLI/VCS/LINUXAMD64/pli.a        \
					+vcs+flush+all			\
	  				-debug_pp           \
	  				+vcd+vcdpluson      \
					-f ./post_filelist.f   \
					-o ${OUTPUT}   \
	  				$(ALL_DEFINE)       \
					-cm line+cond+fsm+tgl  \
					$(LIB_FILE)			\
					

#simulation command
SIM = 	./${OUTPUT} 			\
			-l ${OUTPUT}.log 			\
			${VPD_NAME} 			\
			-cm line+cond+fsm+tgl			\

#start compile 
com:
	${VCS}

#start simulation
sim:
	${SIM} 

#start debug command
debug:
	dve -vpd ${OUTPUT}.vpd &

#start verdi
verdi:
	# functional simulation
	# verdi +v2k -sverilog -top ${tbTop} -nologo -f ./pre_filelist.f -ssf tb_RISC_CPU.fsdb &

	# netlist simulation
	 verdi +v2k -sverilog -top ${tbTop} -nologo -f ./post_filelist.f -ssf tb_RISC_CPU.fsdb &

#show the coverage
cov:
	dve -full64 -covdir *vdb &

#clean some file
clean:
	rm -rf ./verdiLog ./novas* ./*.fsdb ./csrc ./*.dat *.daidir ./csrc *.log *.vpd *.vdb simv* *.key *race.out* ${OUTPUT}  DVEfiles
