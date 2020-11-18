module mario_s (
        input Reset, frame_clk, Clk,
        input [7:0] keycode,
        input [9:0] DrawX, DrawY,

        input mario_alive,

        output logic [9:0] mario_x, mario_y, process, mario_y_motion,
        output logic mario, mario_in_air,
        
        output logic [23:0] mario_pic_out
);
    logic w, s, a, d;
    always_ff @ (posedge frame_clk)
    begin
        if (keycode == 8'h04)
            begin
                a = 1'b1;
            end
        else if (keycode == 8'h07)
            begin
                d = 1'b1;
            end
        else if (keycode == 8'h16)
            begin
                s = 1'b1;
            end
        else if (keycode == 8'h1A)
            begin
                w = 1'b1;
            end
        else 
            begin
                a = 1'b0;
                s = 1'b0;
                d = 1'b0;
                w = 1'b0;
            end
    end

    mario_image m_i(.*);
    mario_movem m_m(.*);

    always_comb
    begin
        if (mario_x <= process + DrawX && DrawX + process < mario_x + 10'd32 && DrawY >= mario_y && DrawY <= mario_y + 10'd32)
            begin
                mario = 1'b1;
            end
        else
            mario = 1'b0;
    end

endmodule 

// module aj (
//         input logic [9:0] mario_x, mario_y, mario_y_motion, 
//         output logic [9:0] level,
//         output logic mario_in_air
// );
//     always_comb
//     begin
//         if (mario_y + mario_y_motion >= 10'd384)
//             begin
//                 mario_in_air = 1'b0;
//                 level = 10'd384;
//             end
//         else
//             begin
//                 mario_in_air = 1'b1;
//                 level = 10'd384;
//             end
//     end
// endmodule

module mario_movem (
        input Clk, Reset, frame_clk,
        input w, s, a, d,
        input mario_alive,
        
        output logic [9:0] mario_x, mario_y, process, mario_y_motion,
        output logic mario_in_air
);

    parameter [9:0] mario_x_ori = 20;
    parameter [9:0] mario_y_ori = 400;

    parameter [9:0] mario_x_min = 0;
    parameter [9:0] mario_x_max = 639;
    parameter [9:0] mario_y_min = 0;
    parameter [9:0] mario_y_max = 479;
    parameter [9:0] mario_x_step = 2;

    parameter [9:0] mario_x_size = 32;

    logic [9:0] mario_x_motion, level;
    logic [9:0] mario_x_pos_input, mario_x_motion_input, mario_y_pos_input, mario_y_motion_input;
    logic [9:0] process_input;

    logic [23:0] mario_counter, mario_counter_in;
    logic flag, flag_in;

    // aj ajj(.mario_x(mario_x), .mario_y(mario_y), .mario_y_motion(mario_y_motion), .level(level), .mario_in_air(mario_in_air));

    always_comb
    begin
        if (mario_y + mario_y_motion >= 10'd384)
            begin
                mario_in_air = 1'b0;
                level = 10'd384;
            end
        else
            begin
                mario_in_air = 1'b1;
                level = 10'd384;
            end
    end

    enum logic [3:0] {STAND, 
                      RUN, 
                      RUN_1_R, 
                      RUN_2_R, 
                      RUN_3_R,
					  RUN_1_L, 
                      RUN_2_L, 
                      RUN_3_L, 
                      JUMP, 
                      IN_AIR, 
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
                mario_x <= 10'd80;
                mario_y <= 10'd384;
                mario_x_motion <= 10'd0;
                mario_y_motion <= 10'd0;
                process <= 10'd0;
                STATE <= STAND;
                mario_counter <= 24'b0;
                flag <= 1'b0;
            end
        else
            begin
                mario_x <= mario_x_pos_input;
                mario_y <= mario_y_pos_input;
                mario_x_motion <= mario_x_motion_input;
                mario_y_motion <= mario_y_motion_input;
                process <= process_input;
                STATE <= NEXT_STATE;
                mario_counter <= mario_counter_in;
                flag <= flag_in;
            end
    end

    always_comb
    begin
        mario_x_pos_input = mario_x;
        mario_y_pos_input = mario_y;
        mario_x_motion_input = mario_x_motion;
        mario_y_motion_input = mario_y_motion;
        process_input = process;
        NEXT_STATE = STATE;
        flag_in = flag;
        mario_counter_in = mario_counter;

        if (frame_clk_rising_edge)
            begin
                unique case (STATE)
                    STAND:
                        begin
                            mario_x_motion_input = 10'd0;
                            mario_y_motion_input = 10'd0;
                            mario_counter_in = 24'b0;
                            if (mario_alive == 1'b0)
                                begin
                                    NEXT_STATE = DIE;
                                    mario_x_motion_input = 10'd0;
                                    mario_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else if (w && ~flag)
                                begin
                                    NEXT_STATE = JUMP;
                                    flag_in = 1'b1;
                                end
                            else if (a)
                                begin
                                    NEXT_STATE = RUN_1_L;
                                    flag_in = 1'b0;
                                end
                            else if (d)
                                begin
                                    NEXT_STATE = RUN_1_R;
                                    flag_in = 1'b0;
                                end
                            else if (~w)
                                begin
                                    NEXT_STATE = STAND;
                                    flag_in = 1'b0;
                                end
                            else
                                begin
                                    NEXT_STATE = STAND;
                                    flag_in = flag;
                                end
                        end
                    
                    RUN_1_R:
                        begin
                            mario_x_motion_input = 10'd1;
                            mario_y_motion_input = 10'd0;
                            flag_in = flag;
                            mario_counter_in = 24'b0;
                            if (mario_x + mario_x_size >= mario_x_max)
                                begin
                                    mario_x_motion_input = 10'd0;
                                end
                            if (~w)
                                begin
                                    flag_in = 1'b0;
                                end
                            if (mario_alive == 1'd0)
                                begin
                                    NEXT_STATE = DIE;
                                    mario_x_motion_input = 10'd0;
                                    mario_y_motion_input = ~(9'd15) + 1'd1;
                                end
                            else if (w && ~flag)
                                begin
                                    NEXT_STATE = JUMP;
                                    flag_in = 1'b1;
                                end
                            else if (d && mario_counter[3])
                                begin
                                    NEXT_STATE = RUN_2_R;
                                end
                            else if (d && ~mario_counter[3])
                                begin
                                    NEXT_STATE = RUN_1_R;
                                    mario_counter_in = mario_counter + 1'd1;
                                end
                            else 
                                begin
                                    NEXT_STATE = STAND;
                                end
                        end

                    RUN_2_R:
                        begin
                            mario_x_motion_input = 10'd2;
                            mario_y_motion_input = 10'd0;
                            flag_in = flag;
                            mario_counter_in = 24'b0;
                            if (mario_x + mario_x_size >= mario_x_max)
                                begin
                                    mario_x_motion_input = 10'd0;
                                end
                            if (~w)
                                begin
                                    flag_in = 1'b0;
                                end
                            if (mario_alive == 1'd0)
                                begin
                                    NEXT_STATE = DIE;
                                    mario_x_motion_input = 10'd0;
                                    mario_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else if (w && ~flag)
                                begin
                                    NEXT_STATE = JUMP;
                                    flag_in = 1'b1;
                                end
                            else if (d && mario_counter[3])
                                begin
                                    NEXT_STATE = RUN_3_R;
                                end
                            else if (d && ~mario_counter[3])
                                begin
                                    NEXT_STATE = RUN_2_R;
                                    mario_counter_in = mario_counter + 1'd1;
                                end
                            else 
                                begin
                                    NEXT_STATE = STAND;
                                end
                        end

                    RUN_3_R:
                        begin
                            mario_x_motion_input = 10'd3;
                            mario_y_motion_input = 10'd0;
                            flag_in = flag;
                            mario_counter_in = 24'b0;
                            if (mario_x + mario_x_size >= mario_x_max)
                                begin
                                    mario_x_motion_input = 10'd0;
                                end
                            if (~w)
                                begin
                                    flag_in = 1'b0;
                                end
                            if (mario_alive == 1'd0)
                                begin
                                    NEXT_STATE = DIE;
                                    mario_x_motion_input = 10'd0;
                                    mario_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else if (w && ~flag)
                                begin
                                    NEXT_STATE = JUMP;
                                    flag_in = 1'b1;
                                end
                            else if (d)
                                begin
                                    NEXT_STATE = RUN_3_R;
                                end
                            else 
                                begin
                                    NEXT_STATE = RUN_1_R;
                                end
                        end

                    RUN_1_L:
                        begin
                            mario_x_motion_input = (~10'd1) + 1'b1;
                            mario_y_motion_input = 10'd0;
                            flag_in = flag;
                            mario_counter_in = 24'b0;
                            if (mario_x + mario_x_motion <= 10'd1)
                                begin
                                    mario_x_motion_input = 10'd0;
                                end
                            if (~w)
                                begin
                                    flag_in = 1'b0;
                                end
                            if (mario_alive == 1'd0)
                                begin
                                    NEXT_STATE = DIE;
                                    mario_x_motion_input = 10'd0;
                                    mario_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else if (w && ~flag)
                                begin
                                    NEXT_STATE = JUMP;
                                    flag_in = 1'b1;
                                end
                            else if (a && mario_counter[3])
                                begin
                                    NEXT_STATE = RUN_2_L;
                                end
                            else if (a && ~mario_counter[3])
                                begin
                                    NEXT_STATE = RUN_1_L;
                                    mario_counter_in = mario_counter + 1'd1;
                                end
                            else 
                                begin
                                    NEXT_STATE = STAND;
                                end
                        end
                    
                    RUN_2_L:
                        begin
                            mario_x_motion_input = (~10'd2) + 1'b1;
                            mario_y_motion_input = 10'd0;
                            flag_in = flag;
                            mario_counter_in = 24'b0;
                            if (mario_x + mario_x_motion <= 10'd1)
                                begin
                                    mario_x_motion_input = 10'd0;
                                end
                            if (~w)
                                begin
                                    flag_in = 1'b0;
                                end
                            if (mario_alive == 1'd0)
                                begin
                                    NEXT_STATE = DIE;
                                    mario_x_motion_input = 10'd0;
                                    mario_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else if (w && ~flag)
                                begin
                                    NEXT_STATE = JUMP;
                                    flag_in = 1'b1;
                                end
                            else if (a && mario_counter[3])
                                begin
                                    NEXT_STATE = RUN_3_L;
                                end
                            else if (a && ~mario_counter[3])
                                begin
                                    NEXT_STATE = RUN_1_L;
                                    mario_counter_in = mario_counter + 1'd1;
                                end
                            else 
                                begin
                                    NEXT_STATE = STAND;
                                end
                        end
                    
                    RUN_3_L:
                        begin
                            mario_x_motion_input = (~10'd3) + 1'b1;
                            mario_y_motion_input = 10'd0;
                            flag_in = flag;
                            mario_counter_in = 24'b0;
                            if (mario_x + mario_x_motion <= 10'd1)
                                begin
                                    mario_x_motion_input = 10'd0;
                                end
                            if (~w)
                                begin
                                    flag_in = 1'b0;
                                end
                            if (mario_alive == 1'd0)
                                begin
                                    NEXT_STATE = DIE;
                                    mario_x_motion_input = 10'd0;
                                    mario_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else if (w && ~flag)
                                begin
                                    NEXT_STATE = JUMP;
                                    flag_in = 1'b1;
                                end
                            else if (a)
                                begin
                                    NEXT_STATE = RUN_3_L;
                                end
                            else 
                                begin
                                    NEXT_STATE = RUN_1_L;
                                end
                        end
                    
                    JUMP:
                        begin
                            mario_x_motion_input = mario_x_motion;
                            mario_y_motion_input = (~10'd15) + 1'd1;
                            flag_in = 1'b1;
                            NEXT_STATE = IN_AIR;
                        end
                    
                    IN_AIR:
                        begin
                            mario_x_motion_input = mario_x_motion;
                            flag_in = 1'b1;
                            if (mario_alive == 1'b0)
                                begin
                                    NEXT_STATE = DIE;
                                    mario_x_motion_input = 10'd0;
                                    mario_y_motion_input = ~(10'd15) + 1'd1;
                                end
                            else
                                begin
                                    if (mario_in_air)
                                        begin
                                            NEXT_STATE = IN_AIR;
                                            mario_y_motion_input = mario_y_motion + 1'd1;
                                            if (mario_y + mario_y_motion < 10'd5)
                                                begin
                                                    mario_y_motion_input = (~mario_y_motion) + 10'd1;
                                                end
                                        end
                                    else
                                        begin
                                            NEXT_STATE = STAND;
                                            mario_y_motion_input = 10'd0;
                                            if (w)
                                                begin
                                                    flag_in = 1'b1;
                                                end
                                            else
                                                begin
                                                    flag_in = 1'b0;
                                                end
                                        end
                                end
                        end
                    
                    DIE:
                        begin
                            NEXT_STATE = DIE;
                            mario_y_motion_input = mario_y_motion + 1'd1;
                        end
                    default: ;
                endcase
                
                mario_x_pos_input = mario_x + mario_x_motion;
                if (mario_in_air || (STATE == DIE))
                    begin
                        mario_y_pos_input = mario_y + mario_y_motion;
                        if ((STATE == DIE) && (mario_y + mario_y_motion >= mario_y_max))
                            begin
                                mario_y_pos_input = mario_y_max;
                            end
                    end
                else
                    begin
                        mario_y_pos_input = level;
                    end
            end
    end
endmodule
                
module mario_image (
        input Clk, Reset, frame_clk,
        input logic w, s, a, d,
        input logic [9:0] mario_x,
        output [23:0] mario_pic_out
);

    assign mario_pic_out = 24'hff5500;
endmodule