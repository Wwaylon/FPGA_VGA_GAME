module platfomer_top(
    input wire clk_b, reset, up, down, right, left, open_menu, 
    input wire [11:0] sw,
    output wire hsync, vsync,
    output wire [11:0] rgb   
    );
   
    
    //wires and registers
    wire active_area;
    wire [9:0] x,y;
    reg [11:0] rgb_reg, rgb_next;
   
    wire  player_on;
    wire [9:0] player_pos_x, player_pos_y;
    wire [11:0] player_color_data;
    
    wire score_on;
    reg [13:0] score;
    
    reg [11:0] background_color = 12'hABF;
    
    wire menu_on;
    reg [11:0] menu_color = 12'h48f;
    wire menu_text_on;
    

    
    //instantiate clks
    clk_wiz_0 clock_instance (
        .clk_25mhz(clk_25mhz),     // output clk_25mhz
        .clk_100mhz(clk_100mhz),     // output clk_100mhz
        .clk_in1(clk_b)
    );
    // instantiate vga_sync module
    vga_timing vga_timing_unit (
        .clk25mhz(clk_25mhz), 
        .reset(reset), 
        .hsync(hsync), 
        .vsync(vsync),
        .active_area(active_area), 
        .x(x), 
        .y(y)
    );
    menu menu_unit(
        .clk(clk_100mhz),
        .down(down),
        .up(up),
        .open_menu(open_menu),
        .reset(reset),
        .x(x),
        .y(y),
        .menu_on(menu_on),
        .menu_text_on(menu_text_on)
    );

    //instantiate score module
    score score_unit(
        .clk(clk_100mhz),
        .x(x),
        .y(y),
        .score(score),
        .score_on(score_on)
    );
    
    //instantiate player module 
    player player_unit(
        .clk(clk_100mhz),
        .reset(reset),
        .right(right),
        .left(left),
        .x(x),
        .y(y),
        .background_color(background_color),
        .player_pos_x(player_pos_x),
        .player_pos_y(player_pos_y),
        .player_on(player_on),
        .player_color_data(player_color_data)
    );
   
    
    always@(posedge clk_100mhz or posedge reset) begin
        if(reset)begin
            rgb_reg <= 0;
        end
        else begin
            rgb_reg <= rgb_next;
        end
    end  
    
    always @(*)
    begin
        if(player_on)
        begin
            rgb_next <= player_color_data;
        end
        else if(score_on)
        begin
            rgb_next <= 12'hFFF;
        end
        else if(menu_text_on)
        begin
            rgb_next <= 12'h000;
        end
        else if(menu_on)
        begin
            rgb_next <= menu_color;
        end
        else if(x >= 0 && x < 640 &&  y >= 0 && y <40)
        begin
            rgb_next <= 12'h000;
        end
        else begin
            rgb_next <= background_color;
        end
    end
    
    assign rgb = (active_area) ? rgb_reg : 12'b0;
endmodule
