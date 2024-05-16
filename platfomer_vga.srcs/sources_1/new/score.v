module score(
    input clk,
    input [9:0] x, y, 
    input [13:0] score,
    output reg score_on
    );
    //signals and wires
    reg [7:0] row;
	reg [3:0] col;
    wire color_data;
    reg score_on;
    
    //infer numbers ROM 
    numbers_rom numbers_rom_unit(
        .clk(clk),
        .row(row),
        .col(col),
        .color_data(color_data)
    );
    
    always@(*)
    begin
        score_on <= 0;
		row <= 0;
		col <= 0;
        if(x>= 336 && x< 352 && y>= 16 && y <32)
        begin
            col <= x-336;
            row <= (y-16) + (9*16);
            if(color_data == 1'b0)
            begin
                score_on <=1;
            end
        end
    end
endmodule
