module coin #(parameter coin_x_min = 10'd0;
              parameter coin_x_max = 10'd639;
              parameter coin_x_ori = 10'd400)
        (
        input Reset, frame_clk, Clk,
        input [9:0] DrawX, DrawY,  
        input [9:0] process,
        input coin_alive,
        input [23:0] front, side, back,
        
        output logic coin,
        output logic [9:0] coin_x, coin_y,
        output logic [23:0] coin_pic_out
);
    logic [9:0] x_min_, x_max_, x_ori_;
    assign x_min_ = coin_x_min;
    assign x_max_ = coin_x_max;
    assign x_ori_ = coin_x_ori;
    logic zhengmian, cemian, beimian, eaten;

    coin_image c_i(.*);
    coin_movem c_m(.*);

    always_comb
    begin
        if (coin_x < process + DrawX && DrawX + process < coin_x + 10'd16 && DrawY > coin_y && DrawY < coin_y + 10'd28)
            begin
                coin = 1'b1;
            end
        else
            coin = 1'b0;
    end
endmodule 

module coin_movem (
        input Reset, frame_clk, Clk, coin_alive,
        input [9:0] x_min_, x_max_, x_ori_,
        output logic [9:0] coin_x, coin_y,
        output logic zhengmian, cemian, beimian, eaten
);  
logic [9:0] x_ori, x_min, x_max;
    assign x_ori = x_ori_;
    assign x_min = x_min_;
    assign x_max = x_max_;
    parameter [9:0] y_ori = 300;
    parameter [9:0] y_min = 0;
    parameter [9:0] y_max = 479;

    parameter [9:0] x_size = 16;

    logic zhengmian_in, cemian_in, beimian_in, eaten_in;
    logic [23:0] coin_counter, coin_counter_in;
    logic [23:0] counter2, counter2_in;

    enum logic [1:0] {ZHENG,
                CE,
                FAN,
                EAT} STATE, NEXT_STATE;

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
                coin_x <= x_ori;
                coin_y <= y_ori;
                zhengmian <= 1'b1;
                cemian <= 1'b0;
                beimian <= 1'b0;
                eaten <= 1'b0;
                STATE <= ZHENG;
                coin_counter <= 24'd0;
                counter2 <= 24'd0;
            end
        else if (eaten)
            begin
                coin_x <= 10'd0;
                coin_y <= 10'd0;
                coin_counter <= 24'd0;
            end
        else
            begin
                STATE <= NEXT_STATE;
                coin_counter <= coin_counter_in;
                counter2 <= counter2_in;
                zhengmian <= zhengmian_in;
                cemian <= cemian_in;
                beimian <= beimian_in;
                eaten <= eaten_in;
            end
    end

    always_comb
    begin
        NEXT_STATE = STATE;
        coin_counter_in = coin_counter;
        counter2_in = counter2;

        if (frame_clk_rising_edge)
            begin
                unique case (STATE)
                    default:
                        begin
                            zhengmian_in = 1'b0;
                            cemian_in = 1'b0;
                            beimian_in = 1'b0;
                            eaten_in = 1'b0;
                        end
                    ZHENG:
                        begin
                            zhengmian_in = 1'b1;
                            cemian_in = 1'b0;
                            beimian_in = 1'b0;
                            eaten_in = 1'b0;
                            if (coin_alive == 1'b0)
                                begin
                                    NEXT_STATE = EAT;
                                    coin_counter_in = 24'd0;
                                    counter2_in = 24'd0;
                                end
                            else if (coin_counter[1])
                                begin
                                    NEXT_STATE = CE;
                                    coin_counter_in = 24'd0;
                                end
                            else
                                begin
                                    NEXT_STATE = ZHENG;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            coin_counter_in = coin_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            coin_counter_in = coin_counter;
                                            counter2_in = counter2 + 24'b1;
                                        end
                                end
                        end

                    CE:
                        begin
                            zhengmian_in = 1'b0;
                            cemian_in = 1'b1;
                            beimian_in = 1'b0;
                            eaten_in = 1'b0;
                            if (coin_alive == 1'b0)
                                begin
                                    NEXT_STATE = EAT;
                                    coin_counter_in = 24'd0;
                                    counter2_in = 24'd0;
                                end
                            else if (coin_counter[1])
                                begin
                                    NEXT_STATE = FAN;
                                    coin_counter_in = 24'd0;
                                end
                            else
                                begin
                                    NEXT_STATE = CE;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            coin_counter_in = coin_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            coin_counter_in = coin_counter;
                                            counter2_in = counter2 + 24'b1;
                                        end
                                end
                        end
                    
                    FAN:
                        begin
                            zhengmian_in = 1'b0;
                            cemian_in = 1'b0;
                            beimian_in = 1'b1;
                            eaten_in = 1'b0;
                            if (coin_alive == 1'b0)
                                begin
                                    NEXT_STATE = EAT;
                                    coin_counter_in = 24'd0;
                                    counter2_in = 24'd0;
                                end
                            else if (coin_counter[1])
                                begin
                                    NEXT_STATE = ZHENG;
                                    coin_counter_in = 24'd0;
                                end
                            else
                                begin
                                    NEXT_STATE = FAN;
                                    if (counter2[0] == 1'b1)
                                        begin
                                            coin_counter_in = coin_counter + 24'b1;
                                            counter2_in = 24'b0;
                                        end
                                    else 
                                        begin
                                            coin_counter_in = coin_counter;
                                            counter2_in = counter2 + 24'b1;
                                        end
                                end
                        end
                    
                    EAT:
                        begin
                            zhengmian_in = 1'b0;
                            cemian_in = 1'b0;
                            beimian_in = 1'b0;
                            eaten_in = 1'b1;
                            NEXT_STATE = EAT;
                        end
					endcase
            end
        else
            begin
                zhengmian_in = zhengmian;
                cemian_in = cemian;
                beimian_in = beimian;
                eaten_in = eaten;
            end
    end
endmodule

module coin_image (
        input logic Clk, Reset, frame_clk,
        input logic  zhengmian, cemian, beimian, eaten,
        input [23:0] front, side, back,
        output [23:0] coin_pic_out
);
    always_ff @( posedge Clk)
    begin
        if (zhengmian)
            begin
                coin_pic_out = front;
            end
        else if (cemian)
            begin
                coin_pic_out = side;
            end
        else if (beimian)
            begin
                coin_pic_out = back;
            end
        else if (eaten)
            begin
                coin_pic_out = 24'h6b8cff;
            end
        else
            begin
                coin_pic_out = front;
            end
    end
endmodule