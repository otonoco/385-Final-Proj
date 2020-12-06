module eat_coin (
        input Clk, Reset, frame_Clk,
        input [9:0] mario_x, mario_y,
        input [9:0] coin_x, coin_y,
        input [9:0] luigi_x, luigi_y,
        output coin_alive
);
    logic alive_in;

    always_ff @(posedge Clk)
    begin
        if (Reset)
            begin
                coin_alive <= 1'b1;
            end
        else 
            begin
                coin_alive <= alive_in;
            end
    end

    always_comb
    begin
        alive_in = coin_alive;
        if ((mario_y < coin_y + 10'd28) && (coin_y < mario_y + 10'd28))
            begin
                if ((mario_x < coin_x + 10'd16) && (coin_x < mario_x + 10'd16))
                    begin
                        alive_in = 1'b0;
                    end
                else
                    begin
                        alive_in = 1'b1;
                    end
            end
        else if ((luigi_y < coin_y + 10'd28) && (coin_y < luigi_y + 10'd28))
            begin
                if ((luigi_x < coin_x + 10'd16) && (coin_x < luigi_x + 10'd16))
                    begin
                        alive_in = 1'b0;
                    end
                else
                    begin
                        alive_in = 1'b1;
                    end
            end
        else
            begin
                alive_in = coin_alive;
            end
    end
endmodule