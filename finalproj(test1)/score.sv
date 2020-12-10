module score (
        input Reset, frame_clk, Clk,
        input coin1_alive,
        input coin2_alive,
        input coin3_alive,
        input coin4_alive,
        input coin5_alive,
        input coin6_alive,
        input coin7_alive,
        output [2:0] score
);
    logic [2:0] tracker;
    assign score = tracker;

    tracker = (~coin1_alive) + (~coin2_alive) + (~coin3_alive) + (~coin4_alive) + (~coin5_alive) + (~coin6_alive) + (~coin7_alive);

endmodule