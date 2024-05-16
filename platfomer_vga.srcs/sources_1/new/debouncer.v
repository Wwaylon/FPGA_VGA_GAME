module debounce
#(
    parameter MAX_COUNT = 10
)
(
    input wire clk,
    input wire in,    // Synchronous and noisy input.
    output reg out,   // Debounced and filtered output.
    output reg edj,   // Goes high for 1 clock cycle on either edge of output. Note: used "edj" because "edge" is a keyword.
    output reg rise,  // Goes high for 1 clock cycle on the rising edge of output.
    output reg fall   // Goes high for 1 clock cycle on the falling edge of output.
);

    localparam COUNTER_BITS = 21;

    reg [COUNTER_BITS - 1 : 0] counter;
    wire w_edj;
    wire w_rise;
    wire w_fall;

    initial
    begin
        counter = 0;
        out = 0;
    end

    always @(posedge clk)
    begin
        edj <= 0;
        rise <= 0;
        fall <= 0;
        if (counter == MAX_COUNT - 1)  // If successfully debounced, notify what happened.
        begin
            out <= in;
            edj <= w_edj;    // Goes high for 1 clock cycle on either edge.
            rise <= w_rise;  // Goes high for 1 clock cycle on the rising edge.
            fall <= w_fall;  // Goes high for 1 clock cycle on the falling edge.
            counter <= 0;
        end
        else if (in != out)  // Hysteresis.
        begin
            counter <= counter + 1;  // Only increment when input and output differ.
        end
    end

    // Edge detect.
    assign w_edj = in ^ out;
    assign w_rise = in & ~out;
    assign w_fall = ~in & out;

endmodule