module is_pipe(
        input [9:0] DrawX, DrawY,  
        input [9:0] process, 
        input [9:0] pipe_x, pipe_y,
        output logic pipe
);

    always_comb
    begin
        if (pipe_x < process + DrawX && DrawX + process < pipe_x + 10'd62 && DrawY > pipe_y && DrawY < pipe_y + 10'd64)
            begin
                pipe = 1'b1;
            end
        else
            pipe = 1'b0;
    end
endmodule 