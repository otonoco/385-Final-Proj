module is_castle(
        input [9:0] DrawX, DrawY,  
        input [9:0] process, 
        output logic castle,
        input [9:0] castle_x, castle_y
);

    always_comb
    begin
        if (castle_x < process + DrawX && DrawX + process < castle_x + 10'd64&& DrawY > castle_y && DrawY < castle_y + 10'd88)
            begin
                castle = 1'b1;
            end
        else
            castle = 1'b0;
    end
endmodule 