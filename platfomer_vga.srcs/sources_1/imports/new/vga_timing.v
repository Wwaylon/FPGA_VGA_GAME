module vga_timing
	(
		input wire clk25mhz, reset,
		output wire hsync, vsync, active_area,
		output wire [9:0] x, y
	);
	//paramaters for VGA 640x480 timing
	localparam full_line = 800;
	localparam h_front_porch = 16;
	localparam h_back_porch = 48;
	localparam h_sync_pulse = 96;
	localparam active_h_area = 640;
	
	localparam full_row = 525;
	localparam v_front_porch = 10;
	localparam v_back_porch = 33;
	localparam v_sync_pulse = 2;
	localparam active_v_area = 480;
	
	// registers to keep track of current pixel location
	reg [9:0] h_pos, v_pos;
    
    //Pixel position moves from left to right, from top to bottom controlling the movement of the electron beam(if this was used to control an actual CRT monitor)
    always @(posedge clk25mhz or posedge reset) begin
        if (reset) begin
            h_pos <= 0;
            v_pos <= 0;
        end else begin
            if (h_pos == full_line-1) begin
                h_pos <= 0;
                if (v_pos == full_row-1)
                    v_pos <= 0;
                else 
                    v_pos <= v_pos + 1;
            end else 
                h_pos <= h_pos + 1;
        end
  end
  
    // Hsync, Vsync set via checks on the H_pos and V_pos
    assign x = h_pos;
    assign y = v_pos;
    assign hsync = (h_pos >= (active_h_area + h_front_porch )) &&  (h_pos <= (active_h_area + h_front_porch + h_sync_pulse -1)); //Active Low
    assign vsync = (v_pos >= (active_v_area + v_front_porch )) &&  (v_pos <= (active_v_area + v_front_porch + v_sync_pulse -1)); //Active low
    assign active_area = (h_pos <= active_h_area-1) && (v_pos <= active_v_area -1);
endmodule