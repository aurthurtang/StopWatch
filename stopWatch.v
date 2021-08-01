`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2021 06:41:35 PM
// Design Name: 
// Module Name: stopWatch
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


module stopWatch(
    input clk,
    input reset,
    input startStop,
    output [7:0] AN,
    output [7:0] CN
    );

wire resetb_sync;
wire startStopb_sync;

reset_sync Isync_reset(
    .clk (clk),
    .in  (reset),
    .outb (resetb_sync)
    );

reset_sync Isync_startStop(
    .clk (clk),
    .in  (startStop),
    .outb (startStopb_sync)
    );
          
  stopWatchController IController (
     .clk (clk),
     .resetb (resetb_sync),
     .startStop (~startStopb_sync),
     .AN (AN),
     .COUT (CN)
   );
   
endmodule
