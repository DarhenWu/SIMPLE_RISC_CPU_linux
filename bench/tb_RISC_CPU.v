`timescale 1ns/1ns
`define PERIOD 100
module tb_RISC_CPU;
reg                reset_req;
reg                clock;//时钟周期100ns
integer            test;
reg [(3 * 8)-1:0]    mnemonic; // 3 个8bit ASCII码
reg [12:0]         PC_addr ,IR_addr;
wire [7:0]         data;
wire [12:0]        addr;
wire               rd, wr,halt,ram_sel,rom_sel;
wire [2:0]         opcode;
wire               fetch;
wire [12:0]        ir_addr, pc_addr;

//----------------------CPU模块与地址译码器和ROM，RAM的连接部分
RISC_CPU 
t_cpu(
   .clk          (clock        ),
   .reset        (reset_req    ),
   .halt         (halt         ),
   .rd           (rd           ),
   .wr           (wr           ),
   .addr         (addr         ),//读/写RAM，读ROM地址，取低10位
   .data         (data         ),
   .opcode       (opcode       ),
   .fetch        (fetch        ), 
   .ir_addr      (ir_addr      ),
   .pc_addr      (pc_addr      )
);

//可读写 需要参与运算的数据
ram 
t_ram(
   .addr         (addr[9:0]    ),//读/写RAM地址
   .read         (rd           ),
   .write        (wr           ),
   .ena          (ram_sel      ),
   .data         (data         )
);

//可读 汇编机器码
rom 
t_rom(
   .addr         (addr         ),//读ROM地址
   .read         (rd           ),
   .ena          (rom_sel      ),
   .data_o       (data         )
);

//根据地址产生选通信号，选通ROM或者RAM
addr_decoder 
t_addr_decoder(
   .addr         (addr         ),
   .ram_sel      (ram_sel      ),
   .rom_sel      (rom_sel      )
);

initial begin
  clock=1;
  $timeformat (-9, 1, "ns",  12);//定义仿真时间的打印格式，配合$display,$stobe等使用
  // $strobe("%t: \$strobe time", $time);
  display_debug_message;
  sys_reset;
  test1;
  $stop;
  test2;
  $stop;
  test3;
  $finish;
end

//打印以下字符串
task display_debug_message;
  begin
    $display("\n*********************************");
    $display("*   THE FOLLOWING DEBUG TASK ARE AVAILABLE: *"); 
    $display("*  \"testl;\" to load the 1st diagnostic progran. * ");
    $display("*  \"test2;\" to load the 2nd diagnostic program. *");
    $display("*  \"test3;\" to load the Fibonacci program.    *");
    $display(" **********************************\n");
  end
endtask

/*将test1.pro，test1.dat文件数据分别读入rom和ram中，延迟1ns,test=1
延迟14800ns，重设reset信号
*/
task test1;
  begin
    test = 0;
    disable MONITOR;
	$readmemb("../test/test1.pro",t_rom.rom); 
	$display("rom loaded  successfully!"); 
	$readmemb("../test/test1.dat",t_ram.ram); 
	$display("ram loaded  successfully!"); 
	#1 test = 1;
    #14800 ;
	sys_reset;
  end
endtask


task test2;
  begin
    test = 0;
    disable MONITOR;
	$readmemb("../test/test2.pro",t_rom.rom); 
	$display("rom loaded  successfully!"); 
	$readmemb("../test/test2.dat",t_ram.ram); 
	$display("ram loaded  successfully!"); 
	#1 test = 2;
    #11600;
    sys_reset;
  end
endtask

task test3;
  begin
    test = 0;
    disable MONITOR;
	$readmemb("../test/test3.pro",t_rom.rom); 
	$display("rom loaded  successfully!"); 
	$readmemb("../test/test3.dat",t_ram.ram); 
	$display("ram loaded  successfully!"); 
	#1 test = 3;
    #94000;
    sys_reset;
  end
endtask

//设置系统复位信号，高有效
task sys_reset;
  begin
  reset_req = 0;
  #(`PERIOD*0.7) reset_req = 1; 
  #(1.5*`PERIOD) reset_req = 0; 
  end
endtask

//打印输出当前时间，PC指令地址，ir_addr，操作码，数据
always @(test)begin: MONITOR
  case (test)
     1: begin   //display results when running test 1
        $display("\n***RUNNING CPUtes1 - The Basic CPU Diagnostic Program ***");
		$display("\n      TIME      PC     INSTR      ADDR      DATA    ");
        $display("     --------  -----  ----------  -----   ---------");   
        while (test == 1)
            @(t_cpu.pc_addr)//fixed
            if((t_cpu.pc_addr%2 == 1)&&(t_cpu.fetch == 1))//fixed
            begin
               #60 PC_addr <= t_cpu.pc_addr - 1;
                   IR_addr <= t_cpu.ir_addr;
               #340 $strobe("%t   %h   %s     %h   %h", $time, PC_addr,mnemonic,IR_addr,data);
                    //HERE DATA HAS BEEN CHANGED T-CPU-M-REGISTER.DATA
            end
        end
     2: begin   
        $display("\n***RUNNING CPUtest2 The Advancd CPU Diagnosic Program ***");
		$display("\n      TIME      PC     INSTR      ADDR      DATA    ");
        $display("     --------  -----  ----------  -----   ---------");   
        while (test == 2)
            @(t_cpu.pc_addr)//fixed
            if((t_cpu.pc_addr%2 == 1)&&(t_cpu.fetch == 1))
            begin
               #60 PC_addr <= t_cpu.pc_addr - 1;
                   IR_addr <= t_cpu.ir_addr;
               # 340 $strobe("%t   %h   %s     %h   %h", $time, PC_addr,mnemonic,IR_addr,data);
            end
        end
     3: begin   
        $display("\n***RUNNING CPUtest3 - An Executable Program ***");
		$display(" * * *  This program should calculate the fibonacci   * * *");
		$display("\n     TIME      FIBONACCI NUMBER");
        $display("    -------   --------------");   
        while (test == 3)
		    begin
               wait (t_cpu.opcode == 3'h1) //display Fib. No. at end of program loop 
			   //打印输出当前时间 RAM中数据
			   $strobe("%t   %d", $time,t_ram.ram[10'h2]);
               wait (t_cpu.opcode != 3'h1);
            end
        end

  endcase
end

//暂停指令，打印输出
always @(posedge halt)begin //STOP when HALT instruction decoded
    #500
       $display("\n*******************************************");
       $display( " ** A HALT INSTRUCTION WAS PROCESSED !!! **");
       $display( " ****************************************\n");
end

//时钟周期100ns
always #(`PERIOD/2) clock= ~clock;

//cpu操作码的ascii码形式
always @(t_cpu.opcode)
       //get an ASCII mnemonic for each opcode
    case(t_cpu.opcode)
      3'b000 : mnemonic = "HLT";    
      3'b001 : mnemonic = "SKZ";    
      3'b010 : mnemonic = "ADD";    
      3'b011 : mnemonic = "AND";    
      3'b100 : mnemonic = "XOR";
      3'b101 : mnemonic = "LDA";    
      3'b110 : mnemonic = "STO";    
      3'b111 : mnemonic = "JMP";    
      default: mnemonic = "???";
    endcase

 initial begin         // dump .fsdb file
 `ifdef DUMP_FSDB
     $fsdbDumpfile("tb_RISC_CPU.fsdb");
     $fsdbDumpvars(0,tb_RISC_CPU);
     $fsdbDumpon;
 `endif
 end

 initial begin
 `ifdef NET_SIM
     $sdf_annotate("/home/IC/SIMPLE_RISC_CPU/syn/dc/work/cpu.sdf",RISC_CPU,"TYPICAL","1:1:1","FROM_MTM");
 `endif
 end

endmodule
