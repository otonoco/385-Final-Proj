//This is the Colour Mapper module.

module  color_mapper (
        input mario, 
        input [9:0] DrawX, DrawY, 
        input [23:0] mario_pic_out,

        output logic [7:0] Red, Green, Blue
);
    logic [7:0] VGA_R, VGA_B, VGA_G;

    assign Red = VGA_R;
    assign Blue = VGA_B;
    assign Green = VGA_G;

    always_comb
    begin
        if (mario)
            begin
                VGA_R = mario_pic_out[23:16];
                VGA_G = mario_pic_out[15:8];
                VGA_B = mario_pic_out[7:0];
            end
        else
            begin
                VGA_R = 8'h00; 
                VGA_G = 8'hff;
                VGA_B = 8'h00;
            end
    end
endmodule