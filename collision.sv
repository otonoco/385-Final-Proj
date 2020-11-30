module collision(
        input Clk, Reset, frame_Clk,
        input [9:0] mario_x, mario_y,
        input [9:0] gomba_x, gomba_y,
        input [9:0] mario_y_motion,
        output mario_dead, gomba_dead
);
    logic mario_dead_in, gomba_dead_in;

    always_ff @(posedge Clk)
    begin
        if (Reset)
            begin
                mario_dead <= 1'b0;
                gomba_dead <= 1'b0;
            end
        else 
            begin
                mario_dead <= mario_dead_in;
                gomba_dead <= gomba_dead_in;
            end
    end
    
    always_comb
    begin
        mario_dead_in = mario_dead;
        gomba_dead_in = gomba_dead;
        if ((mario_y < gomba_y + 10'd32) && (gomba_y < mario_y + 10'd32))
            begin
                if ((mario_x < gomba_x + 10'd32) && (gomba_x < mario_x + 10'd26))
                    begin
                        if ((mario_y_motion > 10'd0) && (~mario_y_motion[10]) && (~mario_dead))
                            begin
                                gomba_dead_in = 1'b1;
                            end
                        else if (~gomba_dead)
                            begin
                                mario_dead_in = 1'b1;
                            end
                        else
                            begin
                                mario_dead_in = 1'b0;
                                gomba_dead_in = 1'b0;
                            end
                    end
                else
                    begin
                        mario_dead_in = 1'b0;
                        gomba_dead_in = 1'b0;
                    end
            end
        else
            begin
                mario_dead_in = mario_dead;
                gomba_dead_in = gomba_dead;
            end
    end
endmodule