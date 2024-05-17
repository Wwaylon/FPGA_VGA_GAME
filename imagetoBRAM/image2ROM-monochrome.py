#from scipy import misc
import imageio.v2 as imageio
import math

# returns string of monochrome bit at row x, column y of image
def get_mono_bit(im, y, x):
    # Check if pixel is white (assuming white is represented by value 255)
    if im[y][x] == 255:
        return '1'
    else:
        return '0'

# Write to file Verilog HDL
# Takes name of file, image array
def rom_mono(name, im):
    # Make output filename from input
    file_name = name.split('.')[0] + "_mono_rom.v"

    # Open file
    f = open(file_name, 'w')

    # Get image dimensions
    y_max, x_max = im.shape

    # Get width of row and column case words
    row_width = math.ceil(math.log(y_max, 2))
    col_width = math.ceil(math.log(x_max, 2))

    # Write beginning part of module up to case statements
    f.write("module " + name.split('.')[0] + "_rom\n\t(\n\t\t")
    f.write("input wire clk,\n\t\tinput wire [" + str(row_width - 1) + ":0] row,\n\t\t")
    f.write("input wire [" + str(col_width - 1) + ":0] col,\n\t\t")
    f.write("output reg color_data\n\t);\n\n\t")
    f.write("(* rom_style = \"block\" *)\n\n\t// Signal declaration\n\t")
    f.write("reg [" + str(row_width - 1) + ":0] row_reg;\n\t")
    f.write("reg [" + str(col_width - 1) + ":0] col_reg;\n\n\t")
    f.write("always @(posedge clk)\n\t\tbegin\n\t\trow_reg <= row;\n\t\tcol_reg <= col;\n\t\tend\n\n\t")
    f.write("always @*\n\tcase ({row_reg, col_reg})\n")

    # Loops through y rows and x columns
    for y in range(y_max):
        for x in range(x_max):
            # Write: color_data =
            case = format(y, 'b').zfill(row_width) + format(x, 'b').zfill(col_width)
            f.write("\t\t" + str(row_width + col_width) + "'b" + case + ": color_data = 1'b")

            # Write monochrome bit to file
            f.write(get_mono_bit(im, y, x))
            f.write(";\n")

        f.write("\n")

    # Write end of module
    f.write("\t\tdefault: color_data = 1'b0;\n\tendcase\nendmodule")

    # Close file
    f.close()

# Driver function
def generate(name):
    im = imageio.imread(name, mode='L')
    print("Width: " + str(im.shape[1]) + ", Height: " + str(im.shape[0]))
    rom_mono(name, im)

# Generate ROM from monochrome bitmap image
generate("instructions.bmp")

