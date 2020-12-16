//This is the Colour Mapper module.

module  color_mapper (
        input mariod,
        input luigi,
        input coin1, coin3, coin4, coin5, coin6, coin7,
        input coin2,
        input gomba,
        input start,
        input mariod_dead,
        input luigi_dead,
        input pipe_1, pipe_2,
        input castle,
        input mario_arrived,
        input luigi_arrived,
        input blank,
        input [2:0] score,
        input [9:0] DrawX, DrawY, 
        input [23:0] mario_pic_out,
        input [23:0] mariod_pic_out,
        input [23:0] luigi_pic_out,
        input [23:0] gomba_pic_out,
        input [23:0] coin1_pic_out,
        input [23:0] coin2_pic_out,
        input [23:0] coin3_pic_out,
        input [23:0] coin4_pic_out,
        input [23:0] coin5_pic_out,
        input [23:0] coin6_pic_out,
        input [23:0] coin7_pic_out,
        input [23:0] ground, cloud, pipe1, pipe2, back1, back2, castle_p,

        output logic [7:0] Red, Green, Blue
);
    logic [7:0] VGA_R, VGA_B, VGA_G;

    assign Red = VGA_R;
    assign Blue = VGA_B;
    assign Green = VGA_G;
    logic [10:0] sprite_addr;
    logic [7:0] sprite_data;
    logic shape31_on, shape32_on, shape33_on, shape34_on, shape35_on, shape36_on, shape37_on;
    logic shape21_on, shape22_on, shape23_on, shape24_on, shape25_on, shape26_on, shape27_on, shape28_on, shape29_on, shape210_on, shape211_on, shape212_on, shape213_on, shape214_on, shape215_on, shape216_on;
    logic shape217_on, shape218_on, shape219_on, shape220_on, shape221_on, shape222_on, shape223_on, shape224_on, shape225_on, shape226_on, shape227_on, shape228_on, shape229_on, shape230_on, shape231_on, shape232_on, shape233_on, shape234_on, shape235_on, shape236_on;
    logic [10:0] shape21_x = 240;
    logic [10:0] shape21_y = 200;
    logic [10:0] shape22_x = 250;
    logic [10:0] shape22_y = 200;
    logic [10:0] shape23_x = 260;
    logic [10:0] shape23_y = 200;
    logic [10:0] shape24_x = 270;
    logic [10:0] shape24_y = 200;
    logic [10:0] shape25_x = 280;
    logic [10:0] shape25_y = 200;
    logic [10:0] shape26_x = 290;
    logic [10:0] shape26_y = 200;
    logic [10:0] shape27_x = 300;
    logic [10:0] shape27_y = 200;
    logic [10:0] shape28_x = 310;
    logic [10:0] shape28_y = 200;
    logic [10:0] shape29_x = 320;
    logic [10:0] shape29_y = 200;
    logic [10:0] shape210_x = 330;
    logic [10:0] shape210_y = 200;
    logic [10:0] shape211_x = 340;
    logic [10:0] shape211_y = 200;
    logic [10:0] shape212_x = 350;
    logic [10:0] shape212_y = 200;
    logic [10:0] shape213_x = 360;
    logic [10:0] shape213_y = 200;
    logic [10:0] shape214_x = 370;
    logic [10:0] shape214_y = 200;
    logic [10:0] shape215_x = 380;
    logic [10:0] shape215_y = 200;
    logic [10:0] shape216_x = 390;
    logic [10:0] shape216_y = 200;
    //second line
    logic [10:0] shape217_x = 220;
    logic [10:0] shape217_y = 300;
    logic [10:0] shape218_x = 230;
    logic [10:0] shape218_y = 300;
    logic [10:0] shape219_x = 240;
    logic [10:0] shape219_y = 300;
    logic [10:0] shape220_x = 250;
    logic [10:0] shape220_y = 300;
    logic [10:0] shape221_x = 260;
    logic [10:0] shape221_y = 300;
    logic [10:0] shape222_x = 270;
    logic [10:0] shape222_y = 300;
    logic [10:0] shape223_x = 280;
    logic [10:0] shape223_y = 300;
    logic [10:0] shape224_x = 290;
    logic [10:0] shape224_y = 300;
    logic [10:0] shape225_x = 300;
    logic [10:0] shape225_y = 300;
    logic [10:0] shape226_x = 310;
    logic [10:0] shape226_y = 300;
    logic [10:0] shape227_x = 320;
    logic [10:0] shape227_y = 300;
    logic [10:0] shape228_x = 330;
    logic [10:0] shape228_y = 300;
    logic [10:0] shape229_x = 340;
    logic [10:0] shape229_y = 300;
    logic [10:0] shape230_x = 350;
    logic [10:0] shape230_y = 300;
    logic [10:0] shape231_x = 360;
    logic [10:0] shape231_y = 300;
    logic [10:0] shape232_x = 370;
    logic [10:0] shape232_y = 300;
    logic [10:0] shape233_x = 380;
    logic [10:0] shape233_y = 300;
    logic [10:0] shape234_x = 390;
    logic [10:0] shape234_y = 300;
    logic [10:0] shape235_x = 400;
    logic [10:0] shape235_y = 300;
    logic [10:0] shape236_x = 410;
    logic [10:0] shape236_y = 300;
    //size
    logic [10:0] shape_size_x = 8;
    logic [10:0] shape_size_y = 16;
    
    //game over
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
    
    // win
    logic shape11_on, shape12_on, shape13_on, shape14_on;
    logic [10:0] shape11_x = 300;
    logic [10:0] shape11_y = 240;
    logic [10:0] shape12_x = 310;
    logic [10:0] shape12_y = 240;
    logic [10:0] shape13_x = 320;
    logic [10:0] shape13_y = 240;
    logic [10:0] shape14_x = 330;
    logic [10:0] shape14_y = 240;
    logic [10:0] shape11_size_x = 8;
    logic [10:0] shape11_size_y = 16;
    logic [10:0] shape12_size_x = 8;
    logic [10:0] shape12_size_y = 16;
    logic [10:0] shape13_size_x = 8;
    logic [10:0] shape13_size_y = 16;
    logic [10:0] shape14_size_x = 8;
    logic [10:0] shape14_size_y = 16;

    
    //score
    logic [10:0] shape31_x = 290;
    logic [10:0] shape31_y = 50;
    logic [10:0] shape32_x = 300;
    logic [10:0] shape32_y = 50;
    logic [10:0] shape33_x = 310;
    logic [10:0] shape33_y = 50;
    logic [10:0] shape34_x = 320;
    logic [10:0] shape34_y = 50;
    logic [10:0] shape35_x = 330;
    logic [10:0] shape35_y = 50;
    logic [10:0] shape36_x = 340;
    logic [10:0] shape36_y = 50;
    logic [10:0] shape37_x = 350;
    logic [10:0] shape37_y = 50;
    font_rom fr(.addr(sprite_addr), .data(sprite_data));

    always_comb
	    begin
	        if(blank)
		        begin
			        if(start)
				        begin
							shape31_on = 1'b0;
							shape32_on = 1'b0;
							shape33_on = 1'b0;
							shape34_on = 1'b0;
							shape35_on = 1'b0;
							shape36_on = 1'b0;
							shape37_on = 1'b0;
							shape1_on = 1'b0;
                            shape2_on = 1'b0;
                            shape3_on = 1'b0;
                            shape4_on = 1'b0;
                            shape5_on = 1'b0;
                            shape6_on = 1'b0;
                            shape7_on = 1'b0;
                            shape8_on = 1'b0;
                            shape9_on = 1'b0;
                            shape11_on = 1'b0;
							shape12_on = 1'b0;
							shape13_on = 1'b0;
							shape14_on = 1'b0;
			                if (DrawX >= shape21_x && DrawX <shape21_x + shape_size_x && DrawY >= shape21_y && DrawY < shape21_y + shape_size_y)
				                begin
                                    shape21_on = 1'b1;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY-shape21_y + 16 * 'h53);
                                end
				            else if (DrawX >= shape22_x && DrawX < shape22_x + shape_size_x && DrawY >= shape22_y && DrawY < shape22_y + shape_size_y)
				                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b1;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape22_y + 16 * 'h55);
                                end 
				            else if (DrawX >= shape23_x && DrawX < shape23_x + shape_size_x && DrawY >= shape23_y && DrawY < shape23_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b1;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape23_y + 16 * 'h50);
                                end
				            else if(DrawX >= shape24_x && DrawX <shape24_x+shape_size_x && DrawY >=shape24_y && DrawY < shape24_y+shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b1;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape24_y + 16 * 'h45);
                                end
				            else if (DrawX >= shape25_x && DrawX < shape25_x + shape_size_x && DrawY >= shape25_y && DrawY < shape25_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b1;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape25_y + 16 * 'h52);
                                end
				            else if (DrawX >= shape26_x && DrawX < shape26_x + shape_size_x && DrawY >= shape26_y && DrawY < shape26_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b1;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape26_y + 16 * 'h2e);
                                end
				            else if (DrawX >= shape27_x && DrawX < shape27_x + shape_size_x && DrawY >= shape27_y && DrawY < shape27_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b1;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape27_y + 16 *'h4d);
                                end
				            else if (DrawX >= shape28_x && DrawX < shape28_x + shape_size_x && DrawY >= shape28_y && DrawY < shape28_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b1;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape28_y + 16 * 'h41);
                                end
				            else if (DrawX >= shape29_x && DrawX < shape29_x + shape_size_x && DrawY >= shape29_y && DrawY < shape29_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b1;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape29_y + 16 * 'h52);
                                end
				            else if (DrawX >= shape210_x && DrawX < shape210_x + shape_size_x && DrawY >= shape210_y && DrawY < shape210_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b1;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape210_y + 16 * 'h49);
                                end
				            else if (DrawX >= shape211_x && DrawX < shape211_x + shape_size_x && DrawY >= shape211_y && DrawY < shape211_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b1;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape211_y + 16 * 'h4f);
                                end
				            else if (DrawX >= shape212_x && DrawX < shape212_x + shape_size_x && DrawY >= shape212_y && DrawY < shape212_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b1;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape212_y + 16 * 'h2e);
                                end
				            else if (DrawX >= shape213_x && DrawX < shape213_x + shape_size_x && DrawY >= shape213_y && DrawY < shape213_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b1;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape213_y + 16 * 'h42);
                                end
				            else if (DrawX >= shape214_x && DrawX < shape214_x + shape_size_x && DrawY >= shape214_y && DrawY < shape214_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b1;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape214_y + 16 * 'h52);
                                end
				            else if (DrawX >= shape215_x && DrawX < shape215_x + shape_size_x && DrawY >= shape215_y && DrawY < shape215_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b1;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape215_y + 16 * 'h4f);
                                end
				            else if (DrawX >= shape216_x && DrawX < shape216_x + shape_size_x && DrawY >= shape216_y && DrawY < shape216_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b1;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape216_y + 16 * 'h53);
                                end
                            else if (DrawX >= shape217_x && DrawX < shape217_x + shape_size_x && DrawY >= shape217_y && DrawY < shape217_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b1;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape217_y + 16 * 'h50);
                                end
                            else if (DrawX >= shape218_x && DrawX < shape218_x + shape_size_x && DrawY >= shape218_y && DrawY < shape218_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b1;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape218_y + 16 * 'h52);
                                end
                            else if (DrawX >= shape219_x && DrawX < shape219_x + shape_size_x && DrawY >= shape219_y && DrawY < shape219_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b1;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape219_y + 16 * 'h45);
                                end
                            else if (DrawX >= shape220_x && DrawX <shape220_x + shape_size_x && DrawY >= shape220_y && DrawY < shape220_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b1;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape220_y + 16 * 'h53);
                                end
                            else if (DrawX >= shape221_x && DrawX < shape221_x + shape_size_x && DrawY >= shape221_y && DrawY < shape221_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b1;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape221_y + 16 * 'h53);
                                end
                            else if (DrawX >= shape222_x && DrawX < shape222_x + shape_size_x && DrawY >= shape222_y && DrawY < shape222_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b1;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape222_y + 16 * 'h2e);
                                end
                            else if (DrawX >= shape223_x && DrawX < shape223_x + shape_size_x && DrawY >= shape223_y && DrawY < shape223_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b1;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape223_y + 16 * 'h45);
                                end
                            else if (DrawX >= shape224_x && DrawX < shape224_x + shape_size_x && DrawY >= shape224_y && DrawY < shape224_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b1;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape224_y + 16 * 'h4e);
                                end
                            else if (DrawX >= shape225_x && DrawX < shape225_x + shape_size_x && DrawY >= shape225_y && DrawY < shape225_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b1;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape225_y + 16 * 'h54);
                                end
                            else if (DrawX >= shape226_x && DrawX < shape226_x + shape_size_x && DrawY >= shape226_y && DrawY < shape226_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b1;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape226_y + 16 * 'h45);
                                end
                            else if (DrawX >= shape227_x && DrawX < shape227_x + shape_size_x && DrawY >= shape227_y && DrawY < shape227_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b1;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape227_y + 16 * 'h52);
                                end
                            else if (DrawX >= shape228_x && DrawX < shape228_x + shape_size_x && DrawY >= shape228_y && DrawY < shape228_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b1;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape228_y + 16 * 'h2e);
                                end
                            else if (DrawX >= shape229_x && DrawX < shape229_x + shape_size_x && DrawY >= shape229_y && DrawY < shape229_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b1;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape229_y + 16 * 'h54);
                                end
                            else if (DrawX >= shape230_x && DrawX < shape230_x + shape_size_x && DrawY >= shape230_y && DrawY < shape230_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b1;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape230_y + 16 * 'h4f);
                                end
                            else if (DrawX >= shape231_x && DrawX < shape231_x + shape_size_x && DrawY >= shape231_y && DrawY < shape231_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b1;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape231_y + 16 * 'h2e);
                                end
                            else if (DrawX >= shape232_x && DrawX < shape232_x + shape_size_x && DrawY >= shape232_y && DrawY < shape232_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b1;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape232_y + 16 * 'h53);
                                end
                            else if (DrawX >= shape233_x && DrawX <shape233_x + shape_size_x && DrawY >= shape233_y && DrawY < shape233_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b1;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape233_y + 16 * 'h54);
                                end
                            else if (DrawX >= shape234_x && DrawX < shape234_x + shape_size_x && DrawY >= shape234_y && DrawY < shape234_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b1;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape234_y + 16 * 'h41);
                                end
                            else if (DrawX >= shape235_x && DrawX < shape235_x + shape_size_x && DrawY >= shape235_y && DrawY < shape235_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b1;
                                    shape236_on = 1'b0;
                                    sprite_addr = (DrawY - shape235_y + 16 * 'h52);
                                end
                            else if (DrawX >= shape236_x && DrawX < shape236_x + shape_size_x && DrawY >= shape236_y && DrawY < shape236_y + shape_size_y)
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b1;
                                    sprite_addr = (DrawY - shape236_y + 16 * 'h54);
                                end
                            else
                                begin
                                    shape21_on = 1'b0;
                                    shape22_on = 1'b0;
                                    shape23_on = 1'b0;
                                    shape24_on = 1'b0;
                                    shape25_on = 1'b0;
                                    shape26_on = 1'b0;
                                    shape27_on = 1'b0;
                                    shape28_on = 1'b0;
                                    shape29_on = 1'b0;
                                    shape210_on = 1'b0;
                                    shape211_on = 1'b0;
                                    shape212_on = 1'b0;
                                    shape213_on = 1'b0;
                                    shape214_on = 1'b0;
                                    shape215_on = 1'b0;
                                    shape216_on = 1'b0;
                                    shape217_on = 1'b0;
                                    shape218_on = 1'b0;
                                    shape219_on = 1'b0;
                                    shape220_on = 1'b0;
                                    shape221_on = 1'b0;
                                    shape222_on = 1'b0;
                                    shape223_on = 1'b0;
                                    shape224_on = 1'b0;
                                    shape225_on = 1'b0;
                                    shape226_on = 1'b0;
                                    shape227_on = 1'b0;
                                    shape228_on = 1'b0;
                                    shape229_on = 1'b0;
                                    shape230_on = 1'b0;
                                    shape231_on = 1'b0;
                                    shape232_on = 1'b0;
                                    shape233_on = 1'b0;
                                    shape234_on = 1'b0;
                                    shape235_on = 1'b0;
                                    shape236_on = 1'b0;
                                    sprite_addr = 1'b0;
                                end
                            if (shape21_on == 1'b1 && sprite_data[7 - DrawX + shape21_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if (shape22_on == 1'b1 && sprite_data[7 - DrawX + shape22_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if (shape23_on == 1'b1 && sprite_data[7 - DrawX + shape23_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if (shape24_on == 1'b1 && sprite_data[7 - DrawX + shape24_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if (shape25_on == 1'b1 && sprite_data[7 - DrawX + shape25_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape26_on == 1'b1 && sprite_data[7 - DrawX + shape26_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape27_on == 1'b1 && sprite_data[7 - DrawX + shape27_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape28_on == 1'b1 && sprite_data[7 - DrawX + shape28_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape29_on == 1'b1 && sprite_data[7 - DrawX + shape29_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape210_on == 1'b1 && sprite_data[7 - DrawX + shape210_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape211_on == 1'b1 && sprite_data[7 - DrawX + shape211_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape212_on == 1'b1 && sprite_data[7 - DrawX + shape212_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape213_on == 1'b1 && sprite_data[7 - DrawX + shape213_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape214_on == 1'b1 && sprite_data[7 - DrawX + shape214_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape215_on == 1'b1 && sprite_data[7 - DrawX + shape215_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape216_on == 1'b1 && sprite_data[7 - DrawX + shape216_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape217_on == 1'b1 && sprite_data[7 - DrawX + shape217_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape218_on == 1'b1 && sprite_data[7 - DrawX + shape218_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape219_on == 1'b1 && sprite_data[7 - DrawX + shape219_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape220_on == 1'b1 && sprite_data[7 - DrawX + shape220_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape221_on == 1'b1 && sprite_data[7 - DrawX + shape221_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape222_on == 1'b1 && sprite_data[7 - DrawX + shape222_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape223_on == 1'b1 && sprite_data[7 - DrawX + shape223_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape224_on == 1'b1 && sprite_data[7 - DrawX + shape224_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape225_on == 1'b1 && sprite_data[7 - DrawX + shape225_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape226_on == 1'b1 && sprite_data[7 - DrawX + shape226_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape227_on == 1'b1 && sprite_data[7 - DrawX + shape227_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape228_on == 1'b1 && sprite_data[7 - DrawX + shape228_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape229_on == 1'b1 && sprite_data[7 - DrawX + shape229_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape230_on == 1'b1 && sprite_data[7 - DrawX + shape230_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape231_on == 1'b1 && sprite_data[7 - DrawX + shape231_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape232_on == 1'b1 && sprite_data[7 - DrawX + shape232_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape233_on == 1'b1 && sprite_data[7 - DrawX + shape233_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape234_on == 1'b1 && sprite_data[7 - DrawX + shape234_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape235_on == 1'b1 && sprite_data[7 - DrawX + shape235_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape236_on == 1'b1 && sprite_data[7 - DrawX + shape236_x] == 1'b1)
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
                    else if( mario_arrived || luigi_arrived)
                        begin
                            shape21_on = 1'b0;
                            shape22_on = 1'b0;
                            shape23_on = 1'b0;
                            shape24_on = 1'b0;
                            shape25_on = 1'b0;
                            shape26_on = 1'b0;
                            shape27_on = 1'b0;
                            shape28_on = 1'b0;
                            shape29_on = 1'b0;
                            shape210_on = 1'b0;
                            shape211_on = 1'b0;
                            shape212_on = 1'b0;
                            shape213_on = 1'b0;
                            shape214_on = 1'b0;
                            shape215_on = 1'b0;
                            shape216_on = 1'b0;
                            shape217_on = 1'b0;
                            shape218_on = 1'b0;
                            shape219_on = 1'b0;
                            shape220_on = 1'b0;
                            shape221_on = 1'b0;
                            shape222_on = 1'b0;
                            shape223_on = 1'b0;
                            shape224_on = 1'b0;
                            shape225_on = 1'b0;
                            shape226_on = 1'b0;
                            shape227_on = 1'b0;
                            shape228_on = 1'b0;
                            shape229_on = 1'b0;
                            shape230_on = 1'b0;
                            shape231_on = 1'b0;
                            shape232_on = 1'b0;
                            shape233_on = 1'b0;
                            shape234_on = 1'b0;
                            shape235_on = 1'b0;
                            shape236_on = 1'b0;
                            shape31_on = 1'b0;
                            shape32_on = 1'b0;
                            shape33_on = 1'b0;
                            shape34_on = 1'b0;
                            shape35_on = 1'b0;
                            shape36_on = 1'b0;
                            shape37_on = 1'b0;
                            shape1_on = 1'b0;
                            shape2_on = 1'b0;
                            shape3_on = 1'b0;
                            shape4_on = 1'b0;
                            shape5_on = 1'b0;
                            shape6_on = 1'b0;
                            shape7_on = 1'b0;
                            shape8_on = 1'b0;
                            shape9_on = 1'b0;
                            if (DrawX >= shape11_x && DrawX < shape11_x + shape11_size_x && DrawY >= shape11_y && DrawY < shape11_y + shape11_size_y)
                                begin
                                    shape11_on = 1'b1;
                                    shape12_on = 1'b0;
                                    shape13_on = 1'b0;
                                    shape14_on = 1'b0;
                                    sprite_addr = (DrawY - shape11_y + 16 * 'h57);
                                end
                            else if (DrawX >= shape12_x && DrawX < shape12_x + shape12_size_x && DrawY >= shape12_y && DrawY < shape12_y + shape12_size_y)
                                begin
                                    shape11_on = 1'b0;
                                    shape12_on = 1'b1;
                                    shape13_on = 1'b0;
                                    shape14_on = 1'b0;
                                    sprite_addr = (DrawY - shape12_y + 16 * 'h49);
                                end
                            else if (DrawX >= shape13_x && DrawX < shape13_x + shape13_size_x && DrawY >= shape13_y && DrawY < shape13_y + shape13_size_y)
                                begin
                                    shape11_on = 1'b0;
                                    shape12_on = 1'b0;
                                    shape13_on = 1'b1;
                                    shape14_on = 1'b0;
                                    sprite_addr = (DrawY - shape13_y + 16 * 'h4e);
                                end
                            else if (DrawX >= shape14_x && DrawX < shape14_x + shape14_size_x && DrawY >= shape14_y && DrawY < shape14_y + shape14_size_y)
                                begin
                                    shape11_on = 1'b0;
                                    shape12_on = 1'b0;
                                    shape13_on = 1'b0;
                                    shape14_on = 1'b1;
                                    sprite_addr = (DrawY - shape14_y + 16 * 'h3);
                                end
                            else
                                begin
                                    shape11_on = 1'b0;
                                    shape12_on = 1'b0;
                                    shape13_on = 1'b0;
                                    shape14_on = 1'b0;
                                    sprite_addr = 1'b0;
                                end
                                
                            if (shape11_on == 1'b1 && sprite_data[7 - DrawX + shape11_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            
                            else if (shape12_on ==1'b1 && sprite_data[7 - DrawX + shape12_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            
                            else if (shape13_on == 1'b1 && sprite_data[7 - DrawX + shape13_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            
                            else if (shape14_on == 1'b1 && sprite_data[7 - DrawX + shape14_x] == 1'b1)
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
                    else if (~mariod_dead || ~luigi_dead)
                        begin
                            shape21_on = 1'b0;
                            shape22_on = 1'b0;
                            shape23_on = 1'b0;
                            shape24_on = 1'b0;
                            shape25_on = 1'b0;
                            shape26_on = 1'b0;
                            shape27_on = 1'b0;
                            shape28_on = 1'b0;
                            shape29_on = 1'b0;
                            shape210_on = 1'b0;
                            shape211_on = 1'b0;
                            shape212_on = 1'b0;
                            shape213_on = 1'b0;
                            shape214_on = 1'b0;
                            shape215_on = 1'b0;
                            shape216_on = 1'b0;
                            shape217_on = 1'b0;
                            shape218_on = 1'b0;
                            shape219_on = 1'b0;
                            shape220_on = 1'b0;
                            shape221_on = 1'b0;
                            shape222_on = 1'b0;
                            shape223_on = 1'b0;
                            shape224_on = 1'b0;
                            shape225_on = 1'b0;
                            shape226_on = 1'b0;
                            shape227_on = 1'b0;
                            shape228_on = 1'b0;
                            shape229_on = 1'b0;
                            shape230_on = 1'b0;
                            shape231_on = 1'b0;
                            shape232_on = 1'b0;
                            shape233_on = 1'b0;
                            shape234_on = 1'b0;
                            shape235_on = 1'b0;
                            shape236_on = 1'b0;
                            shape1_on = 1'b0;
                            shape2_on = 1'b0;
                            shape3_on = 1'b0;
                            shape4_on = 1'b0;
                            shape5_on = 1'b0;
                            shape6_on = 1'b0;
                            shape7_on = 1'b0;
                            shape8_on = 1'b0;
                            shape9_on = 1'b0;
                            shape11_on = 1'b0;
                            shape12_on = 1'b0;
                            shape13_on = 1'b0;
                            shape14_on = 1'b0;
                            sprite_addr = 1'b0;
                            if (DrawX >= shape31_x && DrawX < shape31_x + shape_size_x && DrawY >= shape31_y && DrawY < shape31_y + shape_size_y)
                                begin
                                    shape31_on = 1'b1;
                                    shape32_on = 1'b0;
                                    shape33_on = 1'b0;
                                    shape34_on = 1'b0;
                                    shape35_on = 1'b0;
                                    shape36_on = 1'b0;
                                    shape37_on = 1'b0;
                                    sprite_addr = (DrawY - shape31_y + 16 * 'h53);
                                end
                            else if (DrawX >= shape32_x && DrawX < shape32_x + shape_size_x && DrawY >= shape32_y && DrawY < shape32_y + shape_size_y)
                                begin
                                    shape31_on = 1'b0;
                                    shape32_on = 1'b1;
                                    shape33_on = 1'b0;
                                    shape34_on = 1'b0;
                                    shape35_on = 1'b0;
                                    shape36_on = 1'b0;
                                    shape37_on = 1'b0;
                                    sprite_addr = (DrawY - shape32_y + 16 *'h43);
                                end
                            else if (DrawX >= shape33_x && DrawX < shape33_x + shape_size_x && DrawY >= shape33_y && DrawY < shape33_y + shape_size_y)
                                begin
                                    shape31_on = 1'b0;
                                    shape32_on = 1'b0;
                                    shape33_on = 1'b1;
                                    shape34_on = 1'b0;
                                    shape35_on = 1'b0;
                                    shape36_on = 1'b0;
                                    shape37_on = 1'b0;
                                    sprite_addr = (DrawY - shape33_y + 16 * 'h4f);
                                end
                            else if (DrawX >= shape34_x && DrawX < shape34_x + shape_size_x && DrawY >= shape34_y && DrawY < shape34_y + shape_size_y)
                                begin
                                    shape31_on = 1'b0;
                                    shape32_on = 1'b0;
                                    shape33_on = 1'b0;
                                    shape34_on = 1'b1;
                                    shape35_on = 1'b0;
                                    shape36_on = 1'b0;
                                    shape37_on = 1'b0;
                                    sprite_addr = (DrawY - shape34_y + 16 * 'h52);
                                end
                            else if (DrawX >= shape35_x && DrawX < shape35_x + shape_size_x && DrawY >= shape35_y && DrawY < shape35_y + shape_size_y)
                                begin
                                    shape31_on = 1'b0;
                                    shape32_on = 1'b0;
                                    shape33_on = 1'b0;
                                    shape34_on = 1'b0;
                                    shape35_on = 1'b1;
                                    shape36_on = 1'b0;
                                    shape37_on = 1'b0;
                                    sprite_addr = (DrawY - shape35_y + 16 * 'h45);
                                end
                            else if (DrawX >= shape36_x && DrawX < shape36_x + shape_size_x && DrawY >= shape36_y && DrawY < shape36_y + shape_size_y)
                                begin
                                    shape31_on = 1'b0;
                                    shape32_on = 1'b0;
                                    shape33_on = 1'b0;
                                    shape34_on = 1'b0;
                                    shape35_on = 1'b0;
                                    shape36_on = 1'b1;
                                    shape37_on = 1'b0;
                                    sprite_addr = (DrawY - shape36_y + 16 * 'h7c);
                                end
                            else if (DrawX >= shape37_x && DrawX < shape37_x + shape_size_x && DrawY >= shape37_y && DrawY < shape37_y + shape_size_y)
                                begin
                                    shape31_on = 1'b0;
                                    shape32_on = 1'b0;
                                    shape33_on = 1'b0;
                                    shape34_on = 1'b0;
                                    shape35_on = 1'b0;
                                    shape36_on = 1'b0;
                                    shape37_on = 1'b1;
                                    sprite_addr = (DrawY - shape37_y + 16 * ('h30+score));
                                end
                            else
                                begin
                                    shape31_on = 1'b0;
                                    shape32_on = 1'b0;
                                    shape33_on = 1'b0;
                                    shape34_on = 1'b0;
                                    shape35_on = 1'b0;
                                    shape36_on = 1'b0;
                                    shape37_on = 1'b0;
                                    sprite_addr = 1'b0;
                                end

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
                            else if (coin3)
                                begin
                                    VGA_R = coin3_pic_out[23:16];
                                    VGA_G = coin3_pic_out[15:8];
                                    VGA_B = coin3_pic_out[7:0];
                                end
                            else if (coin4)
                                begin
                                    VGA_R = coin4_pic_out[23:16];
                                    VGA_G = coin4_pic_out[15:8];
                                    VGA_B = coin4_pic_out[7:0];
                                end
                            else if (coin5)
                                begin
                                    VGA_R = coin5_pic_out[23:16];
                                    VGA_G = coin5_pic_out[15:8];
                                    VGA_B = coin5_pic_out[7:0];
                                end
                            else if (coin6)
                                begin
                                    VGA_R = coin6_pic_out[23:16];
                                    VGA_G = coin6_pic_out[15:8];
                                    VGA_B = coin6_pic_out[7:0];
                                end
                            else if (coin7)
                                begin
                                    VGA_R = coin7_pic_out[23:16];
                                    VGA_G = coin7_pic_out[15:8];
                                    VGA_B = coin7_pic_out[7:0];
                                end
                            else if (DrawY >= 10'd416)
                                begin
                                    VGA_R = ground[23:16];
                                    VGA_G = ground[15:8];
                                    VGA_B = ground[7:0];
                                end
                            else if (DrawY>=10'd95 && DrawY < 10'd145)
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
                            else if (DrawY > 10'd100 && DrawY <= 10'd150)
                                begin
                                    VGA_R = back1[23:16]; 
                                    VGA_G = back1[15:8];
                                    VGA_B = back1[7:0];
                                end
                            else if(shape31_on == 1'b1 && sprite_data[7 - DrawX + shape31_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape32_on == 1'b1 && sprite_data[7 - DrawX + shape32_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape33_on == 1'b1 && sprite_data[7 - DrawX + shape33_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape34_on == 1'b1 && sprite_data[7 - DrawX + shape34_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape35_on == 1'b1 && sprite_data[7 - DrawX + shape35_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape36_on == 1'b1 && sprite_data[7 - DrawX + shape36_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if(shape37_on == 1'b1 && sprite_data[7 - DrawX + shape37_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else
                                begin
                                    VGA_R = 8'h6b; 
                                    VGA_G =8'h8c;
                                    VGA_B = 8'hff;
                                end
                        end
		            else
			            begin	
                            shape31_on = 1'b0;
                            shape32_on = 1'b0;
                            shape33_on = 1'b0;
                            shape34_on = 1'b0;
                            shape35_on = 1'b0;
                            shape36_on = 1'b0;
                            shape37_on = 1'b0;
                            shape21_on = 1'b0;
                            shape22_on = 1'b0;
                            shape23_on = 1'b0;
                            shape24_on = 1'b0;
                            shape25_on = 1'b0;
                            shape26_on = 1'b0;
                            shape27_on = 1'b0;
                            shape28_on = 1'b0;
                            shape29_on = 1'b0;
                            shape210_on = 1'b0;
                            shape211_on = 1'b0;
                            shape212_on = 1'b0;
                            shape213_on = 1'b0;
                            shape214_on = 1'b0;
                            shape215_on = 1'b0;
                            shape216_on = 1'b0;
                            shape217_on = 1'b0;
                            shape218_on = 1'b0;
                            shape219_on = 1'b0;
                            shape220_on = 1'b0;
                            shape221_on = 1'b0;
                            shape222_on = 1'b0;
                            shape223_on = 1'b0;
                            shape224_on = 1'b0;
                            shape225_on = 1'b0;
                            shape226_on = 1'b0;
                            shape227_on = 1'b0;
                            shape228_on = 1'b0;
                            shape229_on = 1'b0;
                            shape230_on = 1'b0;
                            shape231_on = 1'b0;
                            shape232_on = 1'b0;
                            shape233_on = 1'b0;
                            shape234_on = 1'b0;
                            shape235_on = 1'b0;
                            shape236_on = 1'b0;
							shape11_on = 1'b0;
							shape12_on = 1'b0;
							shape13_on = 1'b0;
							shape14_on = 1'b0;
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
                                    sprite_addr = (DrawY - shape1_y + 16 * 'h47);
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
                                    sprite_addr = (DrawY - shape2_y + 16 * 'h41);
                                end
                            else if (DrawX >= shape3_x && DrawX < shape3_x + shape3_size_x && DrawY >= shape3_y && DrawY < shape3_y + shape3_size_y)
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
                                    sprite_addr = (DrawY - shape4_y + 16 * 'h45);
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
                                    sprite_addr = (DrawY - shape5_y + 16 * 'h2d);
                                end
                            else if (DrawX >= shape6_x && DrawX < shape6_x + shape6_size_x && DrawY >= shape6_y && DrawY < shape6_y + shape6_size_y)
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
                                    sprite_addr = (DrawY - shape6_y + 16 * 'h4f);
                                end
                            else if (DrawX >= shape7_x && DrawX < shape7_x + shape7_size_x && DrawY >=shape7_y && DrawY < shape7_y + shape7_size_y)
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
                                    sprite_addr = (DrawY - shape7_y + 16 * 'h56);
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
                                    sprite_addr = (DrawY - shape8_y + 16 * 'h45);
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
                                    sprite_addr = (DrawY - shape9_y + 16 * 'h52);
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
                            
                            if (shape1_on == 1'b1 && sprite_data[7 - DrawX + shape1_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if (shape2_on == 1'b1 && sprite_data[7 - DrawX + shape2_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if (shape3_on == 1'b1 && sprite_data[7 - DrawX + shape3_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if (shape4_on == 1'b1 && sprite_data[7 - DrawX + shape4_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if (shape5_on == 1'b1 && sprite_data[7 - DrawX + shape5_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if (shape6_on == 1'b1 && sprite_data[7 - DrawX + shape6_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if (shape7_on == 1'b1 && sprite_data[7 - DrawX + shape7_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if (shape8_on == 1'b1 && sprite_data[7 - DrawX + shape8_x] == 1'b1)
                                begin
                                    VGA_R = 8'hff; 
                                    VGA_G = 8'hff;
                                    VGA_B = 8'hff;
                                end
                            else if (shape9_on == 1'b1 && sprite_data[7 - DrawX + shape9_x] == 1'b1)
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
					shape31_on = 1'b0;
                    shape32_on = 1'b0;
                    shape33_on = 1'b0;
                    shape34_on = 1'b0;
                    shape35_on = 1'b0;
                    shape36_on = 1'b0;
                    shape37_on = 1'b0;
					shape1_on = 1'b0;
					shape2_on = 1'b0;
					shape3_on = 1'b0;
					shape4_on = 1'b0;
					shape5_on = 1'b0;
					shape6_on = 1'b0;
					shape7_on = 1'b0;
					shape8_on = 1'b0;
					shape9_on = 1'b0;
					shape11_on = 1'b0;
					shape12_on = 1'b0;
					shape13_on = 1'b0;
					shape14_on = 1'b0;
							
					shape21_on = 1'b0;
					shape22_on = 1'b0;
					shape23_on = 1'b0;
					shape24_on = 1'b0;
					shape25_on = 1'b0;
					shape26_on = 1'b0;
					shape27_on = 1'b0;
					shape28_on = 1'b0;
					shape29_on = 1'b0;
					shape210_on = 1'b0;
					shape211_on = 1'b0;
					shape212_on = 1'b0;
					shape213_on = 1'b0;
					shape214_on = 1'b0;
					shape215_on = 1'b0;
					shape216_on = 1'b0;
					shape217_on = 1'b0;
					shape218_on = 1'b0;
					shape219_on = 1'b0;
					shape220_on = 1'b0;
					shape221_on = 1'b0;
					shape222_on = 1'b0;
					shape223_on = 1'b0;
					shape224_on = 1'b0;
					shape225_on = 1'b0;
					shape226_on = 1'b0;
					shape227_on = 1'b0;
					shape228_on = 1'b0;
					shape229_on = 1'b0;
					shape230_on = 1'b0;
					shape231_on = 1'b0;
					shape232_on = 1'b0;
					shape233_on = 1'b0;
					shape234_on = 1'b0;
					shape235_on = 1'b0;
					shape236_on = 1'b0;
							
					sprite_addr = 1'b0;
                    VGA_R = 8'h00; 
                    VGA_G = 8'h00;
                    VGA_B = 8'h00;
                end
  
		end
endmodule