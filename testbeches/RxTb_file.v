`timescale 1ns / 1ps

module RX_tb;
/////////////////////////////////////////////////////////////////////////////////////// declaration
reg         rst;
//selectors
reg [1:0]   bd_sel, 
            prty_sel;
reg         stop_sel, 
            data_bit_sel;
//baud rates
reg         r1200, r2400, r4800, r9600;
//seial data in
reg         data_in_Rx; 

// parallel data out
wire [7:0]  data_out_Rx;
//flags
wire        err_prty, 
            err_frame; 


//bit rate clk
reg t1200;
always begin t1200 = 0;     #416666.67; t1200 = 1;      #416666.67; end

/////////////////////////////////////////////////////////////////////////////////////// instantiation
Rx DUT (rst, data_in_Rx, data_out_Rx, data_bit_sel, stop_sel, prty_sel, r1200, r2400, r4800, r9600, bd_sel, err_prty,err_frame);

/////////////////////////////////////////////////////////////////////////////////////// initial condition
initial
begin//
bd_sel       = 2'b00;       //1200
prty_sel     = 2'b00;      //no parity
stop_sel     = 1'b0;     //1 stop bit
data_bit_sel = 1'b0;    //7 bits
data_in_Rx = 1;         //default ideal state
rst = 1; #100 rst = 0; //restting
//Edata_out_Rx = 0;
end//

/////////////////////////////////////////////////////////////////////////////////////// baud rates generating
always begin r1200 = 0;     #26041.67;  r1200 = 1;      #26041.67;   end
always begin r2400 = 0;     #13020.83;  r2400 = 1;      #13020.83;   end
always begin r4800 = 0;     #6510.42;   r4800 = 1;      #6510.42;    end
always begin r9600 = 0;     #3255.2;    r9600 = 1;      #3255.2;     end

/////////////////////////////////////////////////////////////////////////////////////// setting Tx-from testing data
///testing data definition
integer data;
integer dchanger = 1;
//integer rpt;

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
$display("-----------------------------------------------------"); 
$display ("%d forced data: %13b",$time, data);

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

$display ("logic out data: %8b", data_out_Rx);
case(data_bit_sel)
0:begin if(data_out_Rx == data[7:1])begin $display("data transfere successeded!"); end
        else begin $display("data transfere failed!"); end end
1:begin if(data_out_Rx == data[8:1])begin $display("data transfere successeded!"); end
        else begin $display("data transfere failed!"); end end
endcase


#1000000;  
end//
end///


endmodule