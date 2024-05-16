module fruit(
    input clk, en, reset, refresh_tick,
    input [2:0] order,
    input [8:0] distance, //distance from prev fruit
    input [9:0] prev_x, //x of prev fruit
    output [9:0] x, y
);
    reg enable = 0;
    reg y_pos = 480;
    reg x_pos = 0;
    wire [8:0] rng;
    reg [1:0] speed = 1;
    reg first_run = 1;
    
    LFSR_9Bit(
        .clk(clk),
        .reset(reset),
        .lfsr(rng)
    );
    
    always@(*)
    begin
        if(en)begin
            enable <= 1;
        end
        else 
            enable<=0;
        
        if(y == 480 && enable) begin
            y_pos <= 0;
            x_pos <= (prev_x >= (rng-75) && prev_x <=(rng+75)) ?  (prev_x < 320 ? (prev_x+150) : (prev_x-150)) : rng; 
        end
        if(first_run && distance ==(100*order)) begin
            first_run <= 0;
        end
        if(enable && refresh_tick && ~first_run) begin
            y_pos <= y_pos+speed;
        end
    end
    
    assign x = x_pos;
    assign y = y_pos;


endmodule
