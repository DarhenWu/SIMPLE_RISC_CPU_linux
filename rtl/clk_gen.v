module clk_gen (
    input          clk,
    input          reset,
    output  reg    fetch,
    output  reg    alu_ena
);
//------------Reg/Wire Define-------------//
reg [7:0] state,next_state;

//------------FSM-------------------------//
parameter IDLE  =  8'b00000000;
parameter S1    =  8'b00000001;
parameter S2    =  8'b00000010;
parameter S3    =  8'b00000100;
parameter S4    =  8'b00001000;
parameter S5    =  8'b00010000;
parameter S6    =  8'b00100000;
parameter S7    =  8'b01000000;
parameter S8    =  8'b10000000;
//state transition logic
always @(*) begin
    case (state)
        IDLE: next_state = S1; 
        S1  : next_state = S2; 
        S2  : next_state = S3; 
        S3  : next_state = S4; 
        S4  : next_state = S5; 
        S5  : next_state = S6; 
        S6  : next_state = S7; 
        S7  : next_state = S8; 
        S8  : next_state = S1; 
        default: next_state = IDLE;
    endcase
end
//state filpflop
always @(negedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
  end 
  else begin
    state <= next_state;
  end
end

//set output 
always @(negedge clk or posedge reset) begin
    if (reset) begin
        alu_ena <= 1'b0;
        fetch <= 1'b0;
    end
    else begin
        case (state)
            S1: alu_ena <= 1'b1;
            S2: alu_ena <= 1'b0; 
            S3: fetch <= 1'b1;
            S7: fetch <= 1'b0;
        endcase
    end
end

endmodule
