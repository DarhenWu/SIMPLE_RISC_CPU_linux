module alu (
    input            alu_ena,
    input      [2:0] opcode,
    input      [7:0] data,
    input      [7:0] accum,
    output           zero,
    output reg [7:0] alu_out
);

parameter HLT  = 3'b000,    //halt
          SKZ  = 3'b001,    //skip if zero
          ADD  = 3'b010,    //addition
          ANDD = 3'b011,    //logic and
          XORR = 3'b100,    //logic xor
          LDA  = 3'b101,    //load accumulator
          STO  = 3'b110,    //store accumulator
          JMP  = 3'b111;    //jump

always @(posedge alu_ena) begin
    casex (opcode)
        HLT : alu_out <= accum; 
        SKZ : alu_out <= accum;
        ADD : alu_out <= data + accum;
        ANDD: alu_out <= data & accum;
        XORR: alu_out <= data ^ accum;
        LDA : alu_out <= data;
        STO : alu_out <= accum;
        JMP : alu_out <= accum;
    endcase
end
assign zero = !accum;
endmodule