//ALU

module alu(x, y, alu_out, fn, zr,ng);

    input[15:0] x, y;
    input[5:0] fn;
    output[15:0] alu_out;
    output zr,ng;

    wire zx = fn[5]; // just for easy interfacing with scehmatic naming it as named in the logic table 
    wire nx = fn[4];
    wire zy = fn[3];
    wire ny = fn[2];
    wire f = fn[1];
    wire no = fn[0];   

    wire[15:0] x0 = zx ? 16'b0 : x;
    wire[15:0] y0 = zy ? 16'b0 : y;
    wire[15:0] x1 = nx ? ~x0 : x0;
    wire[15:0] y1 = ny ? ~y0 : y0;
 	wire[15:0] out0 = f ? x1 + y1 : x1 & y1;

    assign alu_out = no ? ~out0 : out0;
    assign zr = ~|alu_out;  
  	assign ng = alu_out[15];  
  
endmodule
