module fsm (
    input       clk,
    input       ena,
    input       zero,
    input [2:0] opcode,
    output reg  inc_pc,
                load_acc,
                load_pc,
                rd,
                wr,
                load_ir,
                halt,
                data_ctl_ena
);
//------------Param Define---------------//
parameter HLT  = 3'b000,    //halt
          SKZ  = 3'b001,    //skip if zero
          ADD  = 3'b010,    //addition
          ANDD = 3'b011,    //logic and
          XORR = 3'b100,    //logic xor
          LDA  = 3'b101,    //load accumulator
          STO  = 3'b110,    //store accumulator
          JMP  = 3'b111;    //jump
//------------Reg/Wire Define------------//
reg [2:0] state;

//------------Main Code------------------//
always @(posedge clk) begin
    if (!ena) begin
        state <= 3'b000;
        {inc_pc,load_acc,load_pc,rd} <= 4'b0000;
        {wr,load_ir,halt,data_ctl_ena} <= 4'b0000;
    end
    else begin
        ctl_cycle;
        state <= state + 1'b1;
    end
end

//task: ctl_cycle
task ctl_cycle;
begin
    casex (state)
        3'b000 : begin   // load high 8 bits of instruction
            {inc_pc,load_acc,load_pc,rd}   <= 4'b0001;
            {wr,load_ir,halt,data_ctl_ena} <= 4'b0100;
        end 
        3'b001 : begin   // inc_pc =1  load low 8bits of instruction
            {inc_pc,load_acc,load_pc,rd}   <= 4'b1001;
            {wr,load_ir,halt,data_ctl_ena} <= 4'b0100;
        end 
        3'b010 : begin   // idle do nothing
            {inc_pc,load_acc,load_pc,rd}   <= 4'b0000;
            {wr,load_ir,halt,data_ctl_ena} <= 4'b0000;
        end 
        3'b011 : begin   // decode the instruction
            if (opcode == HLT) begin
                {inc_pc,load_acc,load_pc,rd}   <= 4'b1000;
                {wr,load_ir,halt,data_ctl_ena} <= 4'b0010;
            end
            else begin
                {inc_pc,load_acc,load_pc,rd}   <= 4'b1000;
                {wr,load_ir,halt,data_ctl_ena} <= 4'b0000;
            end
        end
        3'b100 : begin    //decode the instruction
            if (opcode == ADD || opcode == ANDD 
                || opcode == XORR || opcode == LDA) begin
                {inc_pc,load_acc,load_pc,rd}   <= 4'b0001;
                {wr,load_ir,halt,data_ctl_ena} <= 4'b0000;
            end
            else if (opcode == JMP) begin
                {inc_pc,load_acc,load_pc,rd}   <= 4'b0010;
                {wr,load_ir,halt,data_ctl_ena} <= 4'b0000;
            end
            else if (opcode == STO) begin
                {inc_pc,load_acc,load_pc,rd}   <= 4'b0000;
                {wr,load_ir,halt,data_ctl_ena} <= 4'b0001;
            end
            else begin
                {inc_pc,load_acc,load_pc,rd}   <= 4'b0000;
                {wr,load_ir,halt,data_ctl_ena} <= 4'b0000;
            end
        end 
        3'b101 : begin     //operate
            if (opcode == ADD || opcode == ANDD 
                || opcode == XORR || opcode == LDA) begin
                {inc_pc,load_acc,load_pc,rd}   <= 4'b0101;
                {wr,load_ir,halt,data_ctl_ena} <= 4'b0000;
            end
            else if (opcode == SKZ && zero == 1) begin
                {inc_pc,load_acc,load_pc,rd}   <= 4'b1000;
                {wr,load_ir,halt,data_ctl_ena} <= 4'b0000;
            end
            else if (opcode == JMP) begin
                {inc_pc,load_acc,load_pc,rd}   <= 4'b1010;
                {wr,load_ir,halt,data_ctl_ena} <= 4'b0000;
            end
            else if (opcode == STO) begin
                {inc_pc,load_acc,load_pc,rd}   <= 4'b0000;
                {wr,load_ir,halt,data_ctl_ena} <= 4'b1001;
            end
            else begin
                {inc_pc,load_acc,load_pc,rd}   <= 4'b0000;
                {wr,load_ir,halt,data_ctl_ena} <= 4'b0000;
            end
        end
        3'b110 : begin
            if (opcode == ADD || opcode == ANDD 
                || opcode == XORR || opcode == LDA) begin
                {inc_pc,load_acc,load_pc,rd}   <= 4'b0001;
                {wr,load_ir,halt,data_ctl_ena} <= 4'b0000;
            end
            else if (opcode == STO) begin
                {inc_pc,load_acc,load_pc,rd}   <= 4'b0000;
                {wr,load_ir,halt,data_ctl_ena} <= 4'b0001;
            end
            else begin
                {inc_pc,load_acc,load_pc,rd}   <= 4'b0000;
                {wr,load_ir,halt,data_ctl_ena} <= 4'b0000;
            end
        end
        3'b111 : begin
            if (opcode == SKZ && zero == 1) begin
                {inc_pc,load_acc,load_pc,rd}   <= 4'b1000;
                {wr,load_ir,halt,data_ctl_ena} <= 4'b0000;
            end
            else begin
                {inc_pc,load_acc,load_pc,rd}   <= 4'b0000;
                {wr,load_ir,halt,data_ctl_ena} <= 4'b0000;
            end
        end
        default : begin
            {inc_pc,load_acc,load_pc,rd}   <= 4'b0000;
            {wr,load_ir,halt,data_ctl_ena} <= 4'b0000;
        end
    endcase
end
endtask
endmodule