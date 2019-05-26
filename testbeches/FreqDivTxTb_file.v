`timescale 1ns / 1ps
module freq_tb;
  
reg clk, rst;
wire T9600;      //9600 baud rate 
wire T2400;     //2400 baud rate  
wire T4800;    //4800 baud rate   
wire T1200;    //1200 baud rate    

///////////////////////////////////////////////////////////////////////// instantiation
freq dut (clk, rst, T1200, T2400, T4800, T9600);

///////////////////////////////////////////////////////////////////////// initially
  initial
  begin
  rst=1; #6 rst=0;
  end

///////////////////////////////////////////////////////////////////////// 
real a,b,c;
real a2,b2,c2;
real a3,b3,c3;
real a4,b4,c4;

  always
  begin clk=0; #10 clk = 1; #10;end

///////////////////////////////////////////////////////////////////////// baud T1200
  //raising timing
  always @ (posedge T1200)
  begin
  a=$time;
  //$display ("rais %d",$time);
  end
  
  //faling timing
  always @ (negedge T1200)
  begin
  b=$time;
  c= 1/(2*(b-a))*10**9;
  
  //$display ("fall %d",b);
  $display ("T1200 freq: %d Hz ",c);
  $display ("-------------------------------------------");
  end

///////////////////////////////////////////////////////////////////////// baud T2400
  //raising timing
  always @ (posedge T2400)
  begin
  a2=$time;
  //$display ("rais %d",$time);
  end
  
  //faling timing
  always @ (negedge T2400)
  begin
  b2=$time;
  c2= 1/(2*(b2-a2))*10**9;
  
  //$display ("fall %d",b2);
  $display ("T2400 freq: %d Hz ",c2);
  $display ("-------------------------------------------");
  end

///////////////////////////////////////////////////////////////////////// baud T4800
  //raising timing
  always @ (posedge T4800)
  begin
  a3=$time;
  //$display ("rais %d",$time);
  end
  
  //faling timing
  always @ (negedge T4800)
  begin
  b3=$time;
  c3= 1/(2*(b3-a3))*10**9;
  
  //$display ("fall %d",b3);
  $display ("T4800 freq: %d Hz ",c3);
  $display ("-------------------------------------------");
  end

///////////////////////////////////////////////////////////////////////// baud T9600
  //raising timing
  always @ (posedge T9600)
  begin
  a4=$time;
  //$display ("rais %d",$time);
  end
  
  //faling timing
  always @ (negedge T9600)
  begin
  b4=$time;
  c4= 1/(2*(b4-a4))*10**9;
  
  //$display ("fall %d",b4);
  $display ("T9600 freq: %d Hz ",c4);
  $display ("-------------------------------------------");
  end

/////////////////////////////////////////////////////////////////////////  simulation duration
  always
  begin
  #2600000;
  $stop;
  end

endmodule