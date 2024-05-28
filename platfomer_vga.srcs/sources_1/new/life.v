module life(
    input clk, reset, damage,
    input [9:0] x, y,
    output reg [2:0] life_on,
    output wire game_over
    );

    reg [3:0] row, col;
    wire color_data;

    reg [2:0] life_reg;
    reg damage_processed;

    heart_rom heart_rom_unit(
        .clk(clk),
        .row(row),
        .col(col),
        .color_data(color_data)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            life_reg <= 3'b111;
            damage_processed <= 0;
        end
        else if (damage && !damage_processed) begin
            if (life_reg != 0) begin
                life_reg <= life_reg >> 1;
            end
            damage_processed <= 1;
        end
        else if (!damage) begin
            damage_processed <= 0;
        end
    end

    always@(*) begin
        row <= 0;
        col <= 0;
        life_on <= 0;
        if(x>=5 && x< 21 && y>=16 && y<32) begin
            col <= x-5;
            row <= y-16;
            if(color_data <= 1'b0 && life_reg[0] == 1) begin
                life_on[0] <= 1;
            end
        end
        else if(x>=21 && x< 37 && y>=16 && y<32) begin
            col <= x-21;
            row <= y-16;
            if(color_data <= 1'b0 && life_reg[1] == 1) begin
                life_on[1] <= 1;
            end
        end
        else if(x>=37 && x< 53 && y>=16 && y<32) begin
            col <= x-37;
            row <= y-16;
            if(color_data <= 1'b0 && life_reg[2] == 1) begin
                life_on[2] <= 1;
            end
        end
    end

    assign game_over = (life_reg == 0);

endmodule