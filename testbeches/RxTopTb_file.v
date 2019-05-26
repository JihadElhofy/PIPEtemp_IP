`timescale 1ns / 1ps

module RxTop_tb;
/////////////////////////////////////////////////////////////////////////////////////// declaration
reg         clk;
reg         rst;
//selectors
reg [1:0]   bd_sel, 
            prty_sel;
reg         stop_sel, 
            data_bit_sel;
//seial data in
reg         data_in_Rx; 

// parallel data out
wire [7:0]  data_out_Rx;
//flags
wire        err_prty, 
            err_frame,
            sh,
            alarm;


 
//expected output values for test bench
//reg [7:0] Edata_out_Rx;
    //reg Eerr_dis, Eerr_prty, Eerr_start, Eerr_overrun;

//bit rate clk
reg t1200;
always begin t1200 = 0;     #416666.67; t1200 = 1;      #416666.67; end

/////////////////////////////////////////////////////////////////////////////////////// instantiation
RxTop dut (clk,rst, bd_sel, prty_sel, stop_sel, data_bit_sel, data_in_Rx, data_out_Rx, err_prty, err_frame, sh, alarm);

/////////////////////////////////////////////////////////////////////////////////////// initial condition
initial
begin//
bd_sel       = 2'b00;       //1200
prty_sel     = 2'b00;      //no parity
stop_sel     = 1'b0;     //1 stop bit
data_bit_sel = 1'b0;    //7 bits
data_in_Rx = 1;         //default ideal state
rst = 1; #100 rst = 0; //restting
end//


/////////////////////////////////////////////////////////////////////////////////////// clk generation
always begin clk = 0;     #10;  clk = 1;      #10;   end

/////////////////////////////////////////////////////////////////////////////////////// setting Tx-from testing data
///testing data definition
integer data;
integer dchanger = 1;

always @(dchanger)
begin
case (dchanger)
//?correct data transfere & proper package interpretting 
1:data = 13'b1111_1_0001111_0;                                                                    //7bits, no parity, 1Stp 
2:begin data = 13'b1_11_1_00101010_0; data_bit_sel = 1'b1; prty_sel = 2'b10; stop_sel = 1'b1; end //8bits, even parity, 2Stp 
3:begin data = 13'b1_11_1_11100001_0;                      prty_sel = 2'b01;                  end //8bits, odd parity, 2Stp 
//?alarm
4:data = 13'b1_11_0_11001000_0;
//?shutdown     
5:data = 13'b1_11_1_11111010_0;
//?error parity falg
6:data = 13'b1_11_0_01001011_0;
//?error frame bit flag
7:data = 13'b1_01_0_00000001_0;           //????????
//?error frame bit flag
8:data = 13'b1_10_0_00000010_0;           //???????
9:$stop; 
endcase

$display ("%d data: %13b",$time, data);
end

integer i=0; //data bit index
///testing data setting
always @ (posedge t1200)
begin///
data_in_Rx = data [i];
i = i + 1;
if (i==14)
begin//
data_in_Rx = 1; 
i = 0; 
dchanger = dchanger +1;
#1000000;  
end//
end///

endmodule