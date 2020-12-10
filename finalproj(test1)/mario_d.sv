module mario_d (
        input Reset, frame_clk, Clk,
        input [31:0] keycode,
        input [9:0] DrawX, DrawY,
        input mariod_alive,
        input [9:0] luigi_x, luigi_y,
        input luigi_at_edge,
        input [23:0] mariod_sl, mariod_sr, mariod_rl1, mariod_rl2, mariod_rl3, mariod_rr1, mariod_rr2, mariod_rr3, mariod_jr, mariod_jl, mariod_die,

        output logic [9:0] mariod_x, mariod_y, process, mariod_y_motion,
        output logic mariod, mariod_in_air,
        output logic mario_arrived,
        output logic [23:0] mariod_pic_out
);
    logic w, s, a, d;
    logic sl, sr, rr1, rr2, rr3, rl1, rl2, rl3, jr, jl, il, ir, gr, gl, di;

    assign a = ((keycode[15:8] == 8'h04) | (keycode[7:0] == 8'h04)|(keycode[23:16] == 8'h04) | (keycode[31:24] == 8'h04));
    assign d = ((keycode[15:8] == 8'h07) | (keycode[7:0] == 8'h07)|(keycode[23:16] == 8'h07) | (keycode[31:24] == 8'h07));
    assign w = ((keycode[15:8] == 8'h1A) | (keycode[7:0] == 8'h1A)|(keycode[23:16] == 8'h1A) | (keycode[31:24] == 8'h1A));
    assign s = ((keycode[15:8] == 8'h16) | (keycode[7:0] == 8'h16)|(keycode[23:16] == 8'h16) | (keycode[31:24] == 8'h16));

    // mariod_image m_i(.*);
    mariod_movem m_m(.*);

    always_ff @ (posedge Clk)
        begin
            if (sl == 1'b1)
                begin
                    mariod_pic_out = mariod_sl;
                end
            else if (sr == 1'b1)
                begin
                    mariod_pic_out = mariod_sr;
                end
            else if (rr1 == 1'b1)
                begin
                    mariod_pic_out = mariod_rr1;
                end
            else if (rr2 == 1'b1)
                begin
                    mariod_pic_out = mariod_rr2;
                end
            else if (rr3 == 1'b1)
                begin
                    mariod_pic_out = mariod_rr3;
                end
            else if (rl1 == 1'b1)
                begin
                    mariod_pic_out = mariod_rl1;
                end
            else if (rl2 == 1'b1)
                begin
                    mariod_pic_out = mariod_rl2;
                end
            else if (rl3 == 1'b1)
                begin
                    mariod_pic_out = mariod_rl3;
                end
            else if (jr == 1'b1)
                begin
                    mariod_pic_out = mariod_jr;
                end
            else if (jl == 1'b1)
                begin
                    mariod_pic_out = mariod_jl;
                end
            else if (ir == 1'b1)
                begin
                    mariod_pic_out = mariod_jr;
                end
            else if (il == 1'b1)
                begin
                    mariod_pic_out = mariod_jl;
                end
            else if (gr == 1'b1)
                begin
                    mariod_pic_out = mariod_jr;
                end
            else if (gl == 1'b1)
                begin
                    mariod_pic_out = mariod_jl;
                end
            else if (di == 1'b1)
                begin
                    mariod_pic_out = mariod_die;
                end
            else
                begin
                    mariod_pic_out = mariod_sr;
                end
        end

    always_comb
    begin
        if (mariod_x < process + DrawX && DrawX + process < mariod_x + 10'd26 && DrawY > mariod_y && DrawY < mariod_y + 10'd32)
            begin
                mariod = 1'b1;
            end
        else
			begin
            mariod = 1'b0;
				end
      if (mariod_x >10'd830)
            begin
                mario_arrived = 1'b1;
            end
        else
			begin
            mario_arrived = 1'b0;
				end
    end

endmodule 



module mariod_movem (
        input Clk, Reset, frame_clk,
        input w, s, a, d,
        input mariod_alive, luigi_at_edge,
        input [9:0] luigi_x, luigi_y,
        output logic [9:0] mariod_x, mariod_y, process, mariod_y_motion,
        output logic mariod_in_air,
        output logic sl, sr, rr1, rr2, rr3, rl1, rl2, rl3, jr, jl, il, ir, gr, gl, di
);

    parameter [9:0] mariod_x_ori = 20;
    parameter [9:0] mariod_y_ori = 400;

    parameter [9:0] mariod_x_min = 0;
    parameter [9:0] mariod_x_max = 1023;
    parameter [9:0] mariod_y_min = 0;
    parameter [9:0] mariod_y_max = 479;
    parameter [9:0] mariod_x_step = 2;

    parameter [9:0] mariod_x_size = 26;

    logic [9:0] mariod_x_motion, altitude;
    logic [9:0] mariod_x_pos_input, mariod_x_motion_input, mariod_y_pos_input, mariod_y_motion_input;
    logic [9:0] process_input;

    logic sl_in, sr_in, rr1_in, rr2_in, rr3_in, rl1_in, rl2_in, rl3_in, jr_in, jl_in, ir_in, il_in, gr_in, gl_in, di_in;

    logic [23:0] mario_counter, mario_counter_in;
    logic [23:0] counter2, counter2_in;
    logic already_jump, already_jump_in;
	logic i;
    always_comb
    begin
        if (mariod_y + mariod_y_motion >= 10'd384)
            begin
                mariod_in_air = 1'b0;
                altitude = 10'd384;
            end
        // 在此处设置空气墙的位置和高度
        else if ((mariod_x + 10'd26 > 10'd100) && (mariod_x < 10'd100 + 10'd62) && (mariod_y + mariod_y_motion >= 10'd320) && (mariod_y + mariod_y_motion < 10'd384))
            begin
                mariod_in_air = 1'b0;
                altitude = 10'd320;
            end
        else if ((mariod_x + 10'd26 > 10'd640) && (mariod_x < 10'd640 + 10'd62) && (mariod_y + mariod_y_motion >= 10'd320) && (mariod_y + mariod_y_motion < 10'd384))
            begin
                mariod_in_air = 1'b0;
                altitude = 10'd320;
            end
        else if ((mariod_x + 10'd26 > luigi_x) && (mariod_x < luigi_x + 10'd26) && (mariod_y + mariod_y_motion >= luigi_y - 10'd32) && (mariod_y + mariod_y_motion < 10'd384))
            begin
                mariod_in_air = 1'b0;
                altitude = luigi_y - 10'd32;
            end

        // 下面的部分不用动
        else
            begin
                mariod_in_air = 1'b1;
                altitude = 10'd384;
            end
    end

    enum logic [3:0] {STAND_R,
                      STAND_L, 
                      RUN_1_R, 
                      RUN_2_R, 
                      RUN_3_R,
					  RUN_1_L, 
                      RUN_2_L, 
                      RUN_3_L, 
                      JUMP_R,
                      JUMP_L, 
                      IN_AIR_L,
                      IN_AIR_R, 
                      GLIDE_R,
                      GLIDE_L,
                      DIE} STATE, NEXT_STATE;
    
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) 
    begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end

    always_ff @ (posedge Clk)
    begin
        if (Reset)
            begin
                mariod_x <= 10'd20;
                mariod_y <= 10'd384;
                mariod_x_motion <= 10'd0;
                mariod_y_motion <= 10'd0;
                process <= 10'd0;
                STATE <= STAND_R;
                mario_counter <= 24'b0;
                counter2 <= 24'b0;
                already_jump <= 1'b0;
                sr  <= 1'b1;
                sl  <= 1'b0;
                rr1 <= 1'b0;
                rr2 <= 1'b0; 
                rr3 <= 1'b0; 
                rl1 <= 1'b0; 
                rl2 <= 1'b0; 
                rl3 <= 1'b0; 
                jr  <= 1'b0; 
                jl  <= 1'b0;
                ir  <= 1'b0;
                il  <= 1'b0; 
                gr  <= 1'b0;
                gl  <= 1'b0;
                di  <= 1'b0;
            end
        else
            begin
                mariod_x <= mariod_x_pos_input;
                mariod_y <= mariod_y_pos_input;
                mariod_x_motion <= mariod_x_motion_input;
                mariod_y_motion <= mariod_y_motion_input;
                process <= process_input;
                STATE <= NEXT_STATE;
                mario_counter <= mario_counter_in;
                counter2 <= counter2_in;
                already_jump <= already_jump_in;
                sr  <= sr_in;
                sl  <= sl_in;
                rr1 <= rr1_in;
                rr2 <= rr2_in; 
                rr3 <= rr3_in; 
                rl1 <= rl1_in; 
                rl2 <= rl2_in; 
                rl3 <= rl3_in; 
                jr  <= jr_in; 
                jl  <= jl_in;
                ir  <= ir_in;
                il  <= il_in; 
                gr  <= gr_in;
                gl  <= gl_in;
                di  <= di_in;
            end
    end

    always_comb
    begin
        mariod_x_pos_input = mariod_x;
        mariod_y_pos_input = mariod_y;
        mariod_x_motion_input = mariod_x_motion;
        mariod_y_motion_input = mariod_y_motion;
        process_input = process;
        NEXT_STATE = STATE;
        already_jump_in = already_jump;
        mario_counter_in = mario_counter;
        counter2_in = counter2;
        if (frame_clk_rising_edge)
            begin
                unique case (STATE)
                    default: 
                        begin
                            sr_in  = 1'b0;
                            sl_in  = 1'b0;
                            rr1_in = 1'b0;
                            rr2_in = 1'b0; 
                            rr3_in = 1'b0; 
                            rl1_in = 1'b0; 
                            rl2_in = 1'b0; 
                            rl3_in = 1'b0; 
                            jr_in  = 1'b0; 
                            jl_in  = 1'b0;
                            ir_in  = 1'b0;
                            il_in  = 1'b0; 
                            gr_in  = 1'b0;
                            gl_in  = 1'b0;
                            di_in  = 1'b0;
                        end

                    STAND_R:
                        begin
                            mariod_x_motion_input = 10'd0;
                            mariod_y_motion_input = 10'd0;
                            mario_counter_in = 24'b0;
                            counter2_in = 24'b0;
                            sr_in  = 1'b1;
                            sl_in  = 1'b0;
                            rr1_in = 1'b0;
                            rr2_in = 1'b0; 
                            rr3_in = 1'b0; 
                            rl1_in = 1'b0; 
                            rl2_in = 1'b0; 
                            rl3_in = 1'b0; 
                            jr_in  = 1'b0; 
                            jl_in  = 1'b0;
                            ir_in  = 1'b0;
                            il_in  = 1'b0; 
                            gr_in  = 1'b0;
                            gl_in  = 1'b0;
                            di_in  = 1'b0;
                            if (mariod_alive == 1'b0)
                                begin
                                    NEXT_STATE = DIE;
                                    mariod_x_motion_input = 10'd0;
                                    mariod_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else if (w && ~already_jump)
                                begin
                                    NEXT_STATE = JUMP_R;
                                    already_jump_in = 1'b1;
                                end
                            else if (a)
                                begin
                                    NEXT_STATE = RUN_1_L;
                                    already_jump_in = 1'b0;
                                end
                            else if (d)
                                begin
                                    NEXT_STATE = RUN_1_R;
                                    already_jump_in = 1'b0;
                                end
                            else if (~w)
                                begin
                                    NEXT_STATE = STAND_R;
                                    already_jump_in = 1'b0;
                                end
                            else if (mariod_in_air)
                                begin
                                    NEXT_STATE = IN_AIR_R;
                                end
                            else
                                begin
                                    NEXT_STATE = STAND_R;
                                    already_jump_in = already_jump;
                                end
                        end
                    
                    STAND_L:
                        begin
                            mariod_x_motion_input = 10'd0;
                            mariod_y_motion_input = 10'd0;
                            mario_counter_in = 24'b0;
                            counter2_in = 24'b0;
                            sr_in  = 1'b0;
                            sl_in  = 1'b1;
                            rr1_in = 1'b0;
                            rr2_in = 1'b0; 
                            rr3_in = 1'b0; 
                            rl1_in = 1'b0; 
                            rl2_in = 1'b0; 
                            rl3_in = 1'b0; 
                            jr_in  = 1'b0; 
                            jl_in  = 1'b0;
                            ir_in  = 1'b0;
                            il_in  = 1'b0; 
                            gr_in  = 1'b0;
                            gl_in  = 1'b0;
                            di_in  = 1'b0;
                            if (mariod_alive == 1'b0)
                                begin
                                    NEXT_STATE = DIE;
                                    mariod_x_motion_input = 10'd0;
                                    mariod_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else if (w && ~already_jump)
                                begin
                                    NEXT_STATE = JUMP_L;
                                    already_jump_in = 1'b1;
                                end
                            else if (a)
                                begin
                                    NEXT_STATE = RUN_1_L;
                                    already_jump_in = 1'b0;
                                end
                            else if (d)
                                begin
                                    NEXT_STATE = RUN_1_R;
                                    already_jump_in = 1'b0;
                                end
                            else if (~w)
                                begin
                                    NEXT_STATE = STAND_L;
                                    already_jump_in = 1'b0;
                                end
                            else if (mariod_in_air)
                                begin
                                    NEXT_STATE = IN_AIR_L;
                                end
                            else
                                begin
                                    NEXT_STATE = STAND_L;
                                    already_jump_in = already_jump;
                                end
                        end
                    
                    RUN_1_R:
                        begin
                            mariod_x_motion_input = 10'd2;
                            mariod_y_motion_input = 10'd0;
                            already_jump_in = already_jump;
                            sr_in  = 1'b0;
                            sl_in  = 1'b0;
                            rr1_in = 1'b1;
                            rr2_in = 1'b0; 
                            rr3_in = 1'b0; 
                            rl1_in = 1'b0; 
                            rl2_in = 1'b0; 
                            rl3_in = 1'b0; 
                            jr_in  = 1'b0; 
                            jl_in  = 1'b0;
                            ir_in  = 1'b0;
                            il_in  = 1'b0; 
                            gr_in  = 1'b0;
                            gl_in  = 1'b0;
                            di_in  = 1'b0;
                            if (mariod_x + mariod_x_size >= mariod_x_max)
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end
                            // kong qi qiang
                            if (mariod_x + mariod_x_motion_input + 10'd26 > 10'd101 && mariod_x + mariod_x_motion_input < 10'd99 && mariod_y > 10'd320 && d)
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end
                            if (mariod_x + mariod_x_motion_input + 10'd26 > 10'd641 && mariod_x + mariod_x_motion_input < 10'd639 && mariod_y > 10'd320 && d)
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end
                            if (~w)
                                begin
                                    already_jump_in = 1'b0;
                                end
                            if (mariod_alive == 1'd0)
                                begin
                                    NEXT_STATE = DIE;
                                    mariod_x_motion_input = 10'd0;
                                    mariod_y_motion_input = ~(9'd15) + 1'd1;
                                end
                            else if (mariod_in_air)
                                begin
                                    NEXT_STATE = IN_AIR_R;
                                end
                            else if (w && ~already_jump)
                                begin
                                    NEXT_STATE = JUMP_R;
                                    already_jump_in = 1'b1;
                                end
                            else if (d && mario_counter[1])
                                begin
                                    NEXT_STATE = RUN_2_R;
                                    mario_counter_in = 24'b0;
                                end
                            else if (d && ~mario_counter[1])
                                begin
                                    NEXT_STATE = RUN_1_R;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            mario_counter_in = mario_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            mario_counter_in = mario_counter;
                                            counter2_in = counter2 + 24'b1;
                                        end
                                end
                            else 
                                begin
                                    NEXT_STATE = STAND_R;
                                end
                        end

                    RUN_2_R:
                        begin
                            mariod_x_motion_input = 10'd2;
                            mariod_y_motion_input = 10'd0;
                            already_jump_in = already_jump;
                            sr_in  = 1'b0;
                            sl_in  = 1'b0;
                            rr1_in = 1'b0;
                            rr2_in = 1'b1; 
                            rr3_in = 1'b0; 
                            rl1_in = 1'b0; 
                            rl2_in = 1'b0; 
                            rl3_in = 1'b0; 
                            jr_in  = 1'b0; 
                            jl_in  = 1'b0;
                            ir_in  = 1'b0;
                            il_in  = 1'b0; 
                            gr_in  = 1'b0;
                            gl_in  = 1'b0;
                            di_in  = 1'b0;
                            if (mariod_x + mariod_x_size >= mariod_x_max)
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end
                            // kong qi qiang
                            if (mariod_x + mariod_x_motion_input + 10'd26 > 10'd101 && mariod_x + mariod_x_motion_input < 10'd99 && mariod_y > 10'd320 && d)
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end
                            if (mariod_x + mariod_x_motion_input + 10'd26 > 10'd641 && mariod_x + mariod_x_motion_input < 10'd639 && mariod_y > 10'd320 && d)
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end
                            if (~w)
                                begin
                                    already_jump_in = 1'b0;
                                end
                            if (mariod_alive == 1'd0)
                                begin
                                    NEXT_STATE = DIE;
                                    mariod_x_motion_input = 10'd0;
                                    mariod_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else if (mariod_in_air)
                                begin
                                    NEXT_STATE = IN_AIR_R;
                                end
                            else if (w && ~already_jump)
                                begin
                                    NEXT_STATE = JUMP_R;
                                    already_jump_in = 1'b1;
                                end
                            else if (d && mario_counter[1])
                                begin
                                    NEXT_STATE = RUN_3_R;
                                    mario_counter_in = 24'b0;
                                end
                            else if (d && ~mario_counter[1])
                                begin
                                    NEXT_STATE = RUN_2_R;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            mario_counter_in = mario_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            mario_counter_in = mario_counter;
                                            counter2_in = counter2 + 24'b1;
                                        end
                                end
                            else 
                                begin
                                    NEXT_STATE = STAND_R;
                                end
                        end

                    RUN_3_R:
                        begin
                            mariod_x_motion_input = 10'd2;
                            mariod_y_motion_input = 10'd0;
                            already_jump_in = already_jump;
                            sr_in  = 1'b0;
                            sl_in  = 1'b0;
                            rr1_in = 1'b0;
                            rr2_in = 1'b0; 
                            rr3_in = 1'b1; 
                            rl1_in = 1'b0; 
                            rl2_in = 1'b0; 
                            rl3_in = 1'b0; 
                            jr_in  = 1'b0; 
                            jl_in  = 1'b0;
                            ir_in  = 1'b0;
                            il_in  = 1'b0; 
                            gr_in  = 1'b0;
                            gl_in  = 1'b0;
                            di_in  = 1'b0;
                            if (mariod_x + mariod_x_size >= mariod_x_max)
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end

                            // kong qi qiang
                            if (mariod_x + mariod_x_motion_input + 10'd26 > 10'd101 && mariod_x + mariod_x_motion_input < 10'd99 && mariod_y > 10'd320 && d)
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end
                            if (mariod_x + mariod_x_motion_input + 10'd26 > 10'd641 && mariod_x + mariod_x_motion_input < 10'd639 && mariod_y > 10'd320 && d)
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end
                            if (~w)
                                begin
                                    already_jump_in = 1'b0;
                                end
                            if (mariod_alive == 1'd0)
                                begin
                                    NEXT_STATE = DIE;
                                    mariod_x_motion_input = 10'd0;
                                    mariod_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else if (mariod_in_air)
                                begin
                                    NEXT_STATE = IN_AIR_R;
                                end
                            else if (w && ~already_jump)
                                begin
                                    NEXT_STATE = JUMP_R;
                                    already_jump_in = 1'b1;
                                end
                            else if (d && mario_counter[1])
                                begin
                                    NEXT_STATE = RUN_1_R;
                                    mario_counter_in = 24'b0;
                                end
                            else if (d && ~mario_counter[1])
                                begin
                                    NEXT_STATE = RUN_3_R;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            mario_counter_in = mario_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            mario_counter_in = mario_counter;
                                            counter2_in = counter2 + 24'b1;
                                        end
                                end
                            else 
                                begin
                                    NEXT_STATE = STAND_R;
                                end
                        end

                    RUN_1_L:
                        begin
                            mariod_x_motion_input = (~10'd2) + 1'b1;
                            mariod_y_motion_input = 10'd0;
                            already_jump_in = already_jump;
                            sr_in  = 1'b0;
                            sl_in  = 1'b0;
                            rr1_in = 1'b0;
                            rr2_in = 1'b0; 
                            rr3_in = 1'b0; 
                            rl1_in = 1'b1; 
                            rl2_in = 1'b0; 
                            rl3_in = 1'b0; 
                            jr_in  = 1'b0; 
                            jl_in  = 1'b0;
                            ir_in  = 1'b0;
                            il_in  = 1'b0; 
                            gr_in  = 1'b0;
                            gl_in  = 1'b0;
                            di_in  = 1'b0;
                            if (mariod_x + mariod_x_motion <= 10'd1)
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end
                            if (mariod_x <= process + 10'd1) 
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end
                            // kong qi qiang
                            if (mariod_x + mariod_x_motion_input > 10'd101 && mariod_x + mariod_x_motion_input < 10'd99 + 10'd64 && mariod_y > 10'd320 && a)
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end
                            if (mariod_x + mariod_x_motion_input > 10'd641 && mariod_x + mariod_x_motion_input < 10'd639 + 10'd64 && mariod_y > 10'd320 && a)
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end
                            if (~w)
                                begin
                                    already_jump_in = 1'b0;
                                end
                            if (mariod_alive == 1'd0)
                                begin
                                    NEXT_STATE = DIE;
                                    mariod_x_motion_input = 10'd0;
                                    mariod_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else if (mariod_in_air)
                                begin
                                    NEXT_STATE = IN_AIR_L;
                                end
                            else if (w && ~already_jump)
                                begin
                                    NEXT_STATE = JUMP_L;
                                    already_jump_in = 1'b1;
                                end
                            else if (a && mario_counter[1])
                                begin
                                    NEXT_STATE = RUN_2_L;
                                    mario_counter_in = 24'b0;
                                end
                            else if (a && ~mario_counter[1])
                                begin
                                    NEXT_STATE = RUN_1_L;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            mario_counter_in = mario_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            mario_counter_in = mario_counter;
                                            counter2_in = counter2 + 24'b1;
                                        end
                                end
                            else 
                                begin
                                    NEXT_STATE = STAND_L;
                                end
                        end
                    
                    RUN_2_L:
                        begin
                            mariod_x_motion_input = (~10'd2) + 1'b1;
                            mariod_y_motion_input = 10'd0;
                            already_jump_in = already_jump;
                            sr_in  = 1'b0;
                            sl_in  = 1'b0;
                            rr1_in = 1'b0;
                            rr2_in = 1'b0; 
                            rr3_in = 1'b0; 
                            rl1_in = 1'b0; 
                            rl2_in = 1'b1; 
                            rl3_in = 1'b0; 
                            jr_in  = 1'b0; 
                            jl_in  = 1'b0;
                            ir_in  = 1'b0;
                            il_in  = 1'b0; 
                            gr_in  = 1'b0;
                            gl_in  = 1'b0;
                            di_in  = 1'b0;
                            if (mariod_x + mariod_x_motion <= 10'd1)
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end
                            if (mariod_x <= process + 10'd1) 
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end

                            // kong qi qiang
                            if (mariod_x + mariod_x_motion_input > 10'd101 && mariod_x + mariod_x_motion_input < 10'd99 + 10'd64 && mariod_y > 10'd320 && a)
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end
                            if (mariod_x + mariod_x_motion_input > 10'd641 && mariod_x + mariod_x_motion_input < 10'd639 + 10'd64 && mariod_y > 10'd320 && a)
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end
                            if (~w)
                                begin
                                    already_jump_in = 1'b0;
                                end
                            if (mariod_alive == 1'd0)
                                begin
                                    NEXT_STATE = DIE;
                                    mariod_x_motion_input = 10'd0;
                                    mariod_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else if (mariod_in_air)
                                begin
                                    NEXT_STATE = IN_AIR_L;
                                end
                            else if (w && ~already_jump)
                                begin
                                    NEXT_STATE = JUMP_L;
                                    already_jump_in = 1'b1;
                                end
                            else if (a && mario_counter[1])
                                begin
                                    NEXT_STATE = RUN_3_L;
                                    mario_counter_in = 24'b0;
                                end
                            else if (a && ~mario_counter[1])
                                begin
                                    NEXT_STATE = RUN_2_L;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            mario_counter_in = mario_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            mario_counter_in = mario_counter;
                                            counter2_in = counter2 + 24'b1;
                                        end
                                end
                            else 
                                begin
                                    NEXT_STATE = STAND_L;
                                end
                        end
                    
                    RUN_3_L:
                        begin
                            mariod_x_motion_input = (~10'd2) + 1'b1;
                            mariod_y_motion_input = 10'd0;
                            already_jump_in = already_jump;
                            sr_in  = 1'b0;
                            sl_in  = 1'b0;
                            rr1_in = 1'b0;
                            rr2_in = 1'b0; 
                            rr3_in = 1'b0; 
                            rl1_in = 1'b0; 
                            rl2_in = 1'b0; 
                            rl3_in = 1'b1; 
                            jr_in  = 1'b0; 
                            jl_in  = 1'b0;
                            ir_in  = 1'b0;
                            il_in  = 1'b0; 
                            gr_in  = 1'b0;
                            gl_in  = 1'b0;
                            di_in  = 1'b0;
                            if (mariod_x + mariod_x_motion <= 10'd1)
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end
                            if (mariod_x <= process + 10'd1) 
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end
                            // kong qi qiang
                            if (mariod_x + mariod_x_motion_input > 10'd101 && mariod_x + mariod_x_motion_input < 10'd99 + 10'd64 && mariod_y > 10'd320 && a)
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end
                             if (mariod_x + mariod_x_motion_input > 10'd641 && mariod_x + mariod_x_motion_input < 10'd639 + 10'd64 && mariod_y > 10'd320 && a)
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end                               
                            if (~w)
                                begin
                                    already_jump_in = 1'b0;
                                end
                            if (mariod_alive == 1'd0)
                                begin
                                    NEXT_STATE = DIE;
                                    mariod_x_motion_input = 10'd0;
                                    mariod_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else if (mariod_in_air)
                                begin
                                    NEXT_STATE = IN_AIR_L;
                                end
                            else if (w && ~already_jump)
                                begin
                                    NEXT_STATE = JUMP_L;
                                    already_jump_in = 1'b1;
                                end
                            else if (a && mario_counter[1])
                                begin
                                    NEXT_STATE = RUN_1_L;
                                    mario_counter_in = 24'b0;
                                end
                            else if (a && ~mario_counter[1])
                                begin
                                    NEXT_STATE = RUN_3_L;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            mario_counter_in = mario_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            mario_counter_in = mario_counter;
                                            counter2_in = counter2 + 24'b1;
                                        end
                                end
                            else 
                                begin
                                    NEXT_STATE = STAND_L;
                                end
                        end
                    
                    JUMP_R:
                        begin
                            sr_in  = 1'b0;
                            sl_in  = 1'b0;
                            rr1_in = 1'b0;
                            rr2_in = 1'b0; 
                            rr3_in = 1'b0; 
                            rl1_in = 1'b0; 
                            rl2_in = 1'b0; 
                            rl3_in = 1'b0; 
                            jr_in  = 1'b1; 
                            jl_in  = 1'b0;
                            ir_in  = 1'b0;
                            il_in  = 1'b0; 
                            gr_in  = 1'b0;
                            gl_in  = 1'b0;
                            di_in  = 1'b0;
                            mariod_x_motion_input = mariod_x_motion;
                            mariod_y_motion_input = (~10'd15) + 1'd1;
                            already_jump_in = 1'b1;
                            NEXT_STATE = IN_AIR_R;
                        end
                    
                    JUMP_L:
                        begin
                            sr_in  = 1'b0;
                            sl_in  = 1'b0;
                            rr1_in = 1'b0;
                            rr2_in = 1'b0; 
                            rr3_in = 1'b0; 
                            rl1_in = 1'b0; 
                            rl2_in = 1'b0; 
                            rl3_in = 1'b0; 
                            jr_in  = 1'b0; 
                            jl_in  = 1'b1;
                            ir_in  = 1'b0;
                            il_in  = 1'b0; 
                            gr_in  = 1'b0;
                            gl_in  = 1'b0;
                            di_in  = 1'b0;
                            mariod_x_motion_input = mariod_x_motion;
                            mariod_y_motion_input = (~10'd15) + 1'd1;
                            already_jump_in = 1'b1;
                            NEXT_STATE = IN_AIR_L;
                        end
                    
                    IN_AIR_R:
                        begin
                            sr_in  = 1'b0;
                            sl_in  = 1'b0;
                            rr1_in = 1'b0;
                            rr2_in = 1'b0; 
                            rr3_in = 1'b0; 
                            rl1_in = 1'b0; 
                            rl2_in = 1'b0; 
                            rl3_in = 1'b0; 
                            jr_in  = 1'b0; 
                            jl_in  = 1'b0;
                            ir_in  = 1'b1;
                            il_in  = 1'b0; 
                            gr_in  = 1'b0;
                            gl_in  = 1'b0;
                            di_in  = 1'b0;
                            if (a && ~d && mariod_x_motion_input == 10'd0)
                                begin
                                    mariod_x_motion_input = (~10'd2) + 1'b1;
        
                                    if (mariod_x + mariod_x_motion_input <= 10'd1)
                                        begin
                                            mariod_x_motion_input = 10'd0;
                                        end
                                end
                            else if (~a && d && mariod_x_motion_input == 10'd0)
                                begin
                                    mariod_x_motion_input = 10'd2;
                                    if (mariod_x + mariod_x_motion_input >= process + 10'd639)
                                        begin
                                            mariod_x_motion_input = 10'd0;
                                        end
                                end
                            else
                                begin
                                    mariod_x_motion_input = mariod_x_motion;
                                end

                            already_jump_in = 1'b1;
                            if (mariod_alive == 1'b0)
                                begin
                                    NEXT_STATE = DIE;
                                    mariod_x_motion_input = 10'd0;
                                    mariod_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else
                                begin
                                    if (mariod_in_air)
                                        begin
                                            NEXT_STATE = IN_AIR_R;
                                            mariod_y_motion_input = mariod_y_motion + 1'd1;
                                            if (mariod_y + mariod_y_motion < 10'd5)
                                                begin
                                                    mariod_y_motion_input = (~mariod_y_motion) + 10'd1;
                                                end
                                            // if (mariod_y + mariod_y_motion >= level)
                                            //     begin
                                            //         mariod_y_motion_input = 10'd0;
                                            //     end
                                        end
                                    else
                                        begin
                                            if (a == 1'b1)
                                                begin
                                                    NEXT_STATE = GLIDE_L;
                                                end
                                            else 
                                                begin
                                                    NEXT_STATE = GLIDE_R;
                                                end
                                            mariod_y_motion_input = 10'd0;
                                            if (w)
                                                begin
                                                    already_jump_in = 1'b1;
                                                end
                                            else
                                                begin
                                                    already_jump_in = 1'b0;
                                                end
                                        end
                                end
                        end

                    IN_AIR_L:
                        begin
                            sr_in  = 1'b0;
                            sl_in  = 1'b0;
                            rr1_in = 1'b0;
                            rr2_in = 1'b0; 
                            rr3_in = 1'b0; 
                            rl1_in = 1'b0; 
                            rl2_in = 1'b0; 
                            rl3_in = 1'b0; 
                            jr_in  = 1'b0; 
                            jl_in  = 1'b0;
                            ir_in  = 1'b0;
                            il_in  = 1'b1; 
                            gr_in  = 1'b0;
                            gl_in  = 1'b0;
                            di_in  = 1'b0;
                            if (a && ~d && mariod_x_motion_input == 10'd0)
                                begin
                                    mariod_x_motion_input = (~10'd2) + 1'b1;
        
                                    if (mariod_x + mariod_x_motion_input <= 10'd1)
                                        begin
                                            mariod_x_motion_input = 10'd0;
                                        end
                                end
                            else if (~a && d && mariod_x_motion_input == 10'd0)
                                begin
                                    mariod_x_motion_input = 10'd2;
                                    if (mariod_x + mariod_x_motion_input >= process + 10'd639)
                                        begin
                                            mariod_x_motion_input = 10'd0;
                                        end
                                end
                            else
                                begin
                                    mariod_x_motion_input = mariod_x_motion;
                                end

                            already_jump_in = 1'b1;
                            if (mariod_alive == 1'b0)
                                begin
                                    NEXT_STATE = DIE;
                                    mariod_x_motion_input = 10'd0;
                                    mariod_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else
                                begin
                                    if (mariod_in_air)
                                        begin
                                            NEXT_STATE = IN_AIR_L;
                                            mariod_y_motion_input = mariod_y_motion + 1'd1;
                                            if (mariod_y + mariod_y_motion < 10'd5)
                                                begin
                                                    mariod_y_motion_input = (~mariod_y_motion) + 10'd1;
                                                end
                                            if (mariod_x <= process + 10'd1) 
                                                begin
                                                    mariod_x_motion_input = 10'd0;
                                                end
                                            // if (mariod_y + mariod_y_motion >= level)
                                            //     begin
                                            //         mariod_y_motion_input = 10'd0;
                                            //     end
                                        end
                                    else
                                        begin
                                            if (a == 1'b1)
                                                begin
                                                    NEXT_STATE = GLIDE_L;
                                                end
                                            else 
                                                begin
                                                    NEXT_STATE = GLIDE_R;
                                                end
                                            mariod_y_motion_input = 10'd0;
                                            if (w)
                                                begin
                                                    already_jump_in = 1'b1;
                                                end
                                            else
                                                begin
                                                    already_jump_in = 1'b0;
                                                end
                                        end
                                end
                        end
                    
                    GLIDE_R:
                        begin
                            mariod_y_motion_input = 10'd0;
                            mariod_x_motion_input = mariod_x_motion;
                            sr_in  = 1'b0;
                            sl_in  = 1'b0;
                            rr1_in = 1'b0;
                            rr2_in = 1'b0; 
                            rr3_in = 1'b0; 
                            rl1_in = 1'b0; 
                            rl2_in = 1'b0; 
                            rl3_in = 1'b0; 
                            jr_in  = 1'b0; 
                            jl_in  = 1'b0;
                            ir_in  = 1'b0;
                            il_in  = 1'b0; 
                            gr_in  = 1'b1;
                            gl_in  = 1'b0;
                            di_in  = 1'b0;
                            if (mariod_alive == 1'd0)
                                begin
                                    NEXT_STATE = DIE;
                                    mariod_x_motion_input = 10'd0;
                                    mariod_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else if (mariod_x + mariod_x_size >= mariod_x_max)
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end
                            else
                                begin
                                    if (mariod_x_motion == 10'd0)
                                        begin
                                            NEXT_STATE = STAND_R;
                                        end
                                    else if (mariod_x_motion == 10'd1)
                                        begin
                                            NEXT_STATE = RUN_1_R;
                                        end
                                    else if (mariod_x_motion == 10'd2)
                                        begin
                                            NEXT_STATE = RUN_2_R;
                                        end
                                    else if (mariod_x_motion == 10'd3)
                                        begin
                                            NEXT_STATE = RUN_3_R;
                                        end
                                    else if (mariod_x_motion == (~10'd1) + 1'b1)
                                        begin
                                            NEXT_STATE = RUN_1_L;
                                        end
                                    else if (mariod_x_motion == (~10'd2) + 1'b1)
                                        begin
                                            NEXT_STATE = RUN_2_L;
                                        end
                                    else if (mariod_x_motion == (~10'd3) + 1'b1)
                                        begin
                                            NEXT_STATE = RUN_3_L;
                                        end
                                    else
                                        NEXT_STATE = STAND_R;
                                end
                        end

                    GLIDE_L:
                        begin
                            mariod_y_motion_input = 10'd0;
                            mariod_x_motion_input = mariod_x_motion;
                            sr_in  = 1'b0;
                            sl_in  = 1'b0;
                            rr1_in = 1'b0;
                            rr2_in = 1'b0; 
                            rr3_in = 1'b0; 
                            rl1_in = 1'b0; 
                            rl2_in = 1'b0; 
                            rl3_in = 1'b0; 
                            jr_in  = 1'b0; 
                            jl_in  = 1'b0;
                            ir_in  = 1'b0;
                            il_in  = 1'b0; 
                            gr_in  = 1'b0;
                            gl_in  = 1'b1;
                            di_in  = 1'b0;
                            if (mariod_alive == 1'd0)
                                begin
                                    NEXT_STATE = DIE;
                                    mariod_x_motion_input = 10'd0;
                                    mariod_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else if (mariod_x + mariod_x_size >= mariod_x_max)
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end
                            else if (mariod_x <= process + 10'd1)
                                begin
                                    mariod_x_motion_input = 10'd0;
                                end
                            else
                                begin
                                    if (mariod_x_motion == 10'd0)
                                        begin
                                            NEXT_STATE = STAND_L;
                                        end
                                    else if (mariod_x_motion == 10'd1)
                                        begin
                                            NEXT_STATE = RUN_1_R;
                                        end
                                    else if (mariod_x_motion == 10'd2)
                                        begin
                                            NEXT_STATE = RUN_2_R;
                                        end
                                    else if (mariod_x_motion == 10'd3)
                                        begin
                                            NEXT_STATE = RUN_3_R;
                                        end
                                    else if (mariod_x_motion == (~10'd1) + 1'b1)
                                        begin
                                            NEXT_STATE = RUN_1_L;
                                        end
                                    else if (mariod_x_motion == (~10'd2) + 1'b1)
                                        begin
                                            NEXT_STATE = RUN_2_L;
                                        end
                                    else if (mariod_x_motion == (~10'd3) + 1'b1)
                                        begin
                                            NEXT_STATE = RUN_3_L;
                                        end
                                    else
                                        NEXT_STATE = STAND_L;
                                end
                        end
                    
                    DIE:
                        begin
                            sr_in  = 1'b0;
                            sl_in  = 1'b0;
                            rr1_in = 1'b0;
                            rr2_in = 1'b0; 
                            rr3_in = 1'b0; 
                            rl1_in = 1'b0; 
                            rl2_in = 1'b0; 
                            rl3_in = 1'b0; 
                            jr_in  = 1'b0; 
                            jl_in  = 1'b0;
                            ir_in  = 1'b0;
                            il_in  = 1'b0; 
                            gr_in  = 1'b0;
                            gl_in  = 1'b0;
                            di_in  = 1'b1;
                            NEXT_STATE = DIE;
                            mariod_y_motion_input = mariod_y_motion + 1'd1;
                        end
                endcase
                
                mariod_x_pos_input = mariod_x + mariod_x_motion;
                if (mariod_x_pos_input >= mariod_x_max)
                    begin
                        mariod_x_pos_input = mariod_x_max;
                    end
                if (mariod_in_air || (STATE == DIE))
                    begin
                        mariod_y_pos_input = mariod_y + mariod_y_motion;
                        if ((STATE == DIE) && (mariod_y + mariod_y_motion >= mariod_y_max))
                            begin
                                mariod_y_pos_input = mariod_y_max;
                            end
                    end
                else
                    begin
                        mariod_y_pos_input = altitude;
                    end
                    
                if (mariod_x >= process + 10'd320)
                    begin
                        if (mariod_x_motion[9] == 1'b0)
                            begin
                                process_input = process + mariod_x_motion;
                            end
                    end
                if (process >= 10'd383)
                    begin
                        process_input = process;
                    end
                if (luigi_at_edge)
                    begin
                        process_input = process;
                    end

                if ((mariod_x_pos_input + 10'd26 > luigi_x) && (luigi_x + 10'd26 > mariod_x_pos_input))
                    begin
                        if (mariod_y_pos_input == luigi_y)
                            begin
                                mariod_x_pos_input = mariod_x;
                            end
                        else
                            begin
                                mariod_x_pos_input = mariod_x_pos_input;
                            end
                        
                    end
            end
        else
            begin
                sr_in  = sr;
                sl_in  = sl;
                rr1_in = rr1;
                rr2_in = rr2; 
                rr3_in = rr3; 
                rl1_in = rl1; 
                rl2_in = rl2; 
                rl3_in = rl3; 
                jr_in  = jr; 
                jl_in  = jl;
                ir_in  = ir;
                il_in  = il; 
                gr_in  = gr;
                gl_in  = gl;
                di_in  = di;
            end
    end
endmodule
                
// module mariod_image (
//         input Clk, Reset, frame_clk,
//         input [9:0] mariod_x,
//         input sl, sr, rr1, rr2, rr3, rl1, rl2, rl3, jr, jl, ir, gr, gl, di,il,
//         input [23:0] mariod_sl, mariod_sr, mariod_rl1, mariod_rl2, mariod_rl3, mariod_rr1, mariod_rr2, mariod_rr3, mariod_jr, mariod_jl, mariod_die,
//         output [23:0] mariod_pic_out
// );
//     always_ff @ (posedge Clk)
//         begin
//             if (sl == 1'b1)
//                 begin
//                     mariod_pic_out = mariod_sl;
//                 end
//             else if (sr == 1'b1)
//                 begin
//                     mariod_pic_out = mariod_sr;
//                 end
//             else if (rr1 == 1'b1)
//                 begin
//                     mariod_pic_out = mariod_rr1;
//                 end
//             else if (rr2 == 1'b1)
//                 begin
//                     mariod_pic_out = mariod_rr2;
//                 end
//             else if (rr3 == 1'b1)
//                 begin
//                     mariod_pic_out = mariod_rr3;
//                 end
//             else if (rl1 == 1'b1)
//                 begin
//                     mariod_pic_out = mariod_rl1;
//                 end
//             else if (rl2 == 1'b1)
//                 begin
//                     mariod_pic_out = mariod_rl2;
//                 end
//             else if (rl3 == 1'b1)
//                 begin
//                     mariod_pic_out = mariod_rl3;
//                 end
//             else if (jr == 1'b1)
//                 begin
//                     mariod_pic_out = mariod_jr;
//                 end
//             else if (jl == 1'b1)
//                 begin
//                     mariod_pic_out = mariod_jl;
//                 end
//             else if (ir == 1'b1)
//                 begin
//                     mariod_pic_out = mariod_jr;
//                 end
//             else if (il == 1'b1)
//                 begin
//                     mariod_pic_out = mariod_jl;
//                 end
//             else if (gr == 1'b1)
//                 begin
//                     mariod_pic_out = mariod_jr;
//                 end
//             else if (gl == 1'b1)
//                 begin
//                     mariod_pic_out = mariod_jl;
//                 end
//             else if (di == 1'b1)
//                 begin
//                     mariod_pic_out = mariod_die;
//                 end
//             else
//                 begin
//                     mariod_pic_out = mariod_sr;
//                 end
//         end
    
// endmodule