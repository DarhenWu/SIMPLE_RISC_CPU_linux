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
