`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2021 02:42:20 PM
// Design Name: 
// Module Name: stopWatchController
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


module stopWatchController (
    input clk,
    input resetb,
    input startStop,
    output reg [7:0] AN,
    output [7:0] COUT
    );
    
    
    localparam real CLK_PERIOD = 100.0;  //ns
    localparam real REFRESH_RATE = 16000000.0;  //16 ms (in unit of ns)
    
    localparam POSITION_CHANGE_CYCLE = int'((REFRESH_RATE/CLK_PERIOD) / 8);  
    localparam SEC_COUNT =  int'(1000000000 / CLK_PERIOD);      //1 second = 1000000000 ns 
    localparam CLOCK_CNT_WIDTH = $clog2(SEC_COUNT);
    localparam POSITION_CNT_WIDTH = $clog2(POSITION_CHANGE_CYCLE);

    integer i;
    
    logic [CLOCK_CNT_WIDTH-1:0] second_cnt;  //COunter to increment the time
    logic [POSITION_CNT_WIDTH-1:0] change_position_cnt; //Counter for switching AN
    
    logic startStopToggle;   //This signal is use to start/stop the timer
    logic startStop_dly;     //Use this to detect rising edge to toggle the start and stop
    logic  startStop_re;
    logic startTimer;
    logic [2:0] digit_cnt;
    logic [3:0] display_digit[8];
    
    //Generate rising edge
    always_ff @(posedge clk)
      startStop_dly <= startStop;
    
    assign startStop_re = startStop & ~startStop_dly;
    
    //Generate Timer. 
    always_ff @(posedge clk or negedge resetb)
      if (!resetb) begin
        second_cnt <= {CLOCK_CNT_WIDTH{1'b0}};
	for (i=0;i<8;i++) display_digit[i] <= 4'b0;
        startTimer <= 1'b0;
        
      end else begin
        if (startStop_re) startTimer <= ~startTimer;
        
        if (startTimer) begin
          if (second_cnt == SEC_COUNT) begin
            second_cnt <= {CLOCK_CNT_WIDTH{1'b0}};
            
            if (display_digit[0] == 4'd9) begin
              display_digit[0] <= 4'd0;
              if (display_digit[1] == 4'd9) begin
                display_digit[1] <= 4'd0;
                 if (display_digit[2] == 4'd9) begin
                   display_digit[2] <= 4'd0;
                   if (display_digit[3] == 4'd9) begin
                     display_digit[3] <= 4'd0;
		               if (display_digit[4] == 4'd9) begin
                         display_digit[4] <= 4'd0;
                           if (display_digit[5] == 4'd9) begin
                           display_digit[5] <= 4'd0;
                             if (display_digit[6] == 4'd9) begin
                             display_digit[6] <= 4'd0;
                               if (display_digit[7] == 4'd9) display_digit[3] <= 4'd0;
                               else display_digit[7] <= display_digit[7] + 1;
                           end else display_digit[6] <= display_digit[6] + 1;
                         end else display_digit[5] <= display_digit[5] + 1;
                      end else display_digit[4] <= display_digit[4] + 1;
                   end else display_digit[3] <= display_digit[3] + 1;
                 end else display_digit[2] <= display_digit[2] + 1;
               end else display_digit[1] <= display_digit[1] + 1;
             end else display_digit[0] <= display_digit[0] + 1;
    
          end else second_cnt <= second_cnt + 1;
        end     
      end
    
    //Generate refresh Window  (No Need Reset)
    always_ff @(posedge clk or negedge resetb)
      if (!resetb) begin
        AN <= 8'b11111110;
        change_position_cnt <= {POSITION_CNT_WIDTH{1'b0}};
        digit_cnt <= 3'b000;
      end else begin

        if (change_position_cnt == POSITION_CHANGE_CYCLE) begin
          change_position_cnt <= {POSITION_CNT_WIDTH{1'b0}};
          digit_cnt <= digit_cnt + 1;
          AN <= {AN[6:0],AN[7]};
        end else change_position_cnt <= change_position_cnt + 1;
      end
     
     assign COUT = digitDisplayConvert(display_digit[digit_cnt]); 


//Active low
   function [7:0] digitDisplayConvert;
     input [3:0] value;
     
     case (value)
        0:  digitDisplayConvert = 8'b00000011; //8'b11111100;
        1:  digitDisplayConvert = 8'b10011111; //8'b01100000;
        2:  digitDisplayConvert = 8'b00100101; //8'b11011010;
        3:  digitDisplayConvert = 8'b00001101; //8'b11110010;
        4:  digitDisplayConvert = 8'b10011001; //8'b01100110;
        5:  digitDisplayConvert = 8'b01001001; //8'b10110110;
        6:  digitDisplayConvert = 8'b01000001; //8'b10111110;
        7:  digitDisplayConvert = 8'b00011111; //8'b11100000;
        8:  digitDisplayConvert = 8'b00000001; //8'b11111110;
        9:  digitDisplayConvert = 8'b00011001; //8'b11100110;
        default: digitDisplayConvert = 8'b11111111;
      endcase
   endfunction 

endmodule
