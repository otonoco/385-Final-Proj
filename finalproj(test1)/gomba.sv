module gomba #(parameter gomba_x_min = 10'd0;
               parameter gomba_x_max = 10'd1023;
               parameter gomba_x_ori = 10'd400)
        (
        input Reset, frame_clk, Clk,
        input [9:0] DrawX, DrawY,  
        input [9:0] mario_x,
        input [9:0] luigi_x,
        input [9:0] process,
        input gomba_alive,
        input mario_alive, luigi_alive,
        input [23:0] gomba_left, gomba_right, gomba_deadp,
        
        output logic gomba,
        output logic [9:0] gomba_x, gomba_y,
        output logic [23:0] gomba_pic_out
);
    
    logic left_foot1, left_foot2, right_foot1, right_foot2, dead, disappear;
    // gomba_image g_i(.*);
    gomba_movem #(gomba_x_min, gomba_x_max, gomba_x_ori) g_m(.*);

    always_ff @ (posedge Clk)
        begin
            if (left_foot1 || right_foot1)
                begin
                    gomba_pic_out = gomba_left;
                end
            else if (left_foot2 || right_foot2)
                begin
                    gomba_pic_out = gomba_right;
                end
            else if (dead && (~disappear))
                begin
                    gomba_pic_out = gomba_deadp;
                end
            else if (dead && disappear)
                begin
                    gomba_pic_out = 24'h6b8cff;
                end
            else
                begin
                    gomba_pic_out = gomba_left;
                end
        end

    always_comb
    begin
        if (gomba_x < process + DrawX && DrawX + process < gomba_x + 10'd32 && DrawY > gomba_y && DrawY < gomba_y + 10'd32)
            begin
                gomba = 1'b1;
            end
        else
            gomba = 1'b0;
    end
endmodule 


module gomba_movem #(parameter gomba_x_min = 10'd0;
                     parameter gomba_x_max = 10'd1023;
                     parameter gomba_x_ori = 10'd400)
        (
        input Reset, frame_clk, Clk, gomba_alive, mario_alive, luigi_alive,
        input [9:0] mario_x,
        input [9:0] luigi_x,
        input [9:0] process,
        output logic [9:0] gomba_x, gomba_y,
        output logic left_foot1, left_foot2, right_foot1, right_foot2, dead, disappear
);
    parameter [9:0] x_ori = gomba_x_ori;
    parameter [9:0] y_ori = 384;
    parameter [9:0] x_min = gomba_x_min;
    parameter [9:0] x_max = gomba_x_max;
    parameter [9:0] y_min = 0;
    parameter [9:0] y_max = 479;
    parameter [9:0] x_step = 2;
    parameter [9:0] x_size = 32;

    logic [9:0] x_motion, y_motion, x_motion_input, y_motion_input, gomba_x_pos_input, gomba_y_pos_input;
    logic lf1_in, rf1_in, dd_in, lf2_in, rf2_in, dis_in;
    logic [23:0] gomba_counter, gomba_counter_in;
    logic [23:0] counter2, counter2_in;
    logic mario_at_left, mario_at_right;
    logic [9:0] mario_dis, luigi_dis;

    enum logic [3:0] {LEFT_1,
                      LEFT_2,
                      RIGHT_1,
                      RIGHT_2,
                      DIE,
                      DISAPPEAR} STATE, NEXT_STATE;
    
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
                gomba_x <= x_ori;
                gomba_y <= y_ori;
                x_motion <= 10'd0;
                y_motion <= 10'd0;
                left_foot1 <= 1'b1;
                left_foot2 <= 1'b0;
                right_foot1 <= 1'b0;
                right_foot2 <= 1'b0;
                dead <= 1'b0;
                disappear <= 1'b0;
                STATE <= LEFT_1;
                gomba_counter <= 24'd0;
                counter2 <= 24'b0;
            end
        else if (disappear)
            begin
                gomba_x <= 10'd0;
                gomba_y <= 10'd0;
                x_motion <= 10'd0;
                y_motion <= 10'd0;
				gomba_counter <= 24'd0;
            end
        else
            begin
                gomba_x <= gomba_x_pos_input;
                gomba_y <= gomba_y_pos_input;
                x_motion <= x_motion_input;
                y_motion <= y_motion_input;
                STATE <= NEXT_STATE;
                gomba_counter <= gomba_counter_in;
                counter2 <= counter2_in;
                left_foot1 <= lf1_in;
                left_foot2 <= lf2_in;
                right_foot1 <= rf1_in;
                right_foot2 <= rf2_in;
                dead <= dd_in;
                disappear <= dis_in;
            end
    end

    always_comb
    begin
        if (mario_x < gomba_x)
            begin
                mario_dis = gomba_x - mario_x;
            end
        else
            begin
                mario_dis = mario_x - gomba_x;
            end
    end

    always_comb
    begin
        if (luigi_x < gomba_x)
            begin
                luigi_dis = gomba_x - luigi_x;
            end
        else
            begin
                luigi_dis = luigi_x - gomba_x;
            end
    end

    always_comb
    begin
        if (mario_alive && luigi_alive)
            begin
                if (mario_dis <= luigi_dis)
                    begin
                        if (mario_x < gomba_x)
                            begin
                                mario_at_left = 1'b1;
                                mario_at_right = 1'b0;
                            end
                        else
                            begin
                                mario_at_left = 1'b0;
                                mario_at_right = 1'b1;
                            end
                    end
                else
                    begin
                        if (luigi_x < gomba_x)
                            begin
                                mario_at_left = 1'b1;
                                mario_at_right = 1'b0;
                            end
                        else
                            begin
                                mario_at_left = 1'b0;
                                mario_at_right = 1'b1;
                            end
                    end
            end
        else if (mario_alive)
            begin
                if (mario_x < gomba_x)
                    begin
                        mario_at_left = 1'b1;
                        mario_at_right = 1'b0;
                    end
                else
                    begin
                        mario_at_left = 1'b0;
                        mario_at_right = 1'b1;
                    end
            end
        else if (luigi_alive)
            begin
                if (luigi_x < gomba_x)
                    begin
                        mario_at_left = 1'b1;
                        mario_at_right = 1'b0;
                    end
                else
                    begin
                        mario_at_left = 1'b0;
                        mario_at_right = 1'b1;
                    end
            end
        else
            begin
                mario_at_right = 1'b1;
                mario_at_left = 1'b0;
            end
    end

    always_comb
    begin
        gomba_x_pos_input = gomba_x;
        gomba_y_pos_input = gomba_y;
        x_motion_input = x_motion;
        y_motion_input = y_motion;
        NEXT_STATE = STATE;
        gomba_counter_in = gomba_counter;
        counter2_in = counter2;
        if (frame_clk_rising_edge)
            begin
                unique case (STATE)
                    default:
                        begin
                            lf1_in = 1'b0;
                            lf2_in = 1'b0;
                            rf1_in = 1'b0;
                            rf2_in = 1'b0;
                            dd_in = 1'b0;
                            dis_in = 1'b0;
                        end

                    LEFT_1:
                        begin
                            lf1_in = 1'b1;
                            lf2_in = 1'b0;
                            rf1_in = 1'b0;
                            rf2_in = 1'b0;
                            dd_in = 1'b0;
                            dis_in = 1'b0;

                            if (gomba_alive == 1'b0)
                                begin
                                    NEXT_STATE = DIE;
                                    x_motion_input = 10'd0;
                                    y_motion_input = 10'd0;
                                    counter2_in = 24'b0;
                                    gomba_counter_in = 24'b0;
                                end
                            else if (gomba_x <= process)
                                begin
                                    x_motion_input = x_step;
                                    y_motion_input = 10'd0;
                                    NEXT_STATE = RIGHT_2;
                                end
                            else if (gomba_x + x_size >= x_max)
                                begin
                                    x_motion_input = ~(10'd1) + 10'd1;
                                    y_motion_input = 10'd0;
                                    NEXT_STATE = LEFT_2;
                                end
                            else if (mario_at_left && gomba_counter[1])
                                begin
                                    x_motion_input = ~(10'd1) + 10'd1;
                                    y_motion_input = 10'd0;
                                    NEXT_STATE = LEFT_2;
                                    gomba_counter_in = 24'b0;
                                end
                            else if (mario_at_left && ~gomba_counter[1])
                                begin
                                    NEXT_STATE = LEFT_1;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            gomba_counter_in = gomba_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            gomba_counter_in = gomba_counter;
                                            counter2_in = counter2 + 24'b1;
                                        end
                                end
                            else if (mario_at_right && gomba_counter[1])
                                begin
                                    x_motion_input = 10'd1;
                                    y_motion_input = 10'd0;
                                    NEXT_STATE = RIGHT_2;
                                    counter2_in = 24'b0;
                                    gomba_counter_in = 24'b0;
                                end
                            else if (mario_at_right && ~gomba_counter[1])
                                begin
                                    NEXT_STATE = LEFT_1;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            gomba_counter_in = gomba_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            gomba_counter_in = gomba_counter;
                                            counter2_in = counter2 + 24'b1;
                                        end
                                end
                            else
                                begin
                                    x_motion_input = ~(10'd1) + 10'd1;
                                    y_motion_input = 10'd0;
                                    NEXT_STATE = LEFT_2;
                                end

                            // kong qi qiang
                            if (gomba_x + x_motion_input + 10'd32 > 10'd102 && gomba_x + x_motion_input < 10'd98 + 10'd64 && gomba_y > 10'd320 && x_motion_input[9])
                                begin
                                    x_motion_input = 10'd1;
                                    NEXT_STATE = RIGHT_2;
                                end
                            if (gomba_x + x_motion_input + 10'd32 > 10'd642 && gomba_x + x_motion_input < 10'd638 + 10'd64 && gomba_y > 10'd320 && x_motion_input[9])
                                begin
                                    x_motion_input = 10'd1;
                                    NEXT_STATE = RIGHT_2;
                                end
                        end

                    LEFT_2:
                        begin
                            lf1_in = 1'b0;
                            lf2_in = 1'b1;
                            rf1_in = 1'b0;
                            rf2_in = 1'b0;
                            dd_in = 1'b0;
                            dis_in = 1'b0;
                            if (gomba_alive == 1'b0)
                                begin
                                    NEXT_STATE = DIE;
                                    x_motion_input = 10'd0;
                                    y_motion_input = 10'd0;
                                    counter2_in = 24'b0;
                                    gomba_counter_in = 24'b0;
                                end
                            else if (gomba_x <= process)
                                begin
                                    x_motion_input = x_step;
                                    y_motion_input = 10'd0;
                                    NEXT_STATE = RIGHT_1;
                                end
                            else if (gomba_x + x_size >= x_max)
                                begin
                                    x_motion_input = ~(10'd1) + 10'd1;
                                    y_motion_input = 10'd0;
                                    NEXT_STATE = LEFT_1;
                                end
                            else if (mario_at_left && gomba_counter[1])
                                begin
                                    x_motion_input = ~(10'd1) + 10'd1;
                                    y_motion_input = 10'd0;
                                    NEXT_STATE = LEFT_1;
                                    gomba_counter_in = 24'b0;
                                end
                            else if (mario_at_left && ~gomba_counter[1])
                                begin
                                    NEXT_STATE = LEFT_2;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            gomba_counter_in = gomba_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            gomba_counter_in = gomba_counter;
                                            counter2_in = counter2 + 24'b1;
                                        end
                                end
                            else if (mario_at_right && gomba_counter[1])
                                begin
                                    x_motion_input = 10'd1;
                                    y_motion_input = 10'd0;
                                    NEXT_STATE = RIGHT_1;
                                    gomba_counter_in = 24'b0;
                                end
                            else if (mario_at_right && ~gomba_counter[1])
                                begin
                                    NEXT_STATE = LEFT_2;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            gomba_counter_in = gomba_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            gomba_counter_in = gomba_counter;
                                            counter2_in = counter2 + 24'b1;
                                        end
                                end
                            else
                                begin
                                    x_motion_input = ~(10'd1) + 10'd1;
                                    y_motion_input = 10'd0;
                                    NEXT_STATE = LEFT_1;
                                end
                            // kong qi qiang
                            if (gomba_x + x_motion_input + 10'd32 > 10'd102 && gomba_x + x_motion_input < 10'd98 + 10'd64 && gomba_y > 10'd320 && x_motion_input[9])
                                begin
                                    x_motion_input = 10'd1;
                                    NEXT_STATE = RIGHT_1;
                                end
                            if (gomba_x + x_motion_input + 10'd32 > 10'd642 && gomba_x + x_motion_input < 10'd638 + 10'd64 && gomba_y > 10'd320 && x_motion_input[9])
                                begin
                                    x_motion_input = 10'd1;
                                    NEXT_STATE = RIGHT_1;
                                end
                        end

                    RIGHT_1:
                        begin
                            lf1_in = 1'b0;
                            lf2_in = 1'b0;
                            rf1_in = 1'b1;
                            rf2_in = 1'b0;
                            dd_in = 1'b0;
                            dis_in = 1'b0;
                            if (gomba_alive == 1'b0)
                                begin
                                    NEXT_STATE = DIE;
                                    x_motion_input = 10'd0;
                                    y_motion_input = 10'd0;
                                    counter2_in = 24'b0;
                                    gomba_counter_in = 24'b0;
                                end
                            else if (gomba_x <= process)
                                begin
                                    x_motion_input = x_step;
                                    y_motion_input = 10'd0;
                                    NEXT_STATE = RIGHT_2;
                                end
                            else if (gomba_x + x_size >= x_max)
                                begin
                                    x_motion_input = ~(10'd1) + 10'd1;
                                    y_motion_input = 10'd0;
                                    NEXT_STATE = LEFT_2;
                                end
                            else if (mario_at_left && gomba_counter[1])
                                begin
                                    x_motion_input = ~(10'd1) + 10'd1;
                                    y_motion_input = 10'd0;
                                    NEXT_STATE = LEFT_2;
                                    gomba_counter_in = 24'b0;
                                end
                            else if (mario_at_left && ~gomba_counter[1])
                                begin
                                    NEXT_STATE = RIGHT_1;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            gomba_counter_in = gomba_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            gomba_counter_in = gomba_counter;
                                            counter2_in = counter2 + 24'b1;
                                        end
                                end
                            else if (mario_at_right && gomba_counter[1])
                                begin
                                    x_motion_input = 10'd1;
                                    y_motion_input = 10'd0;
                                    NEXT_STATE = RIGHT_2;
                                    gomba_counter_in = 24'b0;
                                end
                            else if (mario_at_right && ~gomba_counter[1])
                                begin
                                    NEXT_STATE = RIGHT_1;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            gomba_counter_in = gomba_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            gomba_counter_in = gomba_counter;
                                            counter2_in = counter2 + 24'b1;
                                        end
                                end
                            else
                                begin
                                    x_motion_input = 10'd1;
                                    y_motion_input = 10'd0;
                                    NEXT_STATE = RIGHT_2;
                                end
                            // kong qi qiang
                            if (gomba_x + x_motion_input + 10'd32 > 10'd102 && gomba_x + x_motion_input < 10'd98 + 10'd64 && gomba_y > 10'd320 && ~x_motion_input[9])
                                begin
                                    x_motion_input = ~(10'd1) + 10'd1;
                                    NEXT_STATE = LEFT_2;
                                end
                            if (gomba_x + x_motion_input + 10'd32 > 10'd642 && gomba_x + x_motion_input < 10'd638 + 10'd64 && gomba_y > 10'd320 && ~x_motion_input[9])
                                begin
                                    x_motion_input = ~(10'd1) + 10'd1;
                                    NEXT_STATE = LEFT_2;
                                end
                        end
                        
                    RIGHT_2:
                        begin
                            lf1_in = 1'b0;
                            lf2_in = 1'b0;
                            rf1_in = 1'b0;
                            rf2_in = 1'b1;
                            dd_in = 1'b0;
                            dis_in = 1'b0;
                            if (gomba_alive == 1'b0)
                                begin
                                    NEXT_STATE = DIE;
                                    x_motion_input = 10'd0;
                                    y_motion_input = 10'd0;
                                    counter2_in = 24'b0;
                                    gomba_counter_in = 24'b0;
                                end
                            else if (gomba_x <= process)
                                begin
                                    x_motion_input = x_step;
                                    y_motion_input = 10'd0;
                                    NEXT_STATE = RIGHT_1;
                                end
                            else if (gomba_x + x_size >= x_max)
                                begin
                                    x_motion_input = ~(10'd1) + 10'd1;
                                    y_motion_input = 10'd0;
                                    NEXT_STATE = LEFT_1;
                                end
                            else if (mario_at_left && gomba_counter[1])
                                begin
                                    x_motion_input = ~(10'd1) + 10'd1;
                                    y_motion_input = 10'd0;
                                    NEXT_STATE = LEFT_1;
                                    gomba_counter_in = 24'b0;
                                end
                            else if (mario_at_left && ~gomba_counter[1])
                                begin
                                    NEXT_STATE = RIGHT_2;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            gomba_counter_in = gomba_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            gomba_counter_in = gomba_counter;
                                            counter2_in = counter2 + 24'b1;
                                        end
                                end
                            else if (mario_at_right && gomba_counter[1])
                                begin
                                    x_motion_input = 10'd1;
                                    y_motion_input = 10'd0;
                                    NEXT_STATE = RIGHT_1;
                                    gomba_counter_in = 24'b0;
                                end
                            else if (mario_at_right && ~gomba_counter[1])
                                begin
                                    NEXT_STATE = RIGHT_2;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            gomba_counter_in = gomba_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            gomba_counter_in = gomba_counter;
                                            counter2_in = counter2 + 24'b1;
                                        end
                                end
                            else
                                begin
                                    x_motion_input = 10'd1;
                                    y_motion_input = 10'd0;
                                    NEXT_STATE = RIGHT_1;
                                end
                            // kong qi qiang
                            if (gomba_x + x_motion_input + 10'd32 > 10'd102 && gomba_x + x_motion_input < 10'd98 + 10'd64 && gomba_y > 10'd320 && ~x_motion_input[9])
                                begin
                                    x_motion_input = ~(10'd1) + 10'd1;
                                    NEXT_STATE = LEFT_1;
                                end
                            if (gomba_x + x_motion_input + 10'd32 > 10'd642 && gomba_x + x_motion_input < 10'd638 + 10'd64 && gomba_y > 10'd320 && ~x_motion_input[9])
                                begin
                                    x_motion_input = ~(10'd1) + 10'd1;
                                    NEXT_STATE = LEFT_1;
                                end
                        end

                    DIE:
                        begin
                            lf1_in = 1'b0;
                            lf2_in = 1'b0;
                            rf1_in = 1'b0;
                            rf2_in = 1'b0;
                            dd_in = 1'b1;
                            dis_in = 1'b0;
                            if (gomba_counter[1])
                                begin
                                    NEXT_STATE = DISAPPEAR;
                                end
                            else
                                begin
                                    NEXT_STATE = DIE;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            gomba_counter_in = gomba_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            gomba_counter_in = gomba_counter;
                                            counter2_in = counter2 + 24'b1;
                                        end
                                end
                            y_motion_input = y_motion;
                        end

                    DISAPPEAR:
                        begin
                            lf1_in = 1'b0;
                            lf2_in = 1'b0;
                            rf1_in = 1'b0;
                            rf2_in = 1'b0;
                            dd_in = 1'b1;
                            dis_in = 1'b1;
                            NEXT_STATE = DISAPPEAR;
                        end

                endcase
                gomba_x_pos_input = gomba_x + x_motion;
                gomba_y_pos_input = gomba_y + y_motion;
                if (gomba_x_pos_input >= gomba_x_max)
                    begin
                        gomba_x_pos_input = gomba_x_max;
                    end
                    
            end
        else 
            begin
                lf1_in = left_foot1;
                lf2_in = left_foot2;
                rf1_in = right_foot1;
                rf2_in = right_foot2;
                dd_in = dead;
				dis_in = disappear;
            end
    end
endmodule

// module gomba_image(
//         input Clk, Reset, frame_clk,
//         input left_foot1, left_foot2, right_foot1, right_foot2, dead, disappear,
//         input [9:0] gomba_x,
//         input [23:0] gomba_left, gomba_right,gomba_deadp,
//         output [23:0] gomba_pic_out
// );
//     always_ff @ (posedge Clk)
//         begin
//             if (left_foot1 || right_foot1)
//                 begin
//                     gomba_pic_out = gomba_left;
//                 end
//             else if (left_foot2 || right_foot2)
//                 begin
//                     gomba_pic_out = gomba_right;
//                 end
//             else if (dead && (~disappear))
//                 begin
//                     gomba_pic_out = gomba_deadp;
//                 end
//             else if (dead && disappear)
//                 begin
//                     gomba_pic_out = 24'h6b8cff;
//                 end
//             else
//                 begin
//                     gomba_pic_out = gomba_left;
//                 end
//         end
// endmodule