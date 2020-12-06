module SCREEN_CONTROL (
        input playernum_select,mario_alive,GAMEEND,
        input Clk,
        output logic [3:0] phase
);

always_ff @ (posedge CLK) begin
	
	if (RESET)	
		state <=STARTER;		
	else
		state <= next_state;		
	end
	
    enum logic [1:0] {STARTER,
                      GAME,
							 DEAD,
                      END} state,next_state;

	always_comb begin
		unique case(state)
			STARTER:
				begin
					if(playernum_select)
						begin
							next_state = GAME;
						end
					else
						begin
							next_state = STARTER;
			GAME:
				begin
					if(mario_alive & ~GAMEEND)
						begin
							next_state = GAME;
						end
					else if(mario_alive & GAMEEND)
						begin
							next_state = END;
						end
					else
						begin
							next_state = DEAD;
						end
			DEAD:
				begin
					next_state = DEAD;
				end
			END:
				begin
					next_state = END;
				end
		endcase
		case(state)
		STARTER:begin
			phase = 4'b1000;
			end
		GAME:begin
			phase = 4'b0100;
			end		
		DEAD:begin
			phase = 4'b0010;
			end
		END:begin
			phase = 4'b0001;
			end
		endcase
		
		
endmodule