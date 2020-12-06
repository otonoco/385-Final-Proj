module wall (
        input [9:0] DrawX, DrawY,

        output logic wall,
        output logic brick,
        output logic [8:0] wall_pic_addr
);
    parameter [4:0] height = 5'd20;

    always_comb
    begin
        if (DrawX > 0 && DrawX < 640 && DrawY > 460 && DrawY < 460 + height)
            begin
                wall = 1'b1;
                brick = 1'b0;
            end
        else
            begin
                wall = 1'b0;
                brick = 1'b0;
            end

        if (wall)
            begin
                wall_pic_addr = (DrawX % height) + (DrawY % height) * height;
            end
        else
            begin
                wall_pic_addr = 9'b0;
            end
    end

    

endmodule