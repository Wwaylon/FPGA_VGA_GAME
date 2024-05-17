module fruit(
    input clk, en, reset, refresh_tick,
    input [2:0] order,
    input [8:0] distance,  // Distance from the previous fruit
    input [9:0] prev_x,    // X position of the previous fruit
    output reg [9:0] x, y  // Outputs for the current fruit position
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
        end else if (en) begin
            if (y_pos >= 480 && first_run == 0) begin
                y_pos <= 0;
                x_pos <= (prev_x >= (rng - 75) && prev_x <= (rng + 75)) ?  
                         (prev_x < 320 ? (prev_x + 150) : (prev_x - 150)) : rng;
            end else if (refresh_tick) begin
                y_pos <= y_pos + 1; // Increment position based on speed
            end
            if (first_run && distance == (160 * order)) begin
                first_run <= 0;
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