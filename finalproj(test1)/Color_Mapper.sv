//This is the Colour Mapper module.

module  color_mapper (
        input mario, 
		  input mariod,
		  input luigi,
		  input coin,
		  input [1:0] player,
		  input gomba,
        input [9:0] DrawX, DrawY, 
        input [23:0] mario_pic_out,
		  input [23:0] mariod_pic_out,
		  input [23:0] luigi_pic_out,
		  input [23:0] gomba_pic_out,
		  input [23:0] coin_pic_out,
        input [23:0] ground,

        output logic [7:0] Red, Green, Blue
);
    logic [7:0] VGA_R, VGA_B, VGA_G;

    assign Red = VGA_R;
    assign Blue = VGA_B;
    assign Green = VGA_G;

    always_comb
    begin
			if(player == 2'b10)
			begin
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
				else if(coin)
					begin
						VGA_R = coin_pic_out[23:16];
						VGA_G = coin_pic_out[15:8];
						VGA_B = coin_pic_out[7:0];
					end
					
				else if (DrawY >= 10'd416)
					begin
						VGA_R = ground[23:16];
						VGA_G = ground[15:8];
						VGA_B = ground[7:0];
					end
				else
					begin
						VGA_R = 8'h00; 
						VGA_G = 8'h00;
						VGA_B = 8'h00;
					end
			end
			else 
				begin
				if (mario)
					begin
						VGA_R = mario_pic_out[23:16];
						VGA_G = mario_pic_out[15:8];
						VGA_B = mario_pic_out[7:0];
					end
				else  if (gomba)
					begin
						VGA_R = gomba_pic_out[23:16];
						VGA_G = gomba_pic_out[15:8];
						VGA_B = gomba_pic_out[7:0];
					end
				else if (DrawY >= 10'd416)
					begin
						VGA_R = ground[23:16];
						VGA_G = ground[15:8];
						VGA_B = ground[7:0];
					end
				else
					begin
						VGA_R = 8'h00; 
						VGA_G = 8'h00;
						VGA_B = 8'h00;
					end
				end
    end
endmodule