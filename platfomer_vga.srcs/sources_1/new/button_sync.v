module button_sync
#(
    parameter SYNC_BITS = 3  // Number of bits in the synchronisation buffer (2 minimum).
)
(
    input wire clk,
    input wire in,     // Asynchronous input.
    output wire out    // Synchronous output.
);

    localparam SYNC_MSB = SYNC_BITS - 1;

    reg [SYNC_MSB : 0] sync_buffer;

    assign out = sync_buffer[SYNC_MSB];

    always @(posedge clk)
    begin
        sync_buffer[SYNC_MSB : 0] <= {sync_buffer[SYNC_MSB - 1 : 0], in};
    end

endmodule