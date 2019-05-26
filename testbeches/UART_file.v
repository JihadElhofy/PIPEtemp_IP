`timescale 1ns / 1ps

module UART_tb;
//selectors, clk, data_in,data_out, errors
////////////////////////////////////////////////////////////////////////// declarations.
reg         clk;
reg         rst;
//selectors
reg [1:0]   bd_sel, 
            prty_sel;
reg         stop_sel, 
            data_bit_sel;
//seial data 
wire         data_ser; 

// parallel data 
reg [7:0]  data_in;
wire [7:0]  data_out;
//flags
wire        err_prty, 
            err_frame,
            sh,
            alarm;

wire       min15;

wire  baud_clk;      //1200 baud of Tx -- note it is the most devided clk till now just for test

reg edit;         // edit time and date 
reg Esec;        //seconds edit  1
reg Emin;       //minutes edit   2 
reg Ehour;     //hour edit       3
reg Eday;     //day edit         4
reg Emonths; //months edit       5


wire [5:0]  Hsec; //Counter
wire [5:0]  Hmin; //Counter
wire [4:0]  Hhour; //Counter
wire [4:0]  Hday; //Counter
wire [3:0]  Hmon; //Counter

////////////////////////////////////////////////////////////////////////// top Tx inst.
TxTop dut (clk, rst, data_in, prty_sel, stop_sel, data_bit_sel, bd_sel, min15, data_ser, baud_clk);

////////////////////////////////////////////////////////////////////////// tiop Rx inst.
RxTop dut2 (clk,rst, bd_sel, prty_sel, stop_sel, data_bit_sel, data_ser, data_out, err_prty, err_frame, sh, alarm);

////////////////////////////////////////////////////////////////////////// clock inst.
Watch_reload dut3 (
 rst,
 baud_clk, 
 clk,     

 edit,   
 Esec,    
 Emin,    
 Ehour,   
 Eday,    
 Emonths, 

 Hsec, 
 Hmin, 
 Hhour,
 Hday, 
 Hmon, 

 min15
);

////////////////////////////////////////////////////////////////////////// initially
initial
begin//
bd_sel       = 2'b00;
prty_sel     = 2'b00;
stop_sel     = 1'b0;
data_bit_sel = 1'b0;
edit = 0;  
Esec = 0;   
Emin = 0;   
Ehour = 0;  
Eday = 0;   
Emonths = 0;
rst = 1; #1000 rst = 0; //restting
edit = 1;  #300000; edit = 0;
data_in =8'b00101101;
end//

always begin clk=0; #10 clk =1; #10; end 

always @ (posedge min15)
begin

@ (posedge baud_clk);
@ (posedge baud_clk);
@ (posedge baud_clk);
@ (posedge baud_clk);
@ (posedge baud_clk);
@ (posedge baud_clk);
@ (posedge baud_clk);
@ (posedge baud_clk);
@ (posedge baud_clk);
@ (posedge baud_clk);
@ (posedge baud_clk);
@ (posedge baud_clk); 
if (data_out == data_in)
 $display ("successful!");
end
 /*
always
begin
#100000000;
$stop;
end
*/
endmodule

