`timescale 1ns / 1ps
module TX_tb;
reg [1:0]   bd_sel, prty_sel;
reg         t1200, t2400, t4800, t9600, clk15min; //15min trigger scaled for 1 sec -for simulation-
reg         rst;
reg         stop_sel, data_bit_sel;
reg [7:0]   data_in;
wire        data_out_Tx;

reg baud;

/////////////////////////////////////////////////////////////////////////////////// instantiation
Tx DUT (rst, data_in, data_out_Tx, prty_sel, stop_sel, data_bit_sel, bd_sel, t1200, t2400, t4800, t9600, clk15min);

//initial condition
initial
begin//
bd_sel       = 2'b00;
prty_sel     = 2'b00;
stop_sel     = 1'b0;
data_bit_sel = 1'b0;
rst = 1; #100 rst = 0; //restting
data_in =8'b00101101;
end//

/////////////////////////////////////////////////////////////////////////////////// baud rates generating
always begin t1200 = 0;     #416666.67; t1200 = 1;      #416666.67; end
always begin t2400 = 0;     #208333.33; t2400 = 1;      #208333.33; end
always begin t4800 = 0;     #104166.67; t4800 = 1;      #104166.67; end
always begin t9600 = 0;     #52083.33 ; t9600 = 1;      #52083.33 ; end
always begin clk15min = 0;  #200000000; clk15min = 1;   #2000000;   end //15min trigger

/////////////////////////////////////////////////////////////////////////////////// setting ADC data input
integer bb;
integer pchanger = 1;

always @(*)
begin//
case (pchanger)
1:      begin baud = t1200;        
              bb=1200;
        end
2:      begin baud = t2400; 
              bd_sel = 2'b01;
              stop_sel     = 1'b1; //2bit
              data_bit_sel = 1'b1;//8 bit
              prty_sel = 2'b01;   //odd
              bb=2400; 
        end
3:      begin baud = t4800; 
              bd_sel = 2'b10;
              prty_sel = 2'b10; //even
              bb=4800;
        end
4:      begin baud = t9600; 
              bd_sel = 2'b11; 
              bb=9600; 
        end
5:       $stop;
default: baud = t1200; 
endcase
end//
/////////////////////////////////////////////////////////////////////////////////// checking output
always @ (posedge clk15min)
begin///
    case (pchanger)
    1: $display ("7bit data, no parity, 1bit stop"); 
    2: $display ("8bit data, odd parity, 2bit stop"); 
    3: $display ("8bit data, even parity, 2bit stop");
    4: $display ("8bit data, even parity, 2bit stop");
    endcase
    
    $display ("%d rate ADC data: %b", bb, data_in);
    
    repeat (13)
    begin //
    @ (posedge baud);
    $display ("time: %d |data: %b",$time, data_out_Tx);
    end //
    $display("--------------------------------------------------------");
    pchanger = pchanger + 1;
end/// 

/*
//self-checking code
always @ (posedge clk15min)
begin///
    $display ("f %b",data_in);
    
    repeat (13)
    begin //
    @ (posedge t1200);
    $display ("time: %d |data: %b",$time, data_out_Tx);
    end //
    
    $display("--------------------------------------------------------");
    
    @(posedge clk15min);
    $display ("s %b",data_in);
    
    repeat (13)
    begin //
    bd_sel       = 2'b01;
    prty_sel     = 2'b01;
    stop_sel     = 1'b1;
    data_bit_sel = 1'b1;
    @ (posedge t2400);
    $display ("time: %d |data: %b",$time, data_out_Tx);
    end //
    
     $display("--------------------------------------------------------");
end///

always
begin
#1005400000;
$stop;
end
*/
endmodule