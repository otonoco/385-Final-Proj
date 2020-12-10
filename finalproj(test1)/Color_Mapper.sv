//This is the Colour Mapper module.

module  color_mapper (
        // input mario, 
        input blank,
        input mariod,
        input luigi,
        input coin1,
        input coin2,
        input gomba,
        input mariod_dead,
        input luigi_dead,
        input endd,
        input pipe_1,pipe_2,
        input castle,
        input [9:0] DrawX, DrawY, 
        input [23:0] mario_pic_out,
        input [23:0] mariod_pic_out,
        input [23:0] luigi_pic_out,
        input [23:0] gomba_pic_out,
        input [23:0] coin1_pic_out,
        input [23:0] coin2_pic_out,
        input [23:0] ground, cloud, pipe1, pipe2, end_p, back1, back2, castle_p,

        output logic [7:0] Red, Green, Blue
);
    logic [7:0] VGA_R, VGA_B, VGA_G;

    assign Red = VGA_R;
    assign Blue = VGA_B;
    assign Green = VGA_G;
    logic [10:0] sprite_addr;
    logic [7:0] sprite_data;
    logic shape1_on, shape2_on, shape3_on, shape4_on, shape5_on, shape6_on, shape7_on, shape8_on, shape9_on;
    logic [10:0] shape1_x = 280;
    logic [10:0] shape1_y = 240;
    logic [10:0] shape2_x = 290;
    logic [10:0] shape2_y = 240;
    logic [10:0] shape3_x = 300;
    logic [10:0] shape3_y = 240;
    logic [10:0] shape4_x = 310;
    logic [10:0] shape4_y = 240;
    logic [10:0] shape5_x = 320;
    logic [10:0] shape5_y = 240;
    logic [10:0] shape6_x = 330;
    logic [10:0] shape6_y = 240;
    logic [10:0] shape7_x = 340;
    logic [10:0] shape7_y = 240;
    logic [10:0] shape8_x = 350;
    logic [10:0] shape8_y = 240;
    logic [10:0] shape9_x = 360;
    logic [10:0] shape9_y = 240;
    logic [10:0] shape1_size_x = 8;
    logic [10:0] shape1_size_y = 16;
    logic [10:0] shape2_size_x = 8;
    logic [10:0] shape2_size_y = 16;
    logic [10:0] shape3_size_x = 8;
    logic [10:0] shape3_size_y = 16;
    logic [10:0] shape4_size_x = 8;
    logic [10:0] shape4_size_y = 16;
    logic [10:0] shape5_size_x = 8;
    logic [10:0] shape5_size_y = 16;
    logic [10:0] shape6_size_x = 8;
    logic [10:0] shape6_size_y = 16;
    logic [10:0] shape7_size_x = 8;
    logic [10:0] shape7_size_y = 16;
    logic [10:0] shape8_size_x = 8;
    logic [10:0] shape8_size_y = 16;
    logic [10:0] shape9_size_x = 8;
    logic [10:0] shape9_size_y = 16;
    font_rom fr(.addr(sprite_addr),.data(sprite_data));

    always_comb
    begin
        if (blank)
            begin
                if (~mariod_dead || ~luigi_dead)
                    begin
                        shape1_on = 1'b0;
                        shape2_on = 1'b0;
                        shape3_on = 1'b0;
                        shape4_on = 1'b0;
                        shape5_on = 1'b0;
                        shape6_on = 1'b0;
                        shape7_on = 1'b0;
                        shape8_on = 1'b0;
                        shape9_on = 1'b0;
                        sprite_addr = 1'b0;
                        if (mariod)
                            begin
                                VGA_R = mariod_pic_out[23:16];
                                VGA_G = mariod_pic_out[15:8];
                                VGA_B = mariod_pic_out[7:0];
                            end
                        else if (luigi)
                            begin
                                VGA_R = luigi_pic_out[23:16];
                                VGA_G = luigi_pic_out[15:8];
                                VGA_B = luigi_pic_out[7:0];
                            end
                        else  if (gomba)
                            begin
                                VGA_R = gomba_pic_out[23:16];
                                VGA_G = gomba_pic_out[15:8];
                                VGA_B = gomba_pic_out[7:0];
                            end
                        else if (coin1)
                            begin
                                VGA_R = coin1_pic_out[23:16];
                                VGA_G = coin1_pic_out[15:8];
                                VGA_B = coin1_pic_out[7:0];
                            end
                        else if (coin2)
                            begin
                                VGA_R = coin2_pic_out[23:16];
                                VGA_G = coin2_pic_out[15:8];
                                VGA_B = coin2_pic_out[7:0];
                            end
                        else if (DrawY >= 10'd416)
                            begin
                                VGA_R = ground[23:16];
                                VGA_G = ground[15:8];
                                VGA_B = ground[7:0];
                            end
                            else if (DrawY>=10'd32 && DrawY < 10'd100)
                            begin
                                VGA_R = cloud[23:16];
                                VGA_G = cloud[15:8];
                                VGA_B = cloud[7:0];
                            end
                        // 障碍物贴图方式同 coin 
                        else if (pipe_1)
                            begin
                                VGA_R = pipe1[23:16];
                                VGA_G = pipe1[15:8];
                                VGA_B = pipe1[7:0];
                            end
                        else if (pipe_2)
                            begin
                                VGA_R = pipe2[23:16];
                                VGA_G = pipe2[15:8];
                                VGA_B = pipe2[7:0];
                            end
                        else if (castle)
                                begin
                                VGA_R = castle_p[23:16];
                                VGA_G = castle_p[15:8];
                                VGA_B = castle_p[7:0];
                            end
                        else 
                            begin
                                VGA_R = 8'h6b;
                                VGA_G = 8'h8c;
                                VGA_B = 8'hff;
                            end
                        // else if (DrawY > 10'd100 && DrawY <= 10'd150)
                        //     begin
                        //         VGA_R = back1[23:16]; 
                        //         VGA_G = back1[15:8];
                        //         VGA_B = back1[7:0];
                        //     end
                        // else if (DrawY > 10'd100 && DrawY <= 10'd150)
                        //     begin
                        //         VGA_R = back2[23:16]; 
                        //         VGA_G = back2[15:8];
                        //         VGA_B = back2[7:0];
                        //     end
                        // else if (DrawY > 10'd150 && DrawY <= 10'd200)
                        //     begin
                        //         VGA_R = back1[23:16]; 
                        //         VGA_G = back1[15:8];
                        //         VGA_B = back1[7:0];
                        //     end
                        // else if (DrawY > 10'd200 && DrawY <= 10'd250)
                        //     begin
                        //         VGA_R = back2[23:16]; 
                        //         VGA_G = back2[15:8];
                        //         VGA_B = back2[7:0];
                        //     end
                        // else if (DrawY > 10'd250 && DrawY <= 10'd300)
                        //     begin
                        //         VGA_R = back1[23:16]; 
                        //         VGA_G = back1[15:8];
                        //         VGA_B = back1[7:0];
                        //     end
                        // else if (DrawY > 10'd300 && DrawY < 10'd350)
                        //     begin
                        //         VGA_R = back2[23:16]; 
                        //         VGA_G = back2[15:8];
                        //         VGA_B = back2[7:0];
                        //     end
                        // else
                        //     begin
                        //         VGA_R = back1[23:16]; 
                        //         VGA_G = back1[15:8];
                        //         VGA_B = back1[7:0];
                        //     end
                    end
                else

                    begin	
                        if (DrawX >= shape1_x && DrawX < shape1_x + shape1_size_x && DrawY >= shape1_y && DrawY < shape1_y + shape1_size_y)
                            begin
                                shape1_on = 1'b1;
                                shape2_on = 1'b0;
                                shape3_on = 1'b0;
                                shape4_on = 1'b0;
                                shape5_on = 1'b0;
                                shape6_on = 1'b0;
                                shape7_on = 1'b0;
                                shape8_on = 1'b0;
                                shape9_on = 1'b0;
                                sprite_addr = (DrawY - shape1_y + 16 *'h47);
                            end
                        else if (DrawX >= shape2_x && DrawX < shape2_x + shape2_size_x && DrawY >= shape2_y && DrawY < shape2_y + shape2_size_y)
                            begin
                                shape1_on = 1'b0;
                                shape2_on = 1'b1;
                                shape3_on = 1'b0;
                                shape4_on = 1'b0;
                                shape5_on = 1'b0;
                                shape6_on = 1'b0;
                                shape7_on = 1'b0;
                                shape8_on = 1'b0;
                                shape9_on = 1'b0;
                                sprite_addr = (DrawY - shape2_y + 16 *'h41);
                            end
                        else if (DrawX >= shape3_x && DrawX <shape3_x + shape3_size_x && DrawY >= shape3_y && DrawY < shape3_y + shape3_size_y)
                            begin
                                shape1_on = 1'b0;
                                shape2_on = 1'b0;
                                shape3_on = 1'b1;
                                shape4_on = 1'b0;
                                shape5_on = 1'b0;
                                shape6_on = 1'b0;
                                shape7_on = 1'b0;
                                shape8_on = 1'b0;
                                shape9_on = 1'b0;
                                sprite_addr = (DrawY - shape3_y + 16 * 'h4d);
                            end
                        else if (DrawX >= shape4_x && DrawX < shape4_x + shape4_size_x && DrawY >= shape4_y && DrawY < shape4_y + shape4_size_y)
                            begin
                                shape1_on = 1'b0;
                                shape2_on = 1'b0;
                                shape3_on = 1'b0;
                                shape4_on = 1'b1;
                                shape5_on = 1'b0;
                                shape6_on = 1'b0;
                                shape7_on = 1'b0;
                                shape8_on = 1'b0;
                                shape9_on = 1'b0;
                                sprite_addr = (DrawY - shape4_y + 16 *'h45);
                            end
                        else if (DrawX >= shape5_x && DrawX < shape5_x + shape5_size_x && DrawY >= shape5_y && DrawY < shape5_y + shape5_size_y)
                            begin
                                shape1_on = 1'b0;
                                shape2_on = 1'b0;
                                shape3_on = 1'b0;
                                shape4_on = 1'b0;
                                shape5_on = 1'b1;
                                shape6_on = 1'b0;
                                shape7_on = 1'b0;
                                shape8_on = 1'b0;
                                shape9_on = 1'b0;
                                sprite_addr = (DrawY - shape5_y + 16 *'h2d);
                            end
                        else if(DrawX >= shape6_x && DrawX < shape6_x + shape6_size_x && DrawY >= shape6_y && DrawY < shape6_y + shape6_size_y)
                            begin
                                shape1_on = 1'b0;
                                shape2_on = 1'b0;
                                shape3_on = 1'b0;
                                shape4_on = 1'b0;
                                shape5_on = 1'b0;
                                shape6_on = 1'b1;
                                shape7_on = 1'b0;
                                shape8_on = 1'b0;
                                shape9_on = 1'b0;
                                sprite_addr = (DrawY - shape6_y + 16 *'h4f);
                            end
                        else if (DrawX >= shape7_x && DrawX < shape7_x + shape7_size_x && DrawY >= shape7_y && DrawY < shape7_y + shape7_size_y)
                            begin
                                shape1_on = 1'b0;
                                shape2_on = 1'b0;
                                shape3_on = 1'b0;
                                shape4_on = 1'b0;
                                shape5_on = 1'b0;
                                shape6_on = 1'b0;
                                shape7_on = 1'b1;
                                shape8_on = 1'b0;
                                shape9_on = 1'b0;
                                sprite_addr = (DrawY - shape7_y + 16 *'h56);
                            end
                        else if (DrawX >= shape8_x && DrawX < shape8_x + shape8_size_x && DrawY >= shape8_y && DrawY < shape8_y + shape8_size_y)
                            begin
                                shape1_on = 1'b0;
                                shape2_on = 1'b0;
                                shape3_on = 1'b0;
                                shape4_on = 1'b0;
                                shape5_on = 1'b0;
                                shape6_on = 1'b0;
                                shape7_on = 1'b0;
                                shape8_on = 1'b1;
                                shape9_on = 1'b0;
                                sprite_addr = (DrawY - shape8_y + 16 *'h45);
                            end
                        else if (DrawX >= shape9_x && DrawX < shape9_x + shape9_size_x && DrawY >= shape9_y && DrawY < shape9_y + shape9_size_y)
                            begin
                                shape1_on = 1'b0;
                                shape2_on = 1'b0;
                                shape3_on = 1'b0;
                                shape4_on = 1'b0;
                                shape5_on = 1'b0;
                                shape6_on = 1'b0;
                                shape7_on = 1'b0;
                                shape8_on = 1'b0;
                                shape9_on = 1'b1;
                                sprite_addr = (DrawY - shape9_y + 16 *'h52);
                            end
                        else
                            begin
                                shape1_on = 1'b0;
                                shape2_on = 1'b0;
                                shape3_on = 1'b0;
                                shape4_on = 1'b0;
                                shape5_on = 1'b0;
                                shape6_on = 1'b0;
                                shape7_on = 1'b0;
                                shape8_on = 1'b0;
                                shape9_on = 1'b0;
                                sprite_addr = 1'b0;
                            end
                        
                        if (shape1_on == 1'b1 && sprite_data[DrawX - shape1_x] == 1'b1)
                            begin
                                VGA_R = 8'hff; 
                                VGA_G = 8'hff;
                                VGA_B = 8'hff;
                            end
                        else if (shape2_on == 1'b1 && sprite_data[DrawX - shape2_x] == 1'b1)
                            begin
                                VGA_R = 8'hff; 
                                VGA_G = 8'hff;
                                VGA_B = 8'hff;
                            end
                        else if (shape3_on == 1'b1 && sprite_data[DrawX - shape3_x] == 1'b1)
                            begin
                                VGA_R = 8'hff; 
                                VGA_G = 8'hff;
                                VGA_B = 8'hff;
                            end
                        else if (shape4_on == 1'b1 && sprite_data[DrawX - shape4_x] == 1'b1)
                            begin
                                VGA_R = 8'hff; 
                                VGA_G = 8'hff;
                                VGA_B = 8'hff;
                            end
                        else if (shape5_on == 1'b1 && sprite_data[DrawX - shape5_x] == 1'b1)
                            begin
                                VGA_R = 8'hff; 
                                VGA_G = 8'hff;
                                VGA_B = 8'hff;
                            end
                        else if (shape6_on == 1'b1 && sprite_data[DrawX - shape6_x] == 1'b1)
                            begin
                                VGA_R = 8'hff; 
                                VGA_G = 8'hff;
                                VGA_B = 8'hff;
                            end
                        else if (shape7_on == 1'b1 && sprite_data[DrawX - shape7_x] == 1'b1)
                            begin
                                VGA_R = 8'hff; 
                                VGA_G = 8'hff;
                                VGA_B = 8'hff;
                            end
                        else if (shape8_on == 1'b1 && sprite_data[DrawX - shape8_x] == 1'b1)
                            begin
                                VGA_R = 8'hff; 
                                VGA_G = 8'hff;
                                VGA_B = 8'hff;
                            end
                        else if (shape9_on == 1'b1 && sprite_data[DrawX - shape9_x] == 1'b1)
                            begin
                                VGA_R = 8'hff; 
                                VGA_G = 8'hff;
                                VGA_B = 8'hff;
                            end
                        else
                            begin
                                VGA_R = 8'h00; 
                                VGA_G = 8'h00;
                                VGA_B = 8'h00;
                            end
                    end
            end
        else
            begin
                VGA_R = 8'h00; 
                VGA_G = 8'h00;
                VGA_B = 8'h00;
            end
    end
endmodule