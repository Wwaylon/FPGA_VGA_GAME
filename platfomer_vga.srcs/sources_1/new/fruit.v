module fruit(
    input clk, en, reset, refresh_tick,
    input first_fruit,
    input collision,
    input [9:0] y_a, y_b, y_c,   
    output reg [9:0] x, y,  // Outputs for the current fruit position
    output reg [9:0] score
    );
    reg [9:0] x_pos;
    reg [9:0] y_pos;
    reg first_run;
    wire [8:0] rng;
    
    // LFSR for random number generation
    LFSR_9Bit lfsr_inst (
        .clk(clk),
        .reset(reset),
        .lfsr(rng)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y_pos <= 480;
            x_pos <= 0;
            first_run <= 1;
            score <= 0;
        end else if (en) begin
            if ((first_run && y_a == (110)) || first_fruit) begin
                first_run <= 0;
            end
            if (y_pos >= 480 && first_run == 0 && (y_a >= 110 && y_b >= 110 && y_c >= 110)) begin
                y_pos <= 0;
                //x_pos <= (prev_x >= (rng - 75) && prev_x <= (rng + 75)) ?  
                         //(prev_x < 320 ? (prev_x + 150) : (prev_x - 150)) : rng;
                x_pos <= rng;
            end
            else if(collision) begin
                y_pos <= 480;
                x_pos <= rng;
                score <= score+1;
            end 
            else if (refresh_tick && y_pos < 480) begin
                y_pos <= y_pos + 1; // Increment position based on speed
            end
        end
    end

    // Output assignments
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x <= 0;
            y <= 480;
        end else begin
            x <= x_pos;
            y <= y_pos;
        end
    end
endmodule