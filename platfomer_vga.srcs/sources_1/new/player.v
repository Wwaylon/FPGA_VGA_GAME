module player(
    input clk, reset, right, left,
    input [9:0] x, y,
    input [11:0] background_color,
    output reg [9:0] player_pos_x, player_pos_y,
    output reg player_on,
    output wire [11:0] player_color_data
    );    
    //wires and registers
    reg [5:0] player_row;
	reg [5:0] player_col;
    reg [9:0] player_pos_x_next = 319;
    reg [9:0] player_pos_y_next = 429;
    
    //infer player rom
    player_rom player_rom_unit(
        .clk(clk),
        .row(player_row),
        .col(player_col),
        .color_data(player_color_data)
    );
    
    //player position buffer
    always@(posedge clk or posedge reset) begin
        if(reset)begin
            player_pos_x <= 295;
            player_pos_y <= 429;
        end
        else begin
            player_pos_x <= player_pos_x_next;
        end
    end  
    
    // create 60Hz refresh tick
    wire refresh_tick;
    assign refresh_tick = ((y == 481) && (x == 0)) ? 1 : 0; // start of vsync(vertical retrace)
    
    //every frame refresh update player position
    always@(*)
    begin
        if(right && refresh_tick && (player_pos_x +50 +1) != 640) begin
            player_pos_x_next <= player_pos_x +1;
        end
        else if (left && refresh_tick && (player_pos_x -1) != 0) begin
            player_pos_x_next <= player_pos_x -1;
        end
        else begin
            player_pos_x_next <= player_pos_x;
        end
    end
    
    //load player image from rom
    always@(*)
    begin
        player_on <= 0;
		player_row <= 0;
		player_col <= 0;
        if(x>= player_pos_x && x< player_pos_x+50 && y>= player_pos_y && y <player_pos_y+50)
        begin
            player_col <= x-player_pos_x;
            player_row <= (y-player_pos_y);
            if((player_color_data != background_color) && (player_color_data != 12'hFFF))
            begin
                player_on <=1;
            end
        end
    end
endmodule
