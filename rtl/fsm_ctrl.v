module fsm_ctrl (
    input       clk,
    input       rst,
    input       fetch,
    output reg  ena
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        ena <= 1'b0;
    end
    else begin
        if (fetch) begin
            ena <= 1'b1;
        end
    end
end
    
endmodule
