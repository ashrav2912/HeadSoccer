module ball
#(parameter playerWidth = 4'd10, playerHeight = 6'd50, leftGoal = 5'd16, rightGoal = 8'd144, radius = 4'd10, ground = 8'd145, goalHeight = 7'd65)
(input clock, input reset, input gameStart, input [7:0] oPlayerAulX,oPlayerBulX, input [6:0] oPlayerAulY, oPlayerBulY, input [7:0] centerX,
input [6:0] centerY, output [7:0] oCenterX, output [6:0] oCenterY);
	wire flying, touchGround;
	wire [1:0] touchPlayer, goal;	
	controlBall #(.playerWidth(playerWidth), .playerHeight(playerHeight), .leftGoal(leftGoal), .rightGoal(rightGoal), .radius(radius), .ground(ground), .goalHeight(goalHeight))
	cb0(clock, reset, gameStart, oPlayerAulX, oPlayerAulY, oPlayerBulX, oPlayerBulY, oCenterX, oCenterY, flying, touchGround, touchPlayer, goal);
	moveBall #(.playerWidth(playerWidth), .playerHeight(playerHeight), .leftGoal(leftGoal), .rightGoal(rightGoal), .radius(radius), .ground(ground), .goalHeight(goalHeight))
	mb0(clock, reset, gameStart, centerX, centerY, touchPlayer, touchGround, flying, goal, oCenterX, oCenterY);
endmodule

module controlBall 
#(parameter playerWidth = 4'd10, playerHeight = 6'd50, leftGoal = 5'd16, rightGoal = 8'd144, radius = 4'd10, ground = 8'd145, goalHeight = 7'd65)
(input clock, input reset, input gameStart, input [7:0] playerAulX, 
input [6:0] playerAulY, input [7:0] playerBulX, input [6:0] playerBulY, input [7:0] centerX,
input [6:0] centerY, output reg flying, output reg touchGround, output reg [1:0] touchPlayer, output reg [1:0] goal);
	reg [2:0] current_state, next_state;
	localparam STOP = 3'd0,
				  TOUCHGROUND = 3'd1,
				  TOUCHPLAYER = 3'd2,
				  TOUCHRIGHTGOAL = 3'd3,
				  TOUCHLEFTGOAL= 3'd4,
				  FLYING = 3'd6;
	wire test;
	assign test = centerY<=(playerAulY+playerHeight);
	assign touchPlayerRight = ((centerX-playerAulX-playerWidth)*(centerX-playerAulX-playerWidth) + (centerY-playerAulY)*(centerY-playerAulY) <= radius * radius 
							  & centerY<=playerAulY & centerY>=playerAulY-radius & centerX - playerAulX - playerWidth <= radius & centerX >= playerAulX + playerWidth) |
							  ((centerX - playerAulX - playerWidth)<=radius & centerY<=playerAulY+playerHeight & centerY>=playerAulY) |
							  (playerAulY - centerY <= radius & centerX>=playerAulX & centerX<=playerAulX+playerWidth)  |
							  
							  (((centerX-playerBulX-playerWidth)*(centerX-playerBulX-playerWidth) + (centerY-playerBulY)*(centerY-playerBulY) <= radius * radius 
							  & centerY<=playerBulY & centerY>=playerBulY-radius & centerX - playerBulX - playerWidth <= radius & centerX >= playerBulX + playerWidth) |
							  ((centerX - playerBulX - playerWidth)<=radius & centerY<=playerBulY+playerHeight & centerY>=playerBulY));
							  
	assign touchPlayerLeft = (((-centerX+playerAulX)<=radius & centerY<=playerAulY+playerHeight & centerY>=playerAulY) |
									  ((centerX-playerAulX)*(centerX-playerAulX) + (centerY-playerAulY)*(centerY-playerAulY) <= radius * radius 
									  & centerY<=playerAulY & centerY>=playerAulY-radius & playerAulX - centerX <= radius & centerX <= playerAulX)) |
									  
									  ((-centerX+playerBulX)<=radius & centerY<=playerBulY+playerHeight & centerY>=playerBulY) |
									  ((centerX-playerBulX)*(centerX-playerBulX) + (centerY-playerBulY)*(centerY-playerBulY) <= radius * radius 
									  & centerY<=playerBulY & centerY>=playerBulY-radius & playerBulX - centerX <= radius & centerX <= playerBulX) |
									  (playerBulY - centerY <= radius & centerX>=playerBulX & centerX<=playerBulX+playerWidth) ;
									  
	always@(*)
	begin
		case(current_state)
			STOP: begin
				if((rightGoal-centerX)<=radius & ground - centerY<=goalHeight & ground - centerY>=radius)
					next_state = TOUCHRIGHTGOAL;
				else if((centerX - leftGoal)<=radius & ground - centerY<=goalHeight & ground - centerY>=radius)
					next_state = TOUCHLEFTGOAL;
				else if(touchPlayerLeft | touchPlayerRight)	
					next_state = TOUCHPLAYER;
				else if(ground - centerY<=radius)
					next_state = TOUCHGROUND;
				else 
					next_state = STOP;
			end
			TOUCHGROUND: next_state = STOP;
			TOUCHPLAYER: next_state = FLYING;
			FLYING: begin
				if((rightGoal-centerX)<=radius & ground - centerY<=goalHeight)
					next_state = TOUCHRIGHTGOAL;
				else if((centerX - leftGoal)<=radius & ground - centerY<=goalHeight)
					next_state = TOUCHLEFTGOAL;
				else if(touchPlayer)
					next_state = TOUCHPLAYER;
				else if(ground - centerY<=radius)
					next_state = TOUCHGROUND;
				else
					next_state = FLYING;
			end
			TOUCHRIGHTGOAL: begin
				next_state = STOP;
			end
			default: next_state = STOP;
		endcase	
	end
	
	always@(*)
	begin
		if(reset) begin
			touchGround = 1'b0;
			touchPlayer = 2'b0;
			goal = 2'b00;
			flying = 1'b0;
		end
		else begin
			case(current_state)
				TOUCHPLAYER: begin
					if(touchPlayerLeft) begin
						touchPlayer = 2'b01;
					end
					else if(touchPlayerRight) begin
						touchPlayer = 2'b11;
					end
				end
				TOUCHGROUND: begin
					touchGround = 1'b1;
					flying = 1'b0;
				end
				TOUCHRIGHTGOAL: goal = 2'b11;
				TOUCHLEFTGOAL: goal = 2'b10;
				FLYING: flying = 1'b1;
				default: begin
					touchGround = 1'b0;
					touchPlayer = 2'b0;
					goal = 2'b00;
					flying = 1'b0;
				end
			endcase
		end
	end
	
	always@(posedge clock)
	begin
		if(reset)
			current_state <= STOP;
		else if(gameStart) begin
			current_state <= next_state;
		end
	end
endmodule

module moveBall #(parameter playerWidth = 4'd10, playerHeight = 6'd50, 
leftGoal = 5'd16, rightGoal = 8'd144, radius = 4'd10, ground = 8'd145, goalHeight = 7'd65)
(input clock, input reset, input gameStart, input [7:0] centerX, input [6:0] centerY, input [1:0] touchPlayer, input touchGround, flying, input [1:0] goal,
 output reg [7:0] oCenterX, output reg [6:0] oCenterY);
	reg [2:0] velX;
	reg [3:0] velY;
	
	always@(posedge clock)
	begin
		if(reset) begin
			velX <= 3'b0;
			velY <= 4'b0;
			oCenterX <= centerX;
			oCenterY <= centerY;
		end
		else begin
			if(touchGround) begin
				velX <= 3'b0;
				velY <= 4'b0;
			end
			else if(touchPlayer[0] == 1'b1 & !flying) begin
				if(velX == 3'b0 & velY == 4'b0 & touchPlayer[1] == 1'b0) begin
					velX <= 3'b101;
					velY <= 4'b0111;
				end
				else if(velX == 3'b0 & velY == 4'b0 & touchPlayer[1] == 1'b1) begin
					velX <= 3'b011;
					velY <= 4'b0111;
				end
				else if(velX != 3'b0 & velY != 4'b0) begin
					velX <= 3'b000 - velX;
				end
			end
			else if(goal[1] == 1'b1) begin
				velX <= 3'b0;
				velY <= 4'b0;
			end
			else if(flying) begin
				if(velX[2] == 1'b0)
					oCenterX <= oCenterX + velX;
				else
					oCenterX <= oCenterX - 4'b1000 + velX;
				if(velY[3] == 1'b0)
					oCenterY <= oCenterY - velY;
				else 
					oCenterY <= oCenterY + 5'b10000 - velY;
				velY <= velY - 1'b1;
			end
			else if(oCenterY<=radius) begin
				velY <= 5'b10000 - velY;
			end
			else if(oCenterX<=radius | 8'd160-oCenterX<=radius) begin
				velX <= 4'b1000 - velX;
			end
		end
			
	end
endmodule	
				
			
		
	
