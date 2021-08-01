# Stop Watch

> This project is to use NEXYS A7 FPGA board to create a stop watch.  This project helps to explore the features in Vivado and the 8-Segment LED display on the board.  Since the clock source on the board is 100Mhz, we will instantiate a MMCM using IP Integrator in Vivado to slow down the clock from 100 Mhz to 10 Mhz to save power and logic.  In the end, we will pack everything together using the block design feature in Vivado

>![Block Diagram](https://github.com/aurthurtang/StopWatch/blob/main/stopwatch_block_design.JPG)
