module addr_mux (
    input         fetch,
    input  [12:0] pc_addr,
    input  [12:0] ir_addr,
    output [12:0] addr
);

assign addr = fetch ? pc_addr : ir_addr ;

endmodule