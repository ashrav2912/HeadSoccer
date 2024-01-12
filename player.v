module player(input clock, input reset, input gameStart, input frameEn, input [2:0] keys, input [7:0] upleftX, input [6:0] upleftY, 
output [7:0] oX, output [6:0] oY);
	wire [2:0] velocity;
	wire [2:0] playerIntr;
	controlPlayer cp0(clock, frameEn, velocity, reset, gameStart, keys, playerIntr);
	movePlayer mp0(clock, reset, gameStart, frameEn, upleftX, upleftY, playerIntr, oX, oY, velocity);
endmodule

module controlPlayer(input clock, input frameEn, input [2:0] velocity, input reset, input gameStart, input [2:0] keys, output reg [2:0] playerIntr);
	reg [2:0] current_state, next_state;
	localparam STOP = 3'd0,
				  MOVELEFT = 3'd1,
				  MOVERIGHT = 3'd2,
				  JUMP = 3'd3,
				  INAIR = 3'd4;
	always@(*)
	begin
		if(gameStart) begin
			case(current_state)
				STOP: begin
					if(keys[1] == 1'b1)
						next_state = JUMP;
					else if(keys == 3'b100)
						next_state = MOVELEFT;
					else if(keys == 3'b001)
						next_state = MOVERIGHT;
					else 
						next_state = STOP;
				end
				MOVELEFT: begin
					if(keys == 3'b100)
						next_state = MOVELEFT;
					else if(keys == 3'b001)
						next_state = MOVERIGHT;
					else if(keys[1] == 1'b1)
						next_state = JUMP;
					else
						next_state = STOP;
				end
				MOVERIGHT: begin
					if(keys == 3'b100)
						next_state = MOVELEFT;
					else if(keys == 3'b001)
						next_state = MOVERIGHT;
					else if(keys[1] == 1'b1)
						next_state = JUMP;
					else
						next_state = STOP;
				end
				JUMP: begin
					next_state = INAIR;
				end
				INAIR: begin
					if(velocity == 3'b101)
						next_state = STOP;
					else
						next_state = INAIR;
				end
				default: next_state = STOP;
			endcase
		end
	end
	
	always@(*)
	begin
		if(!reset)
			playerIntr = 3'b000;
		else begin
			case(current_state)
				STOP: playerIntr = 3'b000;
				MOVELEFT: playerIntr = 3'b100;
				MOVERIGHT: playerIntr = 3'b001;
				JUMP: playerIntr = 3'b010;
				INAIR: playerIntr = 3'b111;
				default: playerIntr = 3'b000;
			endcase
		end
	end
	
	always@(posedge clock)
	begin
		if(!reset)
			current_state <= STOP;
		else if(frameEn) begin
			current_state <= next_state;
		end
	end
endmodule

module movePlayer(input clock, input reset, input gameStart, input frameEn, input [7:0] upleftX, input [6:0] upleftY, input [2:0] playerIntr, 
output reg [7:0] newX, output reg [6:0] newY, output reg [2:0] velocity);
	always@(posedge clock)
	begin
		if(!reset)begin
			velocity <= 3'b0;
			newX <= upleftX;
			newY <= upleftY;
		end	
		if(gameStart & frameEn) begin
			case(playerIntr)
				3'b000: begin
					velocity <= 3'b0;
				end
				3'b100: begin
					newX <= newX - 3'b011;
				end
				3'b001: begin
					newX <= newX + 3'b011;
				end
				3'b010: begin
					velocity <= 3'b011;
				end
				3'b111: begin
					if(velocity != 3'b100) begin
						if(velocity[2] == 1'b0)
							newY <= newY - velocity;
						else
							newY <= newY + 4'b1000 - velocity;
					end
					velocity <= velocity - 1'b1;
				end
				default: begin
					newX <= upleftX;
					newY <= upleftY;
					velocity <= 3'b0;
				end
			endcase
		end
	end
endmodule
