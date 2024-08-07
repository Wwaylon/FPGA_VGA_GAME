# FPGA VGA Game -  Catch the Fruit
This is a game is intended to be played on a vga monitor using the buttons on the basys3 board. The game is a "Catch the Fruit", where the aim is to catch as many falling fruits as possible. 
If a fruit reaches the floor, the player loses a life point. At zero life points the game ends and restarts. 
The player is scored on how many fruits they catch within 3 lives. 
At 50 points, the speed at which fruits fall doubles, increasing overall difficulty.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[![gif](https://github.com/Wwaylon/FPGA_VGA_GAME/blob/main/images/gif.gif?raw=true)](https://drive.google.com/file/d/1dU0x5I3jarGUIz8Yi9yZep13Qqnc5u1P/view?usp=drive_link)
<p align="center">
Find the full video <a href="https://drive.google.com/file/d/1dU0x5I3jarGUIz8Yi9yZep13Qqnc5u1P/view?usp=sharing">here </a>
</p>

## Controls
- Left button
  - Moves player left(when not in menu)
- Right button
  - Moves player right(when not in menu)
- Down button
  - Increases player speed by 2x when held down in conjunction with left or right button
- Center button 
  - Opens menu / Select menu option
- Up button
  - Moves menu selection cursor(when in menu)

<p align="center">
  <img src="https://github.com/Wwaylon/FPGA_VGA_GAME/blob/main/images/basys3.jpg?raw=true" width="550" title="basys3">
  <br><em>Basys3 FPGA board</em>
</p>

## About : Development
The code was written for the Basys3 FPGA board using verilog and Vivado Design Studio. The code utilizes the built-in VGA port on the board for interfacing with VGA monitors.
The VGA signal is for 640x480 pixels at 60hz and thus has a pixel frequency of 25.175MHz(25MHz in actuality).
The resistor ladder built-in on the board supports 12 bit color(4 red, 4 green, 4 blue). 


## Credit 
-Joey at https://embeddedthoughts.com/2016/07/30/storing-image-data-in-block-ram-on-a-xilinx-fpga/ for the original image to BRAM script that I edited for my purposes.

