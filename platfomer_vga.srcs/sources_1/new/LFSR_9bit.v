module LFSR_9Bit(
    input clk, reset,
    output reg [8:0] lfsr = 9'b000000001
    );
    
    always@(posedge clk)
        if(reset)
            lfsr <=  9'b000000001;
        else
            lfsr <= {lfsr[7:0], lfsr[3] ^ lfsr[8]};
endmodule
