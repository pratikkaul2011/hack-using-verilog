`include "alu.v"
`include "ram.v"
`include "rom.v"

module cpu(clk,
           nrst,
           inst_addr,
           instruction,
           rdata,
           writeData,
           ramAddress,
           writeM);
    
    input clk, nrst;    
    input[15:0] instruction; // instruction    
    input[15:0] rdata; // inM    
    output[14:0] inst_addr; // pc    
    output[14:0] ramAddress; // addressM    
  	output[15:0] writeData; // outM
    
    output writeM; // writeM    
  	reg[14:0] pc; 
  	reg[15:0] a; //A register
    reg[15:0] d; //D register and x input of ALU
  
    // A register
   wire sel_a = instruction[15];  
   wire[15:0] next_a = sel_a ? alu_out : {1'b0, instruction[14:0]}; // multiplexer for data feeding to A register. 
   wire load_a = !instruction[15] || instruction[5];    // to load the next value into A register with the D1 in intruction.  
  
  always @(posedge clk)
          if (load_a)
              a <= next_a;    

   wire sel_am = instruction[12];
   wire[15:0] y = sel_am ? readM : a;  // The second mux input to the alu

	// D register

   wire load_d = instruction[15] && instruction[4];
  always @(posedge clk)
          if (load_d)
              d = next_d;
   wire[15:0] next_d = alu_out;

	// PC
   wire less_than_zero = ng;  
   wire greater_than_zero = !(less_than_zero || zero);  
  wire jump = (less_than_zero && instruction[2])||(zero && instruction[1])||(greater_than_zero && instruction[0]);   
  wire load_pc = instruction[15] && jump; // for any jump instruction so thatt jump can be made to any intruction in memory
  
  wire[14:0] next_pc = load_pc ? a[14:0] : pc + 15'b1;  
  assign inst_addr = pc;
  
  always @(posedge clk)
      if (!nrst)
        begin
          pc <= 15'b0;
          d = 0;
          a = 0;
        end
      else
        begin
          pc = next_pc;
        end

	//ALU interface with cpu
  wire zero, ng;
  wire[15:0] alu_out;
  wire[5:0] alu_fn = instruction[11:6];
  alu alu0(.x(d), .y(y), .alu_out(alu_out), .fn(alu_fn), .zr(zero),.ng(ng));

	// RAM interface with the cpu

   wire[15:0] readM = rdata;
   assign writeM = instruction[15] && instruction[3];
   assign ramAddress = a[14:0]; // 15 bit address because the first bit of instruction is useless ( msb ).
   assign writeData = alu_out;

  
endmodule
