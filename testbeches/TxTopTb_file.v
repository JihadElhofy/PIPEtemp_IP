`timescale 1ns / 1ps

module TxTopTb;
reg       clk, rst; 
reg       start;
reg [7:0] in_data;
//selectors
reg [1:0] para, bd_rate;
reg       s_num, d_num;

wire      out_data;
wire       T1200; // output for clk

reg t1200, t2400, t4800, t9600; // inputs for testbench
reg baud;

/////////////////////////////////////////////////////////////////////////////////// instantiation
TxTop dut (clk, rst, in_data, para, s_num, d_num, bd_rate, start, out_data, T1200);

/////////////////////////////////////////////////////////////////////////////////// initial condition
initial
begin//
bd_rate  = 2'b00;
para     = 2'b00;
s_num     = 1'b0;
d_num = 1'b0;
rst = 1; #100 rst = 0; //restting
in_data =8'b00101101;
end//

/////////////////////////////////////////////////////////////////////////////////// clks generation
always begin clk = 0;       #10  ;      clk = 1;        #10;   end //system clk generation
always begin t1200 = 0;     #416666.67; t1200 = 1;      #416666.67; end
always begin t2400 = 0;     #208333.33; t2400 = 1;      #208333.33; end
always begin t4800 = 0;     #104166.67; t4800 = 1;      #104166.67; end
always begin t9600 = 0;     #52083.33 ; t9600 = 1;      #52083.33 ; end
always begin start = 0;  #200000000  ;  start = 1;   #2000000;   end //15min trigger

/////////////////////////////////////////////////////////////////////////////////// ADC data setting
integer bb;
integer pchanger = 1;

always @(*)
begin//
case (pchanger)
1:      begin baud = t1200;        
              bb=1200;
        end
2:      begin baud = t2400; 
              bd_rate = 2'b01;
              s_num     = 1'b1; //2bit
              d_num = 1'b1;//8 bit
              para = 2'b01;   //odd
              bb=2400; 
        end
3:      begin baud = t4800; 
              bd_rate = 2'b10;
              para = 2'b10; //even
              bb=4800;
        end
4:      begin baud = t9600; 
              bd_rate = 2'b11; 
              bb=9600; 
        end
5:       $stop;
default: baud = t1200; 
endcase
end//

always @ (posedge start)
begin///
    case (pchanger)
    1: $display ("7bit data, no parity, 1bit stop"); 
    2: $display ("8bit data, odd parity, 2bit stop"); 
    3: $display ("8bit data, even parity, 2bit stop");
    4: $display ("8bit data, even parity, 2bit stop");
    endcase
    
    $display ("%d rate ADC data: %b", bb, in_data);
    
    repeat (13)
    begin //
    @ (posedge baud);
    $display ("time: %d |data: %b",$time, out_data);
    end //
    $display("--------------------------------------------------------");
    pchanger = pchanger + 1;
end/// 

endmodule
