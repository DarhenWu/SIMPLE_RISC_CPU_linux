module ram (
    inout [7:0] data,
    input [9:0] addr,
    input       ena,
    input       read,
    input       write
);

reg [7:0] ram [10'h3ff : 0];

always @(posedge write) begin
    ram[addr] <= data;
end

assign data = (ena && read) ? ram[addr] : 8'hzz;

endmodule

module rom (
    input       [12:0] addr,
    input              read,
    input              ena,
    output      [7:0]  data_o
);

reg [7:0] rom [13'h1ff : 0]; 

assign data_o = (ena && read) ? rom[addr] : 8'hzz;
    
endmodule