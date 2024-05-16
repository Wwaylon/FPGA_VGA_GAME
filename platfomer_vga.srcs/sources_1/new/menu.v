
module menu(
    input clk, down, up, open_menu, reset,
    input [9:0] x, y,
    output reg menu_on, menu_text_on
    );
    
    reg menu_selection =0;
    reg menu_selection_next =0;
    reg paused =0;
    reg paused_next =0;
    reg [7:0] restart_col;
    reg [6:0] restart_row;
    wire restart_color_data;
    reg [7:0] resume_col;
    reg [6:0] resume_row;
    wire resume_color_data;
    wire open_menu_w, up_w, down_w;
    wire open_menu_btn, up_btn, down_btn;
    button_sync b1(
        .clk(clk),
        .in(open_menu),
        .out(open_menu_w)
    );
    button_sync b2(
        .clk(clk),
        .in(up),
        .out(up_w)
    );
    button_sync b3(
        .clk(clk),
        .in(down),
        .out(down_w)
    );
    debounce debounce_open_menu(
        .clk(clk),
        .in(open_menu_w),
        .rise(open_menu_btn)
    );
    debounce #(.MAX_COUNT(1)) debounce_up(
        .clk(clk),
        .in(up_w),
        .rise(up_btn)
    );
    debounce #(.MAX_COUNT(1)) debounce_down(
        .clk(clk),
        .in(down_w),
        .rise(down_btn)
    );
    
    restart_rom r1(
        .clk(clk),
        .row(restart_row),
        .col(restart_col),
        .color_data(restart_color_data)
    );
    resume_rom r2(
        .clk(clk),
        .row(resume_row),
        .col(resume_col),
        .color_data(resume_color_data)
    );
    
    always@(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            paused <= 0;
            menu_selection <= 0;
        end
        else 
        begin
            paused<=paused_next;
            menu_selection<=menu_selection_next;
        end
    end
    
    always@(*)
    begin
        if(open_menu_btn)
            paused_next <= ~paused;
        else if(up_btn && paused)
            menu_selection_next <= ~menu_selection;
    end
    
    always@(*)
    begin
        
        menu_on <= 0;
        menu_text_on <= 0;
        if(paused && x>=245 && x< 395 && y>= 190 && y<290)
            menu_on <= 1;
        if(paused && x>=245 && x< 395 && y>= 190 && y<240)
        begin
            resume_col <= x-245;
            resume_row <= menu_selection ? (y-140) : (y-190);
            menu_text_on <= ~resume_color_data;
        end
        if(paused && x>=245 && x< 395 && y>= 240 && y<290)
        begin
            restart_col <= x-245;
            restart_row <= menu_selection ? (y-240) : (y-190); //y is >240
            menu_text_on <= ~restart_color_data;
        end
    end
    
   
endmodule
