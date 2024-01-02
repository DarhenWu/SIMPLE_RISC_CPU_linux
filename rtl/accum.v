module accum (
    input            clk,
    input            rst,
    input            ena,
    input      [7:0] data,
    output reg [7:0] accum
);
always @(posedge clk or posedge rst) begin
    if (rst) begin
        accum <= 8'd0;
    end  
    else begin
        if (ena) begin
            accum <= data;
        end
    end
end  
endmodule