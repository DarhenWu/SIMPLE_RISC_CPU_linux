module addr_decoder (
    input       [12:0]  addr,
    output  reg         rom_sel,
    output  reg         ram_sel
);

always @(*) begin
    casex (addr)
        13'b1_1xxx_xxxx_xxxx : {rom_sel , ram_sel} = 2'b01 ; //ram: 1fffh-1800h
        13'b1_0xxx_xxxx_xxxx : {rom_sel , ram_sel} = 2'b10 ; //rom: 17ffh-0000h
        13'b0_xxxx_xxxx_xxxx : {rom_sel , ram_sel} = 2'b10 ;    
    endcase
end
    
endmodule