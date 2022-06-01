`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:30:38 03/19/2013 
// Design Name: 
// Module Name:    vga640x480 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vga640x480(
	input wire dclk,			//pixel clock: 25MHz
	input wire clr,			//asynchronous reset
	output wire hsync,		//horizontal sync out
	output wire vsync,		//vertical sync out
	output reg [3:0] red,	//red vga output
	output reg [3:0] green, //green vga output
	output reg [3:0] blue,	//blue vga output
	input wire [15:0] data
	);

// video structure constants
parameter hpixels = 800;// horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter hpulse = 96; 	// hsync pulse length
parameter vpulse = 2; 	// vsync pulse length
parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch
// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480

// registers for storing the horizontal & vertical counters
reg [9:0] hc;
reg [9:0] vc;

// Horizontal & vertical counters --
// this is how we keep track of where we are on the screen.
// ------------------------
// Sequential "always block", which is a block that is
// only triggered on signal transitions or "edges".
// posedge = rising edge  &  negedge = falling edge
// Assignment statements can only be used on type "reg" and need to be of the "non-blocking" type: <=
always @(posedge dclk or posedge clr)
begin
	// reset condition
	if (clr == 1)
	begin
		hc <= 0;
		vc <= 0;
	end
	else
	begin
		// keep counting until the end of the line
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else
		// When we hit the end of the line, reset the horizontal
		// counter and increment the vertical counter.
		// If vertical counter is at the end of the frame, then
		// reset that one too.
		begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else
				vc <= 0;
		end
		
	end
end

// generate sync pulses (active low)
// ----------------
// "assign" statements are a quick way to
// give values to variables of type: wire
assign hsync = (hc < hpulse) ? 0:1;
assign vsync = (vc < vpulse) ? 0:1;

// display 100% saturation colorbars
// ------------------------
// Combinational "always block", which is a block that is
// triggered when anything in the "sensitivity list" changes.
// The asterisk implies that everything that is capable of triggering the block
// is automatically included in the sensitivty list.  In this case, it would be
// equivalent to the following: always @(hc, vc)
// Assignment statements can only be used on type "reg" and should be of the "blocking" type: =
always @(*)
begin
	// first check if we're within vertical active video range
	if (vc >= vbp && vc < vfp)
	begin
		// now display different colors every 80 pixels
		// while we're within the active horizontal range
		// -----------------
		// display white bar
		if (hc >= (hbp+6) && hc < (hbp+80))
		begin
		  if (data[1])
		  begin
			red = 0;
			green = 0;
			blue = 4'b1111;
		  end
		  else
		  begin
		    red = 4'b1111;
            green = 4'b1111;
            blue = 4'b1111;
          end
		end
		// display yellow bar
		else if (hc >= (hbp+86) && hc < (hbp+160))
		begin
          if (data[3])
          begin
            red = 0;
            green = 0;
            blue = 4'b1111;
          end
          else
          begin
            red = 4'b1111;
            green = 4'b1111;
            blue = 4'b1111;
          end
        end
		// display cyan bar
		else if (hc >= (hbp+166) && hc < (hbp+240))
		begin
          if (data[5])
          begin
            red = 0;
            green = 0;
            blue = 4'b1111;
          end
          else
          begin
            red = 4'b1111;
            green = 4'b1111;
            blue = 4'b1111;
          end
        end
		// display green bar
		else if (hc >= (hbp+246) && hc < (hbp+320))
		begin
          if (data[6])
          begin
            red = 0;
            green = 0;
            blue = 4'b1111;
          end
          else
          begin
            red = 4'b1111;
            green = 4'b1111;
            blue = 4'b1111;
          end
        end
		// display magenta bar
		else if (hc >= (hbp+326) && hc < (hbp+400))
		begin
          if (data[8])
          begin
            red = 0;
            green = 0;
            blue = 4'b1111;
          end
          else
          begin
            red = 4'b1111;
            green = 4'b1111;
            blue = 4'b1111;
          end
        end
		// display red bar
		else if (hc >= (hbp+406) && hc < (hbp+480))
		begin
          if (data[10])
          begin
            red = 0;
            green = 0;
            blue = 4'b1111;
          end
          else
          begin
            red = 4'b1111;
            green = 4'b1111;
            blue = 4'b1111;
          end
        end
		// display blue bar
		else if (hc >= (hbp+486) && hc < (hbp+560))
		begin
          if (data[12])
          begin
            red = 0;
            green = 0;
            blue = 4'b1111;
          end
          else
          begin
            red = 4'b1111;
            green = 4'b1111;
            blue = 4'b1111;
          end
        end
		// display black bar
		else if (hc >= (hbp+566) && hc < (hbp+640))
		begin
          if (data[13])
          begin
            red = 0;
            green = 0;
            blue = 4'b1111;
          end
          else
          begin
            red = 4'b1111;
            green = 4'b1111;
            blue = 4'b1111;
          end
        end      
		// we're outside active horizontal range so display black
		else
		begin
			red = 0;
			green = 0;
			blue = 0;
		end
	end
	// we're outside active vertical range so display black
	else
	begin
		red = 0;
		green = 0;
		blue = 0;
	end
	
	// black keys
	if (hc >= hbp+56 && hc < hbp+110 && vc >= vbp && vc <= vbp+300)
        begin
          if (data[2])
          begin
            red = 0;
            green = 0;
            blue = 4'b1111;
          end
          else
          begin
            red = 0;
            green = 0;
            blue = 0;
          end
        end
    if (hc >= hbp+136 && hc < hbp+190 && vc >= vbp && vc <= vbp+300)
        begin
          if (data[4])
          begin
            red = 0;
            green = 0;
            blue = 4'b1111;
          end
          else
          begin
            red = 0;
            green = 0;
            blue = 0;
          end
        end
    if (hc >= hbp+296 && hc < hbp+350 && vc >= vbp && vc <= vbp+300)
        begin
          if (data[7])
          begin
            red = 0;
            green = 0;
            blue = 4'b1111;
          end
          else
          begin
            red = 0;
            green = 0;
            blue = 0;
          end
        end
    if (hc >= hbp+376 && hc < hbp+430 && vc >= vbp && vc <= vbp+300)
        begin
          if (data[9])
          begin
            red = 0;
            green = 0;
            blue = 4'b1111;
          end
          else
          begin
            red = 0;
            green = 0;
            blue = 0;
          end
        end
    if (hc >= hbp+456 && hc < hbp+510 && vc >= vbp && vc <= vbp+300)
        begin
          if (data[11])
          begin
            red = 0;
            green = 0;
            blue = 4'b1111;
          end
          else
          begin
            red = 0;
            green = 0;
            blue = 0;
          end
        end
end

endmodule
