module program_counter (
    input             clk,
    input             rst,
    input             load_pc,
    input      [12:0] ir_addr,
    output reg [12:0] pc_addr
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc_addr <= 13'd0;
    end
    else begin
        if (load_pc) begin
            pc_addr <= ir_addr;
        end
        else begin
            pc_addr <= pc_addr + 1;
        end
    end
end

endmodule