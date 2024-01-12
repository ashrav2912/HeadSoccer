module datapath(
	input Clock, Resetn, output reg writeEn,
	input draw_background, draw_left, draw_right, draw_ball, draw_lgoal, draw_rgoal, draw_ground,
	output reg DoneDrawBackground, DoneDrawLPlayer, DoneDrawRPlayer, DoneDrawBall, DoneDrawLGoal, DoneDrawRGoal, DoneDrawGround,
	output reg[5:0] colourOut,
	output reg[7:0] yOut,
	output reg[8:0] xOut);
	
	
	
	
	reg[11:0] leftplayerAddress = 12'd0;
	reg[11:0] rightplayerAddress = 12'd0;
	reg[16:0] backgroundAddress = 17'd0;
	reg[9:0] ballAddress = 10'd0;
	reg[11:0] leftgoalAddress = 12'd0;
	reg[11:0] rightgoalAddress = 12'd0;
	wire[5:0] leftColourToDisplay;
	wire[5:0] rightColourToDisplay;
	wire[5:0] backgroundColourToDisplay;
	wire[5:0] ballColourToDisplay;
	wire[5:0] leftgoalColourToDisplay;
	wire[5:0] rightgoalColourToDisplay;

	left_player player1(
		.address(leftplayerAddress),
		.clock(Clock),
		.data(6'b000000),
		.wren(1'b0), 
		.q(leftColourToDisplay));
		
	right_player player2(
		.address(rightplayerAddress),
		.clock(Clock),
		.data(6'b000000),
		.wren(1'b0),
		.q(rightColourToDisplay));
		
	ball football(
		.address(ballColourToDisplay),
		.clock(Clock),
		.data(6'b000000),
		.wren(1'b0),
		.q(ballColourToDisplay));
				
	left_goal goal1(
		.address(leftgoalAddress),
		.clock(Clock),
		.data(6'b000000),
		.wren(1'b0), 
		.q(leftgoalColourToDisplay));
		
	right_goal goal2(
		.address(rightgoalAddress),
		.clock(Clock),
		.data(6'b000000),
		.wren(1'b0),
		.q(rightgoalColourToDisplay));
		
	reg[7:0] yCount = 8'd0;
	reg[7:0] LcurrentYPosition = 8'd0;
	reg[8:0] xCount = 9'd0;
	reg[8:0] LcurrentXPosition = 9'd0;
	reg[7:0] RcurrentYPosition = 8'd0;
	reg[8:0] RcurrentXPosition = 9'd0;
	reg[7:0] ballcurrentYPosition = 8'd0;
	reg[8:0] ballcurrentXPosition = 9'd0;	
	reg[7:0] LgoalcurrentYPosition = 8'd0;
	reg[8:0] LgoalcurrentXPosition = 9'd0;
	reg[7:0] RgoalcurrentYPosition = 8'd0;
	reg[8:0] RgoalcurrentXPosition = 9'd0;
	reg[7:0] groundcurrentYPosition = 8'd0;
	reg[8:0] groundcurrentXPosition = 9'd0;
	
	
	always@(posedge Clock) begin
		if(Resetn) begin
			backgroundAddress <= 17'd0;
			leftplayerAddress <= 12'd0;
			rightplayerAddress <= 12'd0;
			ballAddress <= 10'd0;
			leftgoalAddress <= 12'd0;
			rightgoalAddress <= 12'd0;
			LcurrentXPosition <= 9'd50;
			LcurrentYPosition <= 8'd160;
			RcurrentXPosition <= 9'd220;
			RcurrentYPosition <= 8'd160;
			ballcurrentXPosition <= 9'd147;
			ballcurrentYPosition <= 8'd185;
			LgoalcurrentXPosition <= 9'd0;
			LgoalcurrentYPosition <= 8'd80;
			RgoalcurrentXPosition <= 9'd287;
			RgoalcurrentYPosition <= 8'd80;
			groundcurrentXPosition <= 9'b0;
			groundcurrentYPosition <= 8'd210;
			xCount <= 9'd0;
			yCount <= 8'd0;
			DoneDrawBackground <= 1'b0;
			DoneDrawLPlayer <= 1'b0;
			DoneDrawRPlayer <= 1'b0;
			writeEn <= 1'b0;
			DoneDrawBall <= 1'b0;
			DoneDrawLGoal <= 1'b0;
			DoneDrawRGoal <= 1'b0;
			DoneDrawGround <= 1'b0;
			colourOut <= 6'b0;
		end
		else if(draw_left && !DoneDrawLPlayer) begin
			colourOut <= leftColourToDisplay;
			xOut <= LcurrentXPosition + xCount;
			yOut <= LcurrentYPosition + yCount;
			writeEn <= 1'b1;
			
			if(xCount == 9'd49 && yCount == 8'd49) begin
				xCount <= 9'd0;
				yCount <= 8'd0;
				LcurrentXPosition <= 9'd50;
				LcurrentYPosition <= 8'd160;
				leftplayerAddress <= 12'd0;
				DoneDrawLPlayer <= 1'b1;
				writeEn <= 1'b0;
			end
			else if(xCount == 9'd49) begin
				xCount <= 9'd0;
				yCount <= yCount + 8'd1;
				leftplayerAddress <= leftplayerAddress + 12'd1;
				DoneDrawLPlayer <= 1'b0;
			end
			else begin
				xCount <= xCount + 9'd1;
				leftplayerAddress <= leftplayerAddress + 12'd1;
				DoneDrawLPlayer <= 1'b0;
			end
		end
		
		else if(draw_left && !DoneDrawLPlayer) begin
			colourOut <= leftColourToDisplay;
			xOut <= LcurrentXPosition + xCount;
			yOut <= LcurrentYPosition + yCount;
			writeEn <= 1'b1;
			
			if(xCount == 9'd49 && yCount == 8'd49) begin
				xCount <= 9'd0;
				yCount <= 8'd0;
				LcurrentXPosition <= 9'd50;
				LcurrentYPosition <= 8'd160;
				leftplayerAddress <= 12'd0;
				//backgroundAddress <= {1'b0, yOut, 8'd0} + {1'b0, yOut, 6'd0} + {1'b0, xOut};
				DoneDrawLPlayer <= 1'b1;
				writeEn <= 1'b0;
			end
			else if(xCount == 9'd49) begin
				xCount <= 9'd0;
				yCount <= yCount + 8'd1;
				leftplayerAddress <= leftplayerAddress + 12'd1;
				DoneDrawLPlayer <= 1'b0;
			end
			else begin
				xCount <= xCount + 9'd1;
				leftplayerAddress <= leftplayerAddress + 12'd1;
				DoneDrawLPlayer <= 1'b0;
			end
		end
		
		else if(draw_right && !DoneDrawRPlayer & DoneDrawLPlayer)
		begin
			colourOut <= rightColourToDisplay;
			xOut <= RcurrentXPosition + xCount;
			yOut <= RcurrentYPosition + yCount;
			writeEn <= 1'b1;
			
			if(xCount == 9'd49 && yCount == 8'd49) begin
				xCount <= 9'd0;
				yCount <= 8'd0;
				RcurrentXPosition <= 9'd220;
				RcurrentYPosition <= 8'd160;
				rightplayerAddress <= 12'd0;
				DoneDrawRPlayer <= 1'b1;
				writeEn <= 1'b0;
			end
			else if(xCount == 9'd49) begin
				xCount <= 9'd0;
				yCount <= yCount + 8'd1;
				rightplayerAddress <= rightplayerAddress + 12'd1;
				DoneDrawRPlayer <= 1'b0;
			end
			else begin
				xCount <= xCount + 9'd1;
				rightplayerAddress <= rightplayerAddress + 12'd1;
				DoneDrawRPlayer <= 1'b0;
			end
		end
		
		else if(draw_ball & DoneDrawRPlayer & !DoneDrawBall)
		begin
			colourOut <= ballColourToDisplay;
			xOut <= ballcurrentXPosition + xCount;
			yOut <= ballcurrentYPosition + yCount;
			writeEn <= 1'b1;
			
			if(xCount == 9'd24 && yCount == 8'd24) begin
				xCount <= 9'd0;
				yCount <= 8'd0;
				ballcurrentXPosition <= 9'd147;
				ballcurrentYPosition <= 8'd185;
				ballAddress <= 12'd0;
				DoneDrawBall <= 1'b1;
				writeEn <= 1'b0;
			end
			else if(xCount == 9'd24) begin
				xCount <= 9'd0;
				yCount <= yCount + 8'd1;
				ballAddress <= ballAddress + 10'd1;
				DoneDrawBall <= 1'b0;
			end
			else begin
				xCount <= xCount + 9'd1;
				ballAddress <= ballAddress + 10'd1;
				DoneDrawBall <= 1'b0;
			end
		end
		
		else if(draw_lgoal && !DoneDrawLGoal && DoneDrawBall) begin
			colourOut <= leftgoalColourToDisplay; 
			xOut <= LgoalcurrentXPosition + xCount;
			yOut <= LgoalcurrentYPosition + yCount;
			writeEn <= 1'b1;
			
			if(xCount == 9'd31 && yCount == 8'd129) begin
				xCount <= 9'd0;
				yCount <= 8'd0;
				LcurrentXPosition <= 9'd0;
				LcurrentYPosition <= 8'd80;
				leftgoalAddress <= 12'd0;
				DoneDrawLGoal <= 1'b1;
				writeEn <= 1'b0;
			end
			else if(xCount == 9'd31) begin
				xCount <= 9'd0;
				yCount <= yCount + 8'd1;
				leftgoalAddress <= leftgoalAddress + 12'd1;
				DoneDrawLGoal <= 1'b0;
			end
			else begin
				xCount <= xCount + 9'd1;
				leftgoalAddress <= leftgoalAddress + 12'd1;
				DoneDrawLGoal <= 1'b0;
			end
		end
		
		else if(draw_rgoal && !DoneDrawRGoal && DoneDrawLGoal) begin
			colourOut <= rightgoalColourToDisplay;
			xOut <= RgoalcurrentXPosition + xCount;
			yOut <= RgoalcurrentYPosition + yCount;
			writeEn <= 1'b1;
			
			if(xCount == 9'd31 && yCount == 8'd129) begin
				xCount <= 9'd0;
				yCount <= 8'd0;
				RgoalcurrentXPosition <= 9'd287;
				RgoalcurrentYPosition <= 8'd80;
				rightgoalAddress <= 12'd0;
				DoneDrawRGoal <= 1'b1;
				writeEn <= 1'b0;
			end
			else if(xCount == 9'd31) begin
				xCount <= 9'd0;
				yCount <= yCount + 8'd1;
				rightgoalAddress <= rightgoalAddress + 12'd1;
				DoneDrawRGoal <= 1'b0;
			end
			else begin
				xCount <= xCount + 9'd1;
				rightgoalAddress <= rightgoalAddress + 12'd1;
				DoneDrawRGoal <= 1'b0;
			end
		end
		
		else if(draw_ground && DoneDrawRGoal && !DoneDrawGround) begin
			colourOut <= 6'b111111;
			xOut <= groundcurrentXPosition + xCount;
			yOut <= groundcurrentYPosition + yCount;
			writeEn <= 1'b1;
			
			if(xCount == 9'd319) begin
				xCount <= 9'd0;
				yCount <= 8'd0;
				groundcurrentXPosition <= 9'd0;
				groundcurrentYPosition <= 8'd209;
				DoneDrawGround <= 1'b1;
				writeEn <= 1'b0;
			end
			else if(xCount == 9'd319) begin
				xCount <= 9'd0;
				DoneDrawGround <= 1'b0;
			end
			else begin
				xCount <= xCount + 9'd1;
				DoneDrawGround <= 1'b0;
			end
		end
		end
			
endmodule

