//instruction register:  
module instr_register (
    input             clk,
    input             rst,
    input             ena,
    input      [7:0]  data,
    output reg [15:0] opc_iraddrs
);
//-------------Reg/Wire Define------------//
reg state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 1'b0;
        opc_iraddrs <= 16'd0;
    end
    else begin
        if (ena) begin
            if (!state) begin
                opc_iraddrs[15:8] <= data;
                state <= 1'b1;
            end
            else if (state) begin
                opc_iraddrs[7:0]  <= data;
                state <= 1'b0;
            end
        end
        else begin
            state <= 1'b0;
        end
    end
end
    
endmodule