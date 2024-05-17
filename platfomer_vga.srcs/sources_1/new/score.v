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
    
    wire [15:0] bcd;
    
    bin2bcd bin2bcd_unit(
        .bin(score),
        .bcd(bcd)
    );  
    
    always@(*)
    begin
        score_on <= 0;
		row <= 0;
		col <= 0;
        if(x>= 576 && x< 592 && y>= 16 && y <32)
        begin
            col <= x-576;
            row <= (y-16) + (bcd[15:12]*16);
            if(color_data == 1'b0)
            begin
                score_on <=1;
            end
        end
        else if(x>= 592 && x< 608 && y>= 16 && y <32)
        begin
            col <= x-592;
            row <= (y-16) + (bcd[11:8]*16);
            if(color_data == 1'b0)
            begin
                score_on <=1;
            end
        end
        else if(x>= 608 && x< 624 && y>= 16 && y <32)
        begin
            col <= x-608;
            row <= (y-16) + (bcd[7:4]*16);
            if(color_data == 1'b0)
            begin
                score_on <=1;
            end
        end
        else if(x>= 624 && x< 640 && y>= 16 && y <32)
        begin
            col <= x-624;
            row <= (y-16) + (bcd[3:0]*16);
            if(color_data == 1'b0)
            begin
                score_on <=1;
            end
        end
        
    end
endmodule
