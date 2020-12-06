module collision(
        input Clk, Reset, frame_Clk,
        input [9:0] mario_x, mario_y,
        input [9:0] gomba_x, gomba_y,
        input [9:0] luigi_x, luigi_y,
        input [9:0] luigi_y_motion,
        input [9:0] mario_y_motion,
        output mario_dead, gomba_dead, luigi_dead
);
    logic mario_dead_in, gomba_dead_in1,gomba_dead_in2,luigi_dead_in;

    always_ff @(posedge Clk)
    begin
        if (Reset)
            begin
                mario_dead <= 1'b0;
                gomba_dead <= 1'b0;
                luigi_dead <= 1'b0;
            end
        else 
            begin
                mario_dead <= mario_dead_in;
                gomba_dead <= gomba_dead_in1 || gomba_dead_in2;
                luigi_dead <= luigi_dead_in;
            end
    end
    
    always_comb
    begin
        mario_dead_in = mario_dead;
        gomba_dead_in1 = gomba_dead;
        if ((mario_y < gomba_y + 10'd32) && (gomba_y < mario_y + 10'd32))
            begin
                if ((mario_x < gomba_x + 10'd32) && (gomba_x < mario_x + 10'd26))
                    begin
                        if ((mario_y_motion > 10'd0) && (~mario_y_motion[9]) && (~mario_dead))
                            begin
                                gomba_dead_in1 = 1'b1;
                            end
                        else if (~gomba_dead)
                            begin
                                mario_dead_in = 1'b1;
                            end
                        else
                            begin
                                mario_dead_in = 1'b0;
                                gomba_dead_in1 = 1'b0;
                            end
                    end
                else
                    begin
                        mario_dead_in = 1'b0;
                        gomba_dead_in1 = 1'b0;
                    end
            end
        else
            begin
                mario_dead_in = mario_dead;
                gomba_dead_in1 = gomba_dead;
            end
		end

	always_comb
	begin
		gomba_dead_in2 = gomba_dead;
        luigi_dead_in = luigi_dead;
        if ((luigi_y < gomba_y + 10'd32) && (gomba_y < luigi_y + 10'd32))
            begin
                if ((luigi_x < gomba_x + 10'd32) && (gomba_x < luigi_x + 10'd26))
                    begin
                        if ((luigi_y_motion > 10'd0) && (~luigi_y_motion[9]) && (~luigi_dead))
                            begin
                                gomba_dead_in2 = 1'b1;
                            end
                        else if (~gomba_dead)
                            begin
                                luigi_dead_in = 1'b1;
                            end
                        else
                            begin
                                luigi_dead_in = 1'b0;
                                gomba_dead_in2 = 1'b0;
                            end
                    end
                else
                    begin
                        luigi_dead_in = 1'b0;
                        gomba_dead_in2 = 1'b0;
                    end
            end
        else
            begin
                gomba_dead_in2 = gomba_dead;
                luigi_dead_in = luigi_dead;
            end
    end
endmodule