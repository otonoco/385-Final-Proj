module luigi_d (
        input Reset, frame_clk, Clk,
        input [31:0] keycode,
        input [9:0] DrawX, DrawY,
        input luigi_alive,
        input [9:0] mario_x, mario_y,
        input [9:0] process_from_mario,
        input [23:0] luigi_sl, luigi_sr, luigi_rl1, luigi_rl2, luigi_rl3, luigi_rr1, luigi_rr2, luigi_rr3, luigi_jr, luigi_jl, luigi_die,

        output logic [9:0] luigi_x, luigi_y, process, luigi_y_motion,
        output logic luigi, luigi_in_air,
        output logic at_edge,luigi_arrived,
        output logic [23:0] luigi_pic_out
);
    logic w, s, a, d;
    logic sl, sr, rr1, rr2, rr3, rl1, rl2, rl3, jr, jl, il, ir, gr, gl, di;

    assign a = ((keycode[15:8] == 8'h50) | (keycode[7:0] == 8'h50)|(keycode[23:16] == 8'h50) | (keycode[31:24] == 8'h50));
    assign d = ((keycode[15:8] == 8'h4F) | (keycode[7:0] == 8'h4F)|(keycode[23:16] == 8'h4F) | (keycode[31:24] == 8'h4F));
    assign w = ((keycode[15:8] == 8'h52) | (keycode[7:0] == 8'h52)|(keycode[23:16] == 8'h52) | (keycode[31:24] == 8'h52));
    assign s = ((keycode[15:8] == 8'h51) | (keycode[7:0] == 8'h51)|(keycode[23:16] == 8'h51) | (keycode[31:24] == 8'h51));

    // luigi_image m_i(.*);
    luigi_movem m_m(.*);

    always_ff @ (posedge Clk)
        begin
            if (sl == 1'b1)
                begin
                    luigi_pic_out = luigi_sl;
                end
            else if (sr == 1'b1)
                begin
                    luigi_pic_out = luigi_sr;
                end
            else if (rr1 == 1'b1)
                begin
                    luigi_pic_out = luigi_rr1;
                end
            else if (rr2 == 1'b1)
                begin
                    luigi_pic_out = luigi_rr2;
                end
            else if (rr3 == 1'b1)
                begin
                    luigi_pic_out = luigi_rr3;
                end
            else if (rl1 == 1'b1)
                begin
                    luigi_pic_out = luigi_rl1;
                end
            else if (rl2 == 1'b1)
                begin
                    luigi_pic_out = luigi_rl2;
                end
            else if (rl3 == 1'b1)
                begin
                    luigi_pic_out = luigi_rl3;
                end
            else if (jr == 1'b1)
                begin
                    luigi_pic_out = luigi_jr;
                end
            else if (jl == 1'b1)
                begin
                    luigi_pic_out = luigi_jl;
                end
            else if (ir == 1'b1)
                begin
                    luigi_pic_out = luigi_jr;
                end
            else if (il == 1'b1)
                begin
                    luigi_pic_out = luigi_jl;
                end
            else if (gr == 1'b1)
                begin
                    luigi_pic_out = luigi_jr;
                end
            else if (gl == 1'b1)
                begin
                    luigi_pic_out = luigi_jl;
                end
            else if (di == 1'b1)
                begin
                    luigi_pic_out = luigi_die;
                end
            else
                begin
                    luigi_pic_out = luigi_sr;
                end
            
        end

    always_comb
    begin
        if (luigi_x < process_from_mario + DrawX && DrawX + process_from_mario < luigi_x + 10'd26 && DrawY > luigi_y && DrawY < luigi_y + 10'd32)
            begin
                luigi = 1'b1;
            end
        else
            luigi = 1'b0;
		if (luigi_x > 10'd830)
            begin
                luigi_arrived = 1'b1;
            end
        else
			begin
                luigi_arrived = 1'b0;
			end
    end

endmodule 


module luigi_movem (
        input Clk, Reset, frame_clk,
        input w, s, a, d,
        input luigi_alive,
        input [9:0] mario_x, mario_y, process_from_mario,
        output logic [9:0] luigi_x, luigi_y, process, luigi_y_motion,
        output logic luigi_in_air,
        output logic at_edge,
        output logic sl, sr, rr1, rr2, rr3, rl1, rl2, rl3, jr, jl, il, ir, gr, gl, di
);

    parameter [9:0] luigi_x_ori = 50;
    parameter [9:0] luigi_y_ori = 400;

    parameter [9:0] luigi_x_min = 0;
    parameter [9:0] luigi_x_max = 1023;
    parameter [9:0] luigi_y_min = 0;
    parameter [9:0] luigi_y_max = 479;
    parameter [9:0] luigi_x_step = 2;

    parameter [9:0] luigi_x_size = 26;

    logic [9:0] luigi_x_motion, altitude;
    logic [9:0] luigi_x_pos_input, luigi_x_motion_input, luigi_y_pos_input, luigi_y_motion_input;
    logic [9:0] process_input;

    logic sl_in, sr_in, rr1_in, rr2_in, rr3_in, rl1_in, rl2_in, rl3_in, jr_in, jl_in, ir_in, il_in, gr_in, gl_in, di_in;

    logic [23:0] luigi_counter, luigi_counter_in;
    logic [23:0] counter2, counter2_in;
    logic already_jump, already_jump_in;
    logic at_edge_in;
	logic i;
    always_comb
    begin
        if (luigi_y + luigi_y_motion >= 10'd384)
            begin
                luigi_in_air = 1'b0;
                altitude = 10'd384;
            end
		else if ((luigi_x + 10'd26 > 10'd100) && (luigi_x < 10'd100 + 10'd62) && (luigi_y + luigi_y_motion >= 10'd320) && (luigi_y + luigi_y_motion < 10'd384))
            begin
                luigi_in_air = 1'b0;
                altitude = 10'd320;
            end
		else if ((luigi_x + 10'd26 > 10'd640) && (luigi_x < 10'd640 + 10'd62) && (luigi_y + luigi_y_motion >= 10'd320) && (luigi_y + luigi_y_motion < 10'd384))
            begin
                luigi_in_air = 1'b0;
                altitude = 10'd320;
            end
        else if ((luigi_x + 10'd26 > mario_x) && (luigi_x < mario_x + 10'd26) && (luigi_y + luigi_y_motion >= mario_y - 10'd32) && (luigi_y + luigi_y_motion < 10'd384))
            begin
                luigi_in_air = 1'b0;
                altitude = mario_y - 10'd32;
            end

        else
            begin
                luigi_in_air = 1'b1;
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
                luigi_x <= 10'd80;
                luigi_y <= 10'd384;
                luigi_x_motion <= 10'd0;
                luigi_y_motion <= 10'd0;
                process <= 10'd0;
                STATE <= STAND_R;
                luigi_counter <= 24'b0;
                counter2 <= 24'b0;
                already_jump <= 1'b0;
                at_edge <= 1'b0;
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
                luigi_x <= luigi_x_pos_input;
                luigi_y <= luigi_y_pos_input;
                luigi_x_motion <= luigi_x_motion_input;
                luigi_y_motion <= luigi_y_motion_input;
                process <= process_input;
                STATE <= NEXT_STATE;
                luigi_counter <= luigi_counter_in;
                counter2 <= counter2_in;
                already_jump <= already_jump_in;
                at_edge <= at_edge_in;
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
        luigi_x_pos_input = luigi_x;
        luigi_y_pos_input = luigi_y;
        luigi_x_motion_input = luigi_x_motion;
        luigi_y_motion_input = luigi_y_motion;
        process_input = process;
        NEXT_STATE = STATE;
        already_jump_in = already_jump;
        luigi_counter_in = luigi_counter;
        counter2_in = counter2;
        at_edge_in = at_edge;
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
                            luigi_x_motion_input = 10'd0;
                            luigi_y_motion_input = 10'd0;
                            luigi_counter_in = 24'b0;
                            counter2_in = 24'b0;
                            at_edge_in = 1'b0;
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
                            if (luigi_x <= process_from_mario)
                                begin
                                    at_edge_in = 1'b1;
                                end
                            if (luigi_alive == 1'b0)
                                begin
                                    NEXT_STATE = DIE;
                                    luigi_x_motion_input = 10'd0;
                                    luigi_y_motion_input = ~(10'd15) + 1'd1;
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
                            else if (luigi_in_air)
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
                            luigi_x_motion_input = 10'd0;
                            luigi_y_motion_input = 10'd0;
                            luigi_counter_in = 24'b0;
                            counter2_in = 24'b0;
                            at_edge_in = 1'b0;
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
                            if (luigi_x <= process_from_mario)
                                begin
                                    at_edge_in = 1'b1;
                                end
                            if (luigi_alive == 1'b0)
                                begin
                                    NEXT_STATE = DIE;
                                    luigi_x_motion_input = 10'd0;
                                    luigi_y_motion_input = ~(10'd15) + 1'd1;
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
                            else if (luigi_in_air)
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
                            luigi_x_motion_input = 10'd2;
                            luigi_y_motion_input = 10'd0;
                            already_jump_in = already_jump;
                            at_edge_in = 1'b0;
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
                            if (luigi_x + luigi_x_size >= process_from_mario + 10'd640)
                                begin
                                    luigi_x_motion_input = 10'd2;
                                end
							if (luigi_x + luigi_x_motion_input + 10'd26 > 10'd101 && luigi_x + luigi_x_motion_input < 10'd99 && luigi_y > 10'd320 && d)
                                begin
                                    luigi_x_motion_input = 10'd0;
                                end
                            if (luigi_x + luigi_x_motion_input + 10'd26 > 10'd641 && luigi_x + luigi_x_motion_input < 10'd639 && luigi_y > 10'd320 && d)
                                begin
                                    luigi_x_motion_input = 10'd0;
                                end
                            if (~w)
                                begin
                                    already_jump_in = 1'b0;
                                end
                            if (luigi_alive == 1'd0)
                                begin
                                    NEXT_STATE = DIE;
                                    luigi_x_motion_input = 10'd0;
                                    luigi_y_motion_input = ~(9'd15) + 1'd1;
                                end
                            else if (luigi_in_air)
                                begin
                                    NEXT_STATE = IN_AIR_R;
                                end
                            else if (w && ~already_jump)
                                begin
                                    NEXT_STATE = JUMP_R;
                                    already_jump_in = 1'b1;
                                end
                            else if (d && luigi_counter[1])
                                begin
                                    NEXT_STATE = RUN_2_R;
                                    luigi_counter_in = 24'b0;
                                end
                            else if (d && ~luigi_counter[1])
                                begin
                                    NEXT_STATE = RUN_1_R;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            luigi_counter_in = luigi_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            luigi_counter_in = luigi_counter;
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
                            luigi_x_motion_input = 10'd2;
                            luigi_y_motion_input = 10'd0;
                            at_edge_in = 1'b0;
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
                            if (luigi_x + luigi_x_size >= process_from_mario + 10'd640)
                                begin
                                    luigi_x_motion_input = 10'd2;
                                end
							if (luigi_x + luigi_x_motion_input + 10'd26 > 10'd101 && luigi_x + luigi_x_motion_input < 10'd99 && luigi_y > 10'd320 && d)
                                begin
                                    luigi_x_motion_input = 10'd0;
                                end
                            if (luigi_x + luigi_x_motion_input + 10'd26 > 10'd641 && luigi_x + luigi_x_motion_input < 10'd639 && luigi_y > 10'd320 && d)
                                begin
                                    luigi_x_motion_input = 10'd0;
                                end
                            if (~w)
                                begin
                                    already_jump_in = 1'b0;
                                end
                            if (luigi_alive == 1'd0)
                                begin
                                    NEXT_STATE = DIE;
                                    luigi_x_motion_input = 10'd0;
                                    luigi_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else if (luigi_in_air)
                                begin
                                    NEXT_STATE = IN_AIR_R;
                                end
                            else if (w && ~already_jump)
                                begin
                                    NEXT_STATE = JUMP_R;
                                    already_jump_in = 1'b1;
                                end
                            else if (d && luigi_counter[1])
                                begin
                                    NEXT_STATE = RUN_3_R;
                                    luigi_counter_in = 24'b0;
                                end
                            else if (d && ~luigi_counter[1])
                                begin
                                    NEXT_STATE = RUN_2_R;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            luigi_counter_in = luigi_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            luigi_counter_in = luigi_counter;
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
                            luigi_x_motion_input = 10'd2;
                            luigi_y_motion_input = 10'd0;
                            at_edge_in = 1'b0;
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
                            if (luigi_x + luigi_x_size >= process_from_mario + 10'd640)
                                begin
                                    luigi_x_motion_input = 10'd2;
                                end
							if (luigi_x + luigi_x_motion_input + 10'd26 > 10'd101 && luigi_x + luigi_x_motion_input < 10'd99 && luigi_y > 10'd320 && d)
                                begin
                                    luigi_x_motion_input = 10'd0;
                                end
                            if (luigi_x + luigi_x_motion_input + 10'd26 > 10'd641 && luigi_x + luigi_x_motion_input < 10'd639 && luigi_y > 10'd320 && d)
                                begin
                                    luigi_x_motion_input = 10'd0;
                                end
                            if (~w)
                                begin
                                    already_jump_in = 1'b0;
                                end
                            if (luigi_alive == 1'd0)
                                begin
                                    NEXT_STATE = DIE;
                                    luigi_x_motion_input = 10'd0;
                                    luigi_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else if (luigi_in_air)
                                begin
                                    NEXT_STATE = IN_AIR_R;
                                end
                            else if (w && ~already_jump)
                                begin
                                    NEXT_STATE = JUMP_R;
                                    already_jump_in = 1'b1;
                                end
                            else if (d && luigi_counter[1])
                                begin
                                    NEXT_STATE = RUN_1_R;
                                    luigi_counter_in = 24'b0;
                                end
                            else if (d && ~luigi_counter[1])
                                begin
                                    NEXT_STATE = RUN_3_R;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            luigi_counter_in = luigi_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            luigi_counter_in = luigi_counter;
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
                            luigi_x_motion_input = (~10'd2) + 1'b1;
                            luigi_y_motion_input = 10'd0;
                            at_edge_in = 1'b0;
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
                            if (luigi_x + luigi_x_motion <= process_from_mario)
                                begin
                                    luigi_x_motion_input = 10'd0;
                                    at_edge_in = 1'b1;
                                end
							if (luigi_x + luigi_x_motion_input > 10'd101 && luigi_x + luigi_x_motion_input < 10'd99 + 10'd64 && luigi_y > 10'd320 && a)
                                begin
                                    luigi_x_motion_input = 10'd0;
                                end
                            if (luigi_x + luigi_x_motion_input > 10'd641 && luigi_x + luigi_x_motion_input < 10'd639 + 10'd64 && luigi_y > 10'd320 && a)
                                begin
                                    luigi_x_motion_input = 10'd0;
                                end
                            if (~w)
                                begin
                                    already_jump_in = 1'b0;
                                end
                            if (luigi_alive == 1'd0)
                                begin
                                    NEXT_STATE = DIE;
                                    luigi_x_motion_input = 10'd0;
                                    luigi_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else if (luigi_in_air)
                                begin
                                    NEXT_STATE = IN_AIR_L;
                                end
                            else if (w && ~already_jump)
                                begin
                                    NEXT_STATE = JUMP_L;
                                    already_jump_in = 1'b1;
                                end
                            else if (a && luigi_counter[1])
                                begin
                                    NEXT_STATE = RUN_2_L;
                                    luigi_counter_in = 24'b0;
                                end
                            else if (a && ~luigi_counter[1])
                                begin
                                    NEXT_STATE = RUN_1_L;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            luigi_counter_in = luigi_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            luigi_counter_in = luigi_counter;
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
                            luigi_x_motion_input = (~10'd2) + 1'b1;
                            luigi_y_motion_input = 10'd0;
                            at_edge_in = 1'b0;
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
                            if (luigi_x + luigi_x_motion <= process_from_mario)
                                begin
                                    luigi_x_motion_input = 10'd0;
                                    at_edge_in = 1'b1;
                                end
							if (luigi_x + luigi_x_motion_input > 10'd101 && luigi_x + luigi_x_motion_input < 10'd99 + 10'd64 && luigi_y > 10'd320 && a)
                                begin
                                    luigi_x_motion_input = 10'd0;
                                end
                            if (luigi_x + luigi_x_motion_input > 10'd641 && luigi_x + luigi_x_motion_input < 10'd639 + 10'd64 && luigi_y > 10'd320 && a)
                                begin
                                    luigi_x_motion_input = 10'd0;
                                end
                            if (~w)
                                begin
                                    already_jump_in = 1'b0;
                                end
                            if (luigi_alive == 1'd0)
                                begin
                                    NEXT_STATE = DIE;
                                    luigi_x_motion_input = 10'd0;
                                    luigi_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else if (luigi_in_air)
                                begin
                                    NEXT_STATE = IN_AIR_L;
                                end
                            else if (w && ~already_jump)
                                begin
                                    NEXT_STATE = JUMP_L;
                                    already_jump_in = 1'b1;
                                end
                            else if (a && luigi_counter[1])
                                begin
                                    NEXT_STATE = RUN_3_L;
                                    luigi_counter_in = 24'b0;
                                end
                            else if (a && ~luigi_counter[1])
                                begin
                                    NEXT_STATE = RUN_2_L;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            luigi_counter_in = luigi_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            luigi_counter_in = luigi_counter;
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
                            luigi_x_motion_input = (~10'd2) + 1'b1;
                            luigi_y_motion_input = 10'd0;
                            at_edge_in = 1'b0;
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
                            if (luigi_x + luigi_x_motion <= process_from_mario)
                                begin
                                    luigi_x_motion_input = 10'd0;
                                    at_edge_in = 1'b1;
                                end
							if (luigi_x + luigi_x_motion_input > 10'd101 && luigi_x + luigi_x_motion_input < 10'd99 + 10'd64 && luigi_y > 10'd320 && a)
                                begin
                                    luigi_x_motion_input = 10'd0;
                                end
                            if (luigi_x + luigi_x_motion_input > 10'd641 && luigi_x + luigi_x_motion_input < 10'd639 + 10'd64 && luigi_y > 10'd320 && a)
                                begin
                                    luigi_x_motion_input = 10'd0;
                                end
                            if (~w)
                                begin
                                    already_jump_in = 1'b0;
                                end
                            if (luigi_alive == 1'd0)
                                begin
                                    NEXT_STATE = DIE;
                                    luigi_x_motion_input = 10'd0;
                                    luigi_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else if (luigi_in_air)
                                begin
                                    NEXT_STATE = IN_AIR_L;
                                end
                            else if (w && ~already_jump)
                                begin
                                    NEXT_STATE = JUMP_L;
                                    already_jump_in = 1'b1;
                                end
                            else if (a && luigi_counter[1])
                                begin
                                    NEXT_STATE = RUN_1_L;
                                    luigi_counter_in = 24'b0;
                                end
                            else if (a && ~luigi_counter[1])
                                begin
                                    NEXT_STATE = RUN_3_L;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            luigi_counter_in = luigi_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            luigi_counter_in = luigi_counter;
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
                            luigi_x_motion_input = luigi_x_motion;
                            luigi_y_motion_input = (~10'd15) + 1'd1;
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
                            luigi_x_motion_input = luigi_x_motion;
                            luigi_y_motion_input = (~10'd15) + 1'd1;
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
                            if (a && ~d && luigi_x_motion_input == 10'd0)
                                begin
                                    luigi_x_motion_input = (~10'd2) + 1'b1;
        
                                    if (luigi_x + luigi_x_motion_input <= 10'd1)
                                        begin
                                            luigi_x_motion_input = 10'd0;
                                        end
                                end
                            else if (~a && d && luigi_x_motion_input == 10'd0)
                                begin
                                    luigi_x_motion_input = 10'd2;
                                    if (luigi_x + luigi_x_motion_input >= process_from_mario + 10'd639)
                                        begin
                                            luigi_x_motion_input = 10'd0;
                                        end
                                end
                            else
                                begin
                                    luigi_x_motion_input = luigi_x_motion;
                                end

                            already_jump_in = 1'b1;
                            if (luigi_alive == 1'b0)
                                begin
                                    NEXT_STATE = DIE;
                                    luigi_x_motion_input = 10'd0;
                                    luigi_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else
                                begin
                                    if (luigi_in_air)
                                        begin
                                            NEXT_STATE = IN_AIR_R;
                                            luigi_y_motion_input = luigi_y_motion + 1'd1;
                                            if (luigi_y + luigi_y_motion < 10'd5)
                                                begin
                                                    luigi_y_motion_input = (~luigi_y_motion) + 10'd1;
                                                end
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
                                            luigi_y_motion_input = 10'd0;
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
                            if (a && ~d && luigi_x_motion_input == 10'd0)
                                begin
                                    luigi_x_motion_input = (~10'd2) + 1'b1;
        
                                    if (luigi_x + luigi_x_motion_input <= process_from_mario)
                                        begin
                                            luigi_x_motion_input = 10'd0;
                                            at_edge_in = 1'b1;
                                        end
                                end
                            else if (~a && d && luigi_x_motion_input == 10'd0)
                                begin
                                    luigi_x_motion_input = 10'd2;
                                    if (luigi_x + luigi_x_motion_input >= process_from_mario + 10'd639)
                                        begin
                                            luigi_x_motion_input = 10'd0;
                                        end
                                end
                            else
                                begin
                                    luigi_x_motion_input = luigi_x_motion;
                                end

                            already_jump_in = 1'b1;
                            if (luigi_alive == 1'b0)
                                begin
                                    NEXT_STATE = DIE;
                                    luigi_x_motion_input = 10'd0;
                                    luigi_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else
                                begin
                                    if (luigi_in_air)
                                        begin
                                            NEXT_STATE = IN_AIR_L;
                                            luigi_y_motion_input = luigi_y_motion + 1'd1;
                                            if (luigi_y + luigi_y_motion < 10'd5)
                                                begin
                                                    luigi_y_motion_input = (~luigi_y_motion) + 10'd1;
                                                end
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
                                            luigi_y_motion_input = 10'd0;
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
                            luigi_x_motion_input = luigi_x_motion;
                            at_edge_in = 1'b0;
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
                            if (luigi_x + luigi_x_size >= process_from_mario + 10'd640)
                                begin
                                    luigi_x_motion_input = 10'd0;
                                end
                            else if (luigi_x <= process_from_mario)
                                begin
                                    luigi_x_motion_input = 10'd0;
                                    at_edge_in = 1'b1;
                                end
                            if (luigi_alive == 1'd0)
                                begin
                                    NEXT_STATE = DIE;
                                    luigi_x_motion_input = 10'd0;
                                    luigi_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else
                                begin
                                    if (luigi_x_motion == 10'd0)
                                        begin
                                            NEXT_STATE = STAND_R;
                                        end
                                    else if (luigi_x_motion == 10'd1)
                                        begin
                                            NEXT_STATE = RUN_1_R;
                                        end
                                    else if (luigi_x_motion == 10'd2)
                                        begin
                                            NEXT_STATE = RUN_2_R;
                                        end
                                    else if (luigi_x_motion == 10'd3)
                                        begin
                                            NEXT_STATE = RUN_3_R;
                                        end
                                    else if (luigi_x_motion == (~10'd1) + 1'b1)
                                        begin
                                            NEXT_STATE = RUN_1_L;
                                        end
                                    else if (luigi_x_motion == (~10'd2) + 1'b1)
                                        begin
                                            NEXT_STATE = RUN_2_L;
                                        end
                                    else if (luigi_x_motion == (~10'd3) + 1'b1)
                                        begin
                                            NEXT_STATE = RUN_3_L;
                                        end
                                    else
                                        NEXT_STATE = STAND_R;
                                end
                        end

                    GLIDE_L:
                        begin
                            luigi_x_motion_input = luigi_x_motion;
                            at_edge_in = 1'b0;
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
                            if (luigi_x + luigi_x_size >= process_from_mario + 10'd640)
                                begin
                                    luigi_x_motion_input = 10'd0;
                                end
                            else if (luigi_x <= process_from_mario)
                                begin
                                    luigi_x_motion_input = 10'd0;
                                    at_edge_in = 1'b1;
                                end
                            if (luigi_alive == 1'd0)
                                begin
                                    NEXT_STATE = DIE;
                                    luigi_x_motion_input = 10'd0;
                                    luigi_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else
                                begin
                                    if (luigi_x_motion == 10'd0)
                                        begin
                                            NEXT_STATE = STAND_L;
                                        end
                                    else if (luigi_x_motion == 10'd1)
                                        begin
                                            NEXT_STATE = RUN_1_R;
                                        end
                                    else if (luigi_x_motion == 10'd2)
                                        begin
                                            NEXT_STATE = RUN_2_R;
                                        end
                                    else if (luigi_x_motion == 10'd3)
                                        begin
                                            NEXT_STATE = RUN_3_R;
                                        end
                                    else if (luigi_x_motion == (~10'd1) + 1'b1)
                                        begin
                                            NEXT_STATE = RUN_1_L;
                                        end
                                    else if (luigi_x_motion == (~10'd2) + 1'b1)
                                        begin
                                            NEXT_STATE = RUN_2_L;
                                        end
                                    else if (luigi_x_motion == (~10'd3) + 1'b1)
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
                            luigi_y_motion_input = luigi_y_motion + 1'd1;
                        end
                endcase
                
                luigi_x_pos_input = luigi_x + luigi_x_motion;
                if (luigi_x_pos_input >= luigi_x_max)
                    begin
                        luigi_x_pos_input = luigi_x_max;
                    end
                if (luigi_in_air || (STATE == DIE))
                    begin
                        luigi_y_pos_input = luigi_y + luigi_y_motion;
                        if ((STATE == DIE) && (luigi_y + luigi_y_motion >= luigi_y_max))
                            begin
                                luigi_y_pos_input = luigi_y_max;
                            end
                    end
                else
                    begin
                        luigi_y_pos_input = altitude;
                    end
               if ((luigi_x_pos_input + 10'd26 > mario_x) && (mario_x + 10'd26 > luigi_x_pos_input))
                    begin
                        if (luigi_y_pos_input == mario_y)
                            begin
                                luigi_x_pos_input = luigi_x;
                            end
                        else
                            begin
                                luigi_x_pos_input = luigi_x_pos_input;
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
                
module luigi_image (
        input Clk, Reset, frame_clk,
        input [9:0] luigi_x,
        input sl, sr, rr1, rr2, rr3, rl1, rl2, rl3, jr, jl, ir, gr, gl, di,il,
        input [23:0] luigi_sl, luigi_sr, luigi_rl1, luigi_rl2, luigi_rl3, luigi_rr1, luigi_rr2, luigi_rr3, luigi_jr, luigi_jl, luigi_die,
        output [23:0] luigi_pic_out
);
    always_ff @ (posedge Clk)
        begin
            if (sl == 1'b1)
                begin
                    luigi_pic_out = luigi_sl;
                end
            else if (sr == 1'b1)
                begin
                    luigi_pic_out = luigi_sr;
                end
            else if (rr1 == 1'b1)
                begin
                    luigi_pic_out = luigi_rr1;
                end
            else if (rr2 == 1'b1)
                begin
                    luigi_pic_out = luigi_rr2;
                end
            else if (rr3 == 1'b1)
                begin
                    luigi_pic_out = luigi_rr3;
                end
            else if (rl1 == 1'b1)
                begin
                    luigi_pic_out = luigi_rl1;
                end
            else if (rl2 == 1'b1)
                begin
                    luigi_pic_out = luigi_rl2;
                end
            else if (rl3 == 1'b1)
                begin
                    luigi_pic_out = luigi_rl3;
                end
            else if (jr == 1'b1)
                begin
                    luigi_pic_out = luigi_jr;
                end
            else if (jl == 1'b1)
                begin
                    luigi_pic_out = luigi_jl;
                end
            else if (ir == 1'b1)
                begin
                    luigi_pic_out = luigi_jr;
                end
            else if (il == 1'b1)
                begin
                    luigi_pic_out = luigi_jl;
                end
            else if (gr == 1'b1)
                begin
                    luigi_pic_out = luigi_jr;
                end
            else if (gl == 1'b1)
                begin
                    luigi_pic_out = luigi_jl;
                end
            else if (di == 1'b1)
                begin
                    luigi_pic_out = luigi_die;
                end
            else
                begin
                    luigi_pic_out = luigi_sr;
                end
            
        end
    
endmodule