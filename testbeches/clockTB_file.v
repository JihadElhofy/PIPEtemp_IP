`timescale 100s / 1ps

module clockTB;

///////////////////////////////////////////////////////////////////////////////////////////////////// force-in & probe declarations
reg  rst;
reg  baud_clk;      //1200 baud of Tx -- note it is the most devided clk till now just for test
reg  MH50;     //50MHz clk of system 

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

wire min15;

///////////////////////////////////////////////////////////////////////////////////////////////////// inst.
Watch_reload dut (
 rst,
 baud_clk, 
 MH50,     

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

///////////////////////////////////////////////////////////////////////////////////////////////////// initially
event srt;
initial
begin
edit = 0;  
Esec = 0;   
Emin = 0;   
Ehour = 0;  
Eday = 0;   
Emonths = 0;
rst = 1; #0.00001; rst = 0;
#0.0000001;
->srt;
end

///////////////////////////////////////////////////////////////////////////////////////////////////// clk generations
always begin MH50 = 0;         #0.0000000001         MH50 = 1;          #0.0000000001;        end
always begin baud_clk = 0;     #0.0000041666667; baud_clk = 1;      #0.0000041666667; end

///////////////////////////////////////////////////////////////////////////////////////////////////// forcing inputs
always @ (srt)
begin
edit =1;
Esec = 1; #0.0000001; Esec = 0; #0.0000001; Esec = 1; # 0.0000001; Esec = 0; #0.00000001;
edit = 0; #0.00000001 edit = 1;

Emin = 1; #0.0000001; Emin = 0; #0.0000001; Emin = 1; #0.0000001; Emin = 0; #0.00000001;
edit = 0; #0.00000001; edit = 1;

Ehour = 1; #0.0000001; Ehour = 0; #0.0000001; Ehour = 1; #0.0000001; Ehour = 0; #0.00000001;
edit = 0; #0.00000001; edit = 1;

Eday = 1; #0.0000001; Eday = 0; #0.0000001; Eday = 1; #0.0000001; Eday = 0; #0.00000001;
edit = 0; #0.00000001; edit = 1;

Emonths = 1; #0.0000001; Emonths = 0; #0.0000001; Emonths = 1; #0.0000001; Emonths = 0; #0.00000001;
edit = 0;
#0.01
if (Hsec == 3) $display ("seconds editing & timing succeeded");
#0.6
if (Hmin == 3) $display ("minutes editing & timing succeeded");
#36
if (Hhour == 3) $display ("hours editing & timing succeeded");
#864
if (Hday == 3) $display ("days editing & timing succeeded");
#25920
if (Hmon == 3) $display ("months editing & timing succeeded");
end

endmodule
