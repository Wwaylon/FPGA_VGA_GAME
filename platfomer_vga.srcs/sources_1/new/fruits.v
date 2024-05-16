module fruits(
    input clk, en, reset, 
    input [9:0] x,y,
    output wire [11:0] fruit_color,
    output wire fruit_on
);

    wire refresh_tick;
    assign refresh_tick = ((y == 481) && (x == 0)) ? 1 : 0; // start of vsync(vertical retrace)
    wire [9:0] f1_pos_x, f1_pos_y; 
    wire [9:0] f2_pos_x, f2_pos_y;
    wire [9:0] f3_pos_x, f3_pos_y;
    
    reg [5:0] grape_row;
    reg [5:0] grape_col;
    wire [11:0] grape_color_data;
    grape_rom grape_rom(
       .clk(clk),
       .row(grape_row),
       .col(grape_col),
       .color_data(grape_color_data)
    );
    reg [5:0] strawberry_row;
    reg [5:0] strawberry_col;
    wire [11:0] strawberry_color_data;
    strawberry_rom strawberry_rom(
       .clk(clk),
       .row(strawberry_row),
       .col(strawberry_col),
       .color_data(strawberry_color_data)
    );
    reg [5:0] cherry_row;
    reg [5:0] cherry_col;
    wire [11:0] cherry_color_data;
    cherry_rom cherry_rom(
       .clk(clk),
       .row(cherry_row),
       .col(cherry_col),
       .color_data(cherry_color_data)
    );
    
    assign fruit_on = (x>= f1_pos_x && x<f1_pos_x +50 && y>= f1_pos_y && y< f1_pos_y+50) 
                        || (x>= f2_pos_x && x<f2_pos_x +50 && y>= f2_pos_y && y< f2_pos_y+50)
                        || (x>= f3_pos_x && x<f3_pos_x +50 && y>= f3_pos_y && y< f3_pos_y+50);
    assign fruit_color= (x>= f1_pos_x && x<f1_pos_x +50 && y>= f1_pos_y && y< f1_pos_y+50) ? grape_color_data: 
                        (x>= f2_pos_x && x<f2_pos_x +50 && y>= f2_pos_y && y< f2_pos_y+50) ? strawberry_color_data:
                        (x>= f3_pos_x && x<f3_pos_x +50 && y>= f3_pos_y && y< f3_pos_y+50) ? cherry_color_data: 12'h000;
    
    fruit f1(
        .clk(clk),
        .en(en),
        .reset(reset),
        .refresh_tick(refresh_tick),
        .order(3'b000),
        .distance(0),
        .prev_x(50),
        .x(f1_pos_x),
        .y(f1_pos_y)
    );
    fruit f2(
        .clk(clk),
        .en(en),
        .reset(reset),
        .refresh_tick(refresh_tick),
        .order(3'b001),
        .distance(f1_pos_y),
        .prev_x(f1_pos_x),
        .x(f2_pos_x),
        .y(f2_pos_y)
    );
    fruit f3(
        .clk(clk),
        .en(en),
        .reset(reset),
        .refresh_tick(refresh_tick),
        .order(3'b010),
        .distance(f2_pos_y),
        .prev_x(f2_pos_x),
        .x(f3_pos_x),
        .y(f3_pos_y)
    );
    
    always@(*)
    begin
        cherry_row <=0;
        cherry_col <=0;
        strawberry_row <= 0;
        strawberry_col <= 0;
        grape_row <= 0;
        grape_col <= 0;
        if(x>= f1_pos_x && x<f1_pos_x +50 && y>= f1_pos_y && y< f1_pos_y+50)
        begin
            grape_col <= x-f1_pos_x;
            grape_row <= (y-f1_pos_y);
        end
        else if(x>= f2_pos_x && x<f2_pos_x +50 && y>= f2_pos_y && y< f2_pos_y+50)
        begin
            strawberry_col <= x-f2_pos_x;
            strawberry_row <= (y-f2_pos_y);
        end
        else if(x>= f3_pos_x && x<f3_pos_x +50 && y>= f3_pos_y && y< f3_pos_y+50)
        begin
            cherry_col <= x-f3_pos_x;
            cherry_row <= (y-f3_pos_y);
        end
    end

endmodule
