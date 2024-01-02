module RISC_CPU (
    input         clk,
    input         reset,
    inout  [7:0]  data,
    output        rd,wr,halt,
    output [2:0]  opcode,
    output [12:0] addr,
    output        fetch,
    output [12:0] ir_addr,pc_addr
);
//-------------Wire Define------------//
wire alu_ena;
wire inc_pc,load_acc,load_pc;
wire load_ir,data_ctl_ena;
wire [7:0] accum;
wire zero;
wire [7:0] alu_out;
wire fsm_ena;
//-------------Main Code--------------//
clk_gen u_clk_gen (
    .clk(clk),
    .reset(reset),
    .fetch(fetch),
    .alu_ena(alu_ena)
);

accum u_accum (
    .clk(~clk),
    .rst(reset),
    .ena(load_acc),
    .data(alu_out),
    .accum(accum)
);

addr_mux u_addr_mux(
    .fetch(fetch),
    .pc_addr(pc_addr),
    .ir_addr(ir_addr),
    .addr(addr)
);

alu u_alu(
    .alu_ena(alu_ena),
    .opcode(opcode),
    .data(data),
    .accum(accum),
    .zero(zero),
    .alu_out(alu_out)
);

fsm_ctrl u_fsm_ctrl(
    .clk(clk),
    .rst(reset),
    .fetch(fetch),
    .ena(fsm_ena)
);

fsm u_fsm(
    .clk(clk),
    .ena(fsm_ena),
    .zero(zero),
    .opcode(opcode),
    .inc_pc(inc_pc),
    .load_acc(load_acc),
    .load_pc(load_pc),
    .rd(rd),
    .wr(wr),
    .load_ir(load_ir),
    .halt(halt),
    .data_ctl_ena(data_ctl_ena)
);

program_counter u_program_counter(
    .clk(inc_pc),
    .rst(reset),
    .load_pc(load_pc),
    .ir_addr(ir_addr),
    .pc_addr(pc_addr)
);

instr_register u_instr_register(
    .clk(~clk),
    .rst(reset),
    .ena(load_ir),
    .data(data),
    .opc_iraddrs({opcode,ir_addr})
);

data_control u_data_control(
    .alu_out(alu_out),
    .data_ctl_ena(data_ctl_ena),
    .data_out(data)
);

endmodule
