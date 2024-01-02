module data_control (
    input [7:0]  alu_out,
    input        data_ctl_ena,
    output [7:0] data_out
);
    
assign data_out = data_ctl_ena ? alu_out : 8'bzzzzzzzz;

endmodule