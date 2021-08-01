`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2021 02:34:40 PM
// Design Name: 
// Module Name: reset_sync
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module reset_sync(
    input clk,
    input in,
    output outb
    );
    
reg [1:0] ff_delay;

    always @(posedge clk or posedge in)
      if (in) ff_delay <= 2'b00;
      else ff_delay <= {ff_delay[0],1'b1};

assign outb = ff_delay[1];

endmodule
