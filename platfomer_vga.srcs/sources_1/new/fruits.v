module fruits(
    input clk, en, reset, 
    input [9:0] x, y,
    input [3:0] collision,
    output wire [11:0] fruit_color,
    output wire fruit_on,
    output wire [39:0] f_x,
    output wire [39:0] f_y,
    output wire [13:0] score,
    output reg damage

);

    reg frame_toggle; 

    always @(posedge clk or posedge reset) begin
        if (reset)
        begin
            frame_toggle <= 0;
        end
        else if (y == 481 && x == 0)
        begin
            frame_toggle <= ~frame_toggle;
        end
    end

    wire refresh_tick;
    assign refresh_tick = (y == 481 && x == 0 && (frame_toggle == 1 || (score>>1) >= 50)) ? 1 : 0; // 30hz
    
    wire [9:0] f1_pos_x, f1_pos_y; 
    wire [9:0] f2_pos_x, f2_pos_y;
    wire [9:0] f3_pos_x, f3_pos_y;
    wire [9:0] f4_pos_x, f4_pos_y;

    wire [9:0] score1, score2, score3, score4;
    
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
    
    reg [5:0] apple_row;
    reg [5:0] apple_col;
    wire [11:0] apple_color_data;
    apple_rom apple_rom(
       .clk(clk),
       .row(apple_row),
       .col(apple_col),
       .color_data(apple_color_data)
    );
    
    assign fruit_on = (x >= f1_pos_x && x < f1_pos_x + 50 && y >= f1_pos_y && y < f1_pos_y + 50) 
                   || (x >= f2_pos_x && x < f2_pos_x + 50 && y >= f2_pos_y && y < f2_pos_y + 50)
                   || (x >= f3_pos_x && x < f3_pos_x + 50 && y >= f3_pos_y && y < f3_pos_y + 50)
                   || (x >= f4_pos_x && x < f4_pos_x + 50 && y >= f4_pos_y && y < f4_pos_y + 50);
                   
    assign fruit_color = (x >= f1_pos_x && x < f1_pos_x + 50 && y >= f1_pos_y && y < f1_pos_y + 50) ? (grape_color_data == 12'hFFF ? 12'hABF : grape_color_data ) 
                      : (x >= f2_pos_x && x < f2_pos_x + 50 && y >= f2_pos_y && y < f2_pos_y + 50) ? (strawberry_color_data == 12'hfff ? 12'hABF : strawberry_color_data )
                      : (x >= f3_pos_x && x < f3_pos_x + 50 && y >= f3_pos_y && y < f3_pos_y + 50) ? (cherry_color_data == 12'hfff ? 12'hABF : cherry_color_data )
                      : (x >= f4_pos_x && x < f4_pos_x + 50 && y >= f4_pos_y && y < f4_pos_y + 50) ? (apple_color_data == 12'hfff ? 12'hABF : apple_color_data )
                      : 12'h000;
    //grape
    fruit f1(
        .clk(clk),
        .en(en),
        .reset(reset),
        .refresh_tick(refresh_tick),
        .first_fruit(1),
        .y_a(f4_pos_y),
        .y_b(f2_pos_y),
        .y_c(f3_pos_y),
        .collision(collision[0]),
        .x(f1_pos_x),
        .y(f1_pos_y),
        .score(score1)
    );
    //strawberry
    fruit f2(
        .clk(clk),
        .en(en),
        .reset(reset),
        .refresh_tick(refresh_tick),
        .first_fruit(0),
        .y_a(f1_pos_y),
        .y_b(f3_pos_y),
        .y_c(f4_pos_y),
        .collision(collision[1]),
        .x(f2_pos_x),
        .y(f2_pos_y),
        .score(score2)
    );
    //cherry
    fruit f3(       
        .clk(clk),
        .en(en),
        .reset(reset),
        .refresh_tick(refresh_tick),
        .first_fruit(0),
        .y_a(f2_pos_y),
        .y_b(f1_pos_y),
        .y_c(f4_pos_y),
        .collision(collision[2]),
        .x(f3_pos_x),
        .y(f3_pos_y),
        .score(score3)
    );
    //apple
    fruit f4(
        .clk(clk),
        .en(en),
        .reset(reset),
        .refresh_tick(refresh_tick),
        .first_fruit(0),
        .y_a(f3_pos_y),
        .y_b(f2_pos_y),
        .y_c(f1_pos_y),
        .collision(collision[3]),
        .x(f4_pos_x),
        .y(f4_pos_y),
        .score(score4)
    );
    
    always @(*) begin
        cherry_row <= 0;
        cherry_col <= 0;
        strawberry_row <= 0;
        strawberry_col <= 0;
        grape_row <= 0;
        grape_col <= 0;
        apple_row <= 0;
        apple_col <= 0;
        
        if(x >= f1_pos_x && x < f1_pos_x + 50 && y >= f1_pos_y && y < f1_pos_y + 50) begin
            grape_col <= x - f1_pos_x;
            grape_row <= y - f1_pos_y;
        end else if(x >= f2_pos_x && x < f2_pos_x + 50 && y >= f2_pos_y && y < f2_pos_y + 50) begin
            strawberry_col <= x - f2_pos_x;
            strawberry_row <= y - f2_pos_y;
        end else if(x >= f3_pos_x && x < f3_pos_x + 50 && y >= f3_pos_y && y < f3_pos_y + 50) begin
            cherry_col <= x - f3_pos_x;
            cherry_row <= y - f3_pos_y;
        end else if(x >= f4_pos_x && x < f4_pos_x + 50 && y >= f4_pos_y && y < f4_pos_y + 50) begin
            apple_col <= x - f4_pos_x;
            apple_row <= y - f4_pos_y;
        end
        damage <=0;
        if(f1_pos_y == 479 || f2_pos_y == 479 || f3_pos_y == 479 || f4_pos_y == 479)
        begin
            damage <= 1;
        end
    end
    
    assign score = (score1 + score2 + score3 + score4) ;
    assign f_x = {f1_pos_x, f2_pos_x, f3_pos_x, f4_pos_x};
    assign f_y = {f1_pos_y, f2_pos_y, f3_pos_y, f4_pos_y};
endmodule
