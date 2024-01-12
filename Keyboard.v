module Keyboard(PS2_CLK, PS2_DAT, A, D, Enter, signal);
    input PS2_CLK, PS2_DAT;
    output reg A = 1'b0, D = 1'b0, Enter = 1'b0;
	 output reg [2:0] signal;
    reg [3:0] counter = 4'b0;
	 reg [7:0] data = 8'b0;
    reg done = 1'b0, pulse_down = 1'b0;
    always @(negedge PS2_CLK) begin
        case(counter)
            4'd0:   ;
            4'd1:   data[0] <= PS2_DAT;
            4'd2:   data[1] <= PS2_DAT;
            4'd3:   data[2] <= PS2_DAT;
            4'd4:   data[3] <= PS2_DAT;
            4'd5:   data[4] <= PS2_DAT;
            4'd6:   data[5] <= PS2_DAT;
            4'd7:   data[6] <= PS2_DAT;
            4'd8:   data[7] <= PS2_DAT;
            4'd9:   done <= 1'b1;
            4'd10:  done <= 1'b0;
            default: counter <= 0;
        endcase
        if(counter == 10) counter <= 0;
        else counter <= counter+1;
    end
    always @(posedge done) begin
        if(data == 8'hF0) begin
            pulse_down <= 1;
				//signal <= 3'b000;
        end
        else begin
            if(data == 8'h1C)begin
				A <= !pulse_down;
				if(pulse_down != 1'b1) signal <= 3'b100;
				end
            else if(data == 8'h23)begin
				D <= !pulse_down;
				if(pulse_down != 1'b1) signal <= 3'b001;
				end
            else if(data == 8'h5A) begin
				Enter <= !pulse_down;
				if(pulse_down != 1'b1) signal <= 3'b111; 
				end
            else signal <= 3'b000;
				pulse_down <= 0;
				
        end
    end
endmodule

module hex_decoder(c, display);
    input [3:0] c;
    output [6:0] display;
    assign display[0] = !((c[3] | c[2] | c[1] | !c[0]) & (!c[3] | !c[2] | c[1] | !c[0]) & (!c[3] | c[2] | !c[1] | !c[0]) & (c[3] | !c[2] | c[1] | c[0]));
    assign display[1] = !((c[3] | !c[2] | c[1] | !c[0]) & (c[3] | !c[2] | !c[1] | c[0]) & (!c[3] | c[2] | !c[1] | !c[0]) & (!c[3] | !c[2] | c[1] | c[0])& (!c[3] | !c[2] | !c[1] | c[0])& (!c[3] | !c[2] | !c[1] | !c[0]));
    assign display[2] = !((c[3] | c[2] | !c[1] | c[0]) & (!c[3] | !c[2] | c[1] | c[0]) & (!c[3] | !c[2] | !c[1] | c[0]) & (!c[3] | !c[2]  | !c[1] | !c[0]));
    assign display[3] = !((c[3] | c[2] | c[1] | !c[0]) & (c[3] | !c[2] | c[1] | c[0]) & (c[3] | !c[2] | !c[1]  | !c[0]) & (!c[3] | c[2] | !c[1] | c[0]) & (!c[3] | !c[2] | !c[1] | !c[0]));
    assign display[4] = !((c[3] | c[2] | c[1] | !c[0]) & (c[3] | c[2] | !c[1] | !c[0]) & (c[3] | !c[2] | c[1] | c[0]) & (c[3] | !c[2] | c[1] | !c[0]) & (c[3] | !c[2] | !c[1] | !c[0]) & (!c[3] | c[2] | c[1] | !c[0]));
    assign display[5] = !((c[3] | c[2] | c[1] | !c[0]) & (c[3] | c[2] | !c[1] | !c[0]) & (c[3] | !c[2] | !c[1] | !c[0]) & (!c[3] | !c[2] | c[1] | !c[0]) & (c[3] | c[2] | !c[1] | c[0]));
    assign display[6] = !((c[3] | c[2] | c[1] | c[0]) & (c[3] | c[2] | c[1] | !c[0]) & (c[3] | !c[2] | !c[1] | !c[0]) & (!c[3] | !c[2] | c[1] | c[0]));
endmodule

//module Keyboard(input PS2_CLK, PS2_DAT, output [6:0] HEX0, HEX1, HEX2);
//	wire A, D, ENTER;
//	keyboard kb(PS2_CLK, PS2_DAT, A, D, ENTER);
//	hex_decoder h1 (A, HEX0);
//	hex_decoder h2 (D, HEX1);
//	hex_decoder h3(ENTER, HEX2);
//endmodule
