# 简单的RISC CPU

​																	_按照 夏宇闻 《Verilog数字系统设计教程》第17章内容设计,参考https://github.com/CJH8668/risc_cpu_

##  0.工程结构

```
/RISC_CPU_linux
│  
├─bench
│      addr_decoder.v
│      memory.v
│      tb_RISC_CPU.v
│      
├─lib
│      scc28nhkcp_hsc35p140_rvt.v
│      scc28nhkcp_hsc35p140_rvt_ss_v0p81_125c_basic.db
│      
├─post_sim
│      Makefile
│      post_filelist.f
│      
├─pre_sim
│      Makefile
│      pre_filelist.f
│      
├─rtl
│      accum.v
│      addr_mux.v
│      alu.v
│      clk_gen.v
│      data_control.v
│      fsm.v
│      fsm_ctrl.v
│      instr_register.v
│      program_counter.v
│      RISC_CPU.v
│      
├─syn
│  ├─dc
│  │      dc_filelist.f
│  │      run
│  │      synthesis.tcl
│  │      
│  └─fm
│      │  fm.tcl
│      │  
│      └─log
└─test
        test1.dat
        test1.pro
        test2.dat
        test2.pro
        test3.dat
        test3.pro
```

* bench - 存放tb文件

* lib - 存放基本单元库文件

* post_sim - 存放DC综合后仿真所需脚本

* pre_sim - 存放功能仿真所需脚本

* rtl - 存放设计文件，顶层为RISC_CPU.v

* syn - 存放dc综合和fm形式验证所需脚本

## 1.  使用指南

### 1.1 设计代码与tb文件

​	设计要求与思路详见书上第17章或onenote笔记。

 * memory里分为ram和rom两个模块

 * tb_RISC_CPU -  读入test中的测试输入

 * test - .pro文件存放指令，.dat文件存放数据

### 1.2 前仿（功能仿真）

​	在pre_sim文件夹内打开指令行，键入 make com进行编译，再键入 make sim 进行仿真。

​	仿真后在当前目录下生成 .fsdb文件，键入 make verdi 即可打开Verdi 查看波形结果。

(makefile文件中 LIB_FILE可根据需求更换为其他库文件，VCS指令参数配置中需更改 novas.tab 和 pli.a文件的路径)

### 1.3 DC综合

​	进入 syn - dc文件夹下，存放三个脚本文件。打开终端，键入csh run开始DC综合，综合结束后会在当前目录下生成三个文件夹，

分别为work（DC综合输入网表，.v / .sdc / .sdf / .svf文件），rpts（存放时序报告，功耗报告，面积报告等等），temp（存放综合过程中产生的临时文件）。

​	synthesis.log存放DC综合结果的日志文件，记录综合的详细过程。

​	（打开synthsis.tcl脚本文件，需要修改的路径有：ProHomePath、ProRTLPath、ProjSYNPath，可修改为本地存放路径）

### 1.4后仿（门级网表仿真）

​	门级网表仿真依旧使用bench文件夹下的文件作为测试输入，但取代rtl文件的是dc综合后work文件夹下的*.v文件，对反映了利用工艺库中的基本组合元件生成项目所需的功能模块之间的连接关系。可以对这个门级网表进行时序仿真，以验证综合后网表实现的功能与RTL级的功能是一致的。

	* 打开post_sim文件夹，打开makefile文件，进行以下设置：（以设置完毕）

```
1）在ALL_DEFINE添加NET_SIM宏开关，用于testbench中代码块的打开和关闭；

2）添加LIB_FILE = -v  ".v工艺库路径"；

3) 在#compile command中选用门级网表作为仿真文件（-f ./post_filelist.f）；

4）在#start verdi中选用 # netlist simulation的相应选项；
```

	* 在tb中添加 .sdf反标注文件

```
  initial begin       
  `ifdef NET_SIM
      $sdf_annotate("/home/IC/SIMPLE_RISC_CPU/syn/dc/work/cpu.sdf",RISC_CPU,"TYPICAL","1:1:1","FROM_MTM");
  `endif
  end
```

	* 与前仿一致，打开终端键入 make com，make sim进行编译仿真，post_filelist.f中已经存放综合生成的网表路径。
	* make verdi可查看波形

### 1.5 fm形式验证

​	打开 syn - fm文件夹，fm.tcl为使用formality进行形式验证的脚本文件，log文件夹中存放形式验证结果。

	* 在当前目录打开终端，键入 fm_shell -file fm.tcl 即可进行形式验证。
	* 查看log文件夹下的几个 .info文件，若全部都为Passing compare points，无failing compare points和aborted compare points，则形式验证通过。