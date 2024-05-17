module collision_detector(
    input game_reset,
    input [9:0] p_x, p_y,
    input [39:0] f_x,
    input [39:0] f_y,
    output reg [13:0] score
    );
    
    // Define the width and height of the player and objects
    parameter P_WIDTH = 50;
    parameter P_HEIGHT = 50;
    parameter F_WIDTH = 50;
    parameter F_HEIGHT = 50;
    
    integer i;
    
    initial begin
        score = 0;
    end
    
    function d_bit;
        input [9:0] x, y, f_x, f_y;
        begin
            d_bit =
            (
                (x < f_x + F_WIDTH) && 
                (x + P_WIDTH > f_x) && 
                (y < f_y + F_HEIGHT) && 
                (y + P_HEIGHT > f_y)
            );
        end
    endfunction
    
    always@(*)
    begin
        if(game_reset)
        begin
            score <= 0;
        end
        else begin
            if(d_bit(p_x, p_y, f_x[9:0], f_y[9:0]) 
            || d_bit(p_x, p_y, f_x[19:10], f_y[19:10])
            || d_bit(p_x, p_y, f_x[29:20], f_y[29:20])
            || d_bit(p_x, p_y, f_x[39:30], f_y[39:30]))
                score<=(score+1)<=1000? score+1 : 0;
        end
       
    end
    
    
endmodule
