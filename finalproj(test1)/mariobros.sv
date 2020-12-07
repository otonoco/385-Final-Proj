module mariobros (

      ///////// Clocks /////////
      input              Clk,

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);




logic Reset_h, vssig, blank, sync, VGA_Clk;


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [9:0] drawxsig, drawysig, ballxsig, ballysig, ballsizesig;
	logic [7:0] Red, Blue, Green;
	logic [31:0] keycode;

//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	logic [23:0] mario_counter;

	


    HexDriver hex0 (
            .In(mario_counter[3:0]),
            .Out(HEX0)
    );

    HexDriver hex1 (
            .In(mario_counter[7:4]),
            .Out(HEX1)
    );

    HexDriver hex2 (
            .In(mario_counter[11:8]),
            .Out(HEX2)
    );

    HexDriver hex3 (
            .In(mario_counter[15:12]),
            .Out(HEX3)
    );
	
    HexDriver hex4 (
            .In(mario_counter[19:16]),
            .Out(HEX4)
    );

    HexDriver hex5 (
            .In(mario_counter[23:20]),
            .Out(HEX5)
    );
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);

	//Our A/D converter is only 12 bit
	assign VGA_R = Red[7:4];
	assign VGA_B = Blue[7:4];
	assign VGA_G = Green[7:4];
	
	
	lab8_soc u0 (
		.clk_clk                           (Clk),            //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.clk_sdram_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n
	 
		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(keycode)
		
	 );


//insta1ntiate a vga_controller, ball, and color_mapper here with the ports.
				
    vga_controller VGA(.Clk(Clk), .Reset(Reset_h), .hs(VGA_HS), .vs(VGA_VS), .pixel_clk(VGA_Clk), .blank(blank), .sync(sync), .DrawX(drawxsig), .DrawY(drawysig)); 

    // The followings are for single-player Mode
    // logic [9:0] mario_x, mario_y, process, mario_y_motion;
    // logic mario, mario_in_air;
    // logic [23:0] mario_pic_out;
    // logic [23:0] mario_sr, mario_sl, mario_rr1, mario_rr2, mario_rr3, mario_rl1, mario_rl2, mario_rl3, mario_jr, mario_jl, mario_die,groundd; 
	 
    // The followings are for Luigi in dual-player Mode 
	logic [9:0] luigi_x, luigi_y, process2, luigi_y_motion;
    logic luigi, luigi_in_air;
    logic [23:0] luigi_pic_out;
    logic [23:0] luigi_sr, luigi_sl, luigi_rr1, luigi_rr2, luigi_rr3, luigi_rl1, luigi_rl2, luigi_rl3, luigi_jr, luigi_jl, luigi_die; 
	 
    // The followings are for Mario in dual-player Mode
	logic [9:0] mariod_x, mariod_y, process1,  mariod_y_motion;
    logic mariod, mariod_in_air;
    logic [23:0] mariod_pic_out;
    logic [23:0] mariod_sr, mariod_sl, mariod_rr1, mariod_rr2, mariod_rr3, mariod_rl1, mariod_rl2, mariod_rl3, mariod_jr, mariod_jl, mariod_die; 
	 
    // The followings are for Gomba
    logic gomba_alive,gomba, gomba_dead;
    logic [23:0] gomba_left, gomba_right,gomba_pic_out,gomba_deadp;
    logic [9:0] gomba_x, gomba_y;
    logic gomba_deadd; 
    logic mariod_dead, luigi_dead;
    logic mario_dead;

    // logic [1:0] player;
    // assign player = 2'b10;

	gomba #(10'd0, 10'd1023, 10'd400) gb1(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS),.gomba(gomba), .DrawX(drawxsig), .DrawY(drawysig), .mario_x(mario_x), .process(process1),.gomba_alive(~gomba_dead),.gomba_left(gomba_left),.gomba_right(gomba_right), .gomba_deadp(gomba_deadp),.gomba_x(gomba_x), .gomba_y(gomba_y),.gomba_pic_out(gomba_pic_out));
    gomba_r g_r(.Clk(VGA_Clk), .read_addr((drawxsig - gomba_x + process1)%32 + 32 * ((drawysig - gomba_y)%32)), .data_out(gomba_right));
    gomba_l g_l(.Clk(VGA_Clk), .read_addr((drawxsig - gomba_x + process1)%32 + 32 * ((drawysig - gomba_y)%32)), .data_out(gomba_left));
	gomba_dead gd(.Clk(VGA_Clk), .read_addr((drawxsig - gomba_x + process1)%32 + 32* ((drawysig - gomba_y)%32)), .data_out(gomba_deadp));
	collision col(.Clk(Clk), .Reset(Reset_h), .frame_Clk(VGA_VS), .mario_x(mariod_x), .mario_y(mariod_y),.gomba_x(gomba_x), .gomba_y(gomba_y), .luigi_x(luigi_x), .luigi_y(luigi_y),.mario_y_motion(mariod_y_motion), .luigi_y_motion(luigi_y_motion),  .mario_dead(mariod_dead), .gomba_dead(gomba_dead),.luigi_dead(luigi_dead));

    luigi_d lluigi(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(drawxsig), .DrawY(drawysig), .luigi_alive(~luigi_dead), .keycode(keycode),  .mario_x(mariod_x), .mario_y(mariod_y),.luigi_x(luigi_x), .luigi_y(luigi_y), .process_from_mario(process1), .process(process2), .luigi_y_motion(luigi_y_motion), .luigi(luigi), .luigi_in_air(luigi_in_air), .luigi_pic_out(luigi_pic_out), .*);
    mario_d dmario(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(drawxsig), .DrawY(drawysig), .mariod_alive(~mariod_dead), .keycode(keycode), .mariod_x(mariod_x), .mariod_y(mariod_y), .process(process1), .mariod_y_motion(mariod_y_motion), .mariod(mariod), .mariod_in_air(mariod_in_air), .mariod_pic_out(mariod_pic_out), .*);
	  
//    mario_s mmario(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(drawxsig), .DrawY(drawysig), .mario_alive(~mario_dead), .keycode(keycode), .mario_x(mario_x), .mario_y(mario_y), .process(process), .mario_y_motion(mario_y_motion), .mario(mario), .mario_in_air(mario_in_air), .mario_pic_out(mario_pic_out), .*);
    // color_mapper cm(.mario(mario), .luigi(luigi), .mariod(mariod), .gomba(gomba), .coin(coin), .coin_pic_out(coin_pic_out), .mario_pic_out(mario_pic_out), .mariod_pic_out(mariod_pic_out), .luigi_pic_out(luigi_pic_out), .gomba_pic_out(gomba_pic_out), .ground(groundd), .DrawX(drawxsig), .DrawY(drawysig), .Red(Red), .Green(Green), .Blue(Blue));

    color_mapper cm(.mariod(mariod), .luigi(luigi), .gomba(gomba), .coin1(coin1), .coin2(coin2), .mariod_pic_out(mariod_pic_out), .luigi_pic_out(luigi_pic_out), .gomba_pic_out(gomba_pic_out), .coin1_pic_out(coin1_pic_out), .coin2_pic_out(coin2_pic_out), .ground(groundd), .DrawX(drawxsig), .drawysig(drawysig), .Red(Red), .Green(Green), .Blue(Blue));
    
    // The followings are for coins
    logic coin1_alive, coin1;
    logic coin2_alive, coin2;
    logic [23:0] front, side, back;    
    logic [9:0] coin1_x, coin1_y;
    logic [9:0] coin2_x, coin2_y;
    logic [23:0] coin1_pic_out, coin2_pic_out;
    front f1(.Clk(VGA_Clk), .read_addr((drawxsig - coin1_x + process1)%16 + 16 * ((drawysig - coin1_y)%28)), .front(front));
    side s1(.Clk(VGA_Clk), .read_addr((drawxsig - coin1_x + process1)%16 + 16 * ((drawysig - coin1_y)%28)), .side(side));
    back b1(.Clk(VGA_Clk), .read_addr((drawxsig - coin1_x + process1)%16 + 16 * ((drawysig - coin1_y)%28)), .back(back));
    coin #(10'd0, 10'd1023, 10'd400) c1(.Reset(Reset_h), .frame_clk(VGA_VS), .Clk(Clk), .DrawX(drawxsig), .DrawY(drawysig), .process(process1), .coin_alive(coin1_alive), .front(front), .side(side), .back(back),.coin(coin1),.coin_x(coin1_x), .coin_y(coin1_y),.coin_pic_out(coin1_pic_out));
    eat_coin ec1(.Reset(Reset_h), .frame_Clk(VGA_VS), .Clk(Clk), .mario_x(mariod_x), .mario_y(mariod_y),.coin_x(coin1_x), .coin_y(coin1_y),.luigi_x(luigi_x), .luigi_y(luigi_y),.coin_alive(coin1_alive));

    front f2(.Clk(VGA_Clk), .read_addr((drawxsig - coin2_x + process1)%16 + 16 * ((drawysig - coin2_y)%28)), .front(front));
    side s2(.Clk(VGA_Clk), .read_addr((drawxsig - coin2_x + process1)%16 + 16 * ((drawysig - coin2_y)%28)), .side(side));
    back b2(.Clk(VGA_Clk), .read_addr((drawxsig - coin2_x + process1)%16 + 16 * ((drawysig - coin2_y)%28)), .back(back));
    coin #(10'd0, 10'd1023, 10'd900) c2(.Reset(Reset_h), .frame_clk(VGA_VS), .Clk(Clk), .DrawX(drawxsig), .DrawY(drawysig), .process(process1), .coin_alive(coin2_alive), .front(front), .side(side), .back(back),.coin(coin2),.coin_x(coin2_x), .coin_y(coin2_y),.coin_pic_out(coin2_pic_out));
	eat_coin ec2(.Reset(Reset_h), .frame_Clk(VGA_VS), .Clk(Clk), .mario_x(mariod_x), .mario_y(mariod_y),.coin_x(coin2_x), .coin_y(coin2_y),.luigi_x(luigi_x), .luigi_y(luigi_y),.coin_alive(coin2_alive));

	 //mario move single mode
//    STAND_R stand_r(.Clk(VGA_Clk), .read_addr((drawxsig - mario_x + process)%26 + 26 * ((drawysig - mario_y)%32)), .data_out(mario_sr));
 //   STAND_R stand_l(.Clk(VGA_Clk), .read_addr((10'd25 - drawxsig + mario_x - process)%26 + 26 * ((drawysig - mario_y)%32)), .data_out(mario_sl));
//    WR_1 walk_rigt_1(.Clk(VGA_Clk), .read_addr((drawxsig - mario_x + process)%26 + 26 * ((drawysig - mario_y)%32)), .data_out(mario_rr1));
//    WR_2 walk_rigt_2(.Clk(VGA_Clk), .read_addr((drawxsig - mario_x + process)%26 + 26 * ((drawysig - mario_y)%32)), .data_out(mario_rr2));
//    WR_3 walk_rigt_3(.Clk(VGA_Clk), .read_addr((drawxsig - mario_x + process)%26 + 26 * ((drawysig - mario_y)%32)), .data_out(mario_rr3));
//    WR_1 walk_left_1(.Clk(VGA_Clk), .read_addr((10'd25 - drawxsig + mario_x - process)%26 + 26 * ((drawysig - mario_y)%32)), .data_out(mario_rl1));
//    WR_2 walk_left_2(.Clk(VGA_Clk), .read_addr((10'd25 - drawxsig + mario_x - process)%26 + 26 * ((drawysig - mario_y)%32)), .data_out(mario_rl2));
//    WR_3 walk_left_3(.Clk(VGA_Clk), .read_addr((10'd25 - drawxsig + mario_x - process)%26 + 26 * ((drawysig - mario_y)%32)), .data_out(mario_rl3));
 //   JR jump_rigt(.Clk(VGA_Clk), .read_addr((drawxsig - mario_x + process)%26 + 26 * ((drawysig - mario_y)%32)), .data_out(mario_jr));
//    JR jump_left(.Clk(VGA_Clk), .read_addr((10'd25 - drawxsig + mario_x - process)%26 + 26 * ((drawysig - mario_y)%32)), .data_out(mario_jl));
//    DEAD deadd(.Clk(VGA_Clk), .read_addr((drawxsig - mario_x + process)%26 + 26 * ((drawysig - mario_y)%32)), .data_out(mario_die));
	 

    // The followings are for loading sprites for Mario in Dual-Player mode
    STAND_R stand_rd(.Clk(VGA_Clk), .read_addr((drawxsig - mariod_x + process1)%26 + 26 * ((drawysig - mariod_y)%32)), .data_out(mariod_sr));
    STAND_R stand_ld(.Clk(VGA_Clk), .read_addr((10'd25 - drawxsig + mariod_x - process1)%26 + 26 * ((drawysig - mariod_y)%32)), .data_out(mariod_sl));
    WR_1 walk_rigt_1d(.Clk(VGA_Clk), .read_addr((drawxsig - mariod_x + process1)%26 + 26 * ((drawysig - mariod_y)%32)), .data_out(mariod_rr1));
    WR_2 walk_rigt_2d(.Clk(VGA_Clk), .read_addr((drawxsig - mariod_x + process1)%26 + 26 * ((drawysig - mariod_y)%32)), .data_out(mariod_rr2));
    WR_3 walk_rigt_3d(.Clk(VGA_Clk), .read_addr((drawxsig - mariod_x + process1)%26 + 26 * ((drawysig - mariod_y)%32)), .data_out(mariod_rr3));
    WR_1 walk_left_1d(.Clk(VGA_Clk), .read_addr((10'd25 - drawxsig + mariod_x - process1)%26 + 26 * ((drawysig - mariod_y)%32)), .data_out(mariod_rl1));
    WR_2 walk_left_2d(.Clk(VGA_Clk), .read_addr((10'd25 - drawxsig + mariod_x - process1)%26 + 26 * ((drawysig - mariod_y)%32)), .data_out(mariod_rl2));
    WR_3 walk_left_3d(.Clk(VGA_Clk), .read_addr((10'd25 - drawxsig + mariod_x - process1)%26 + 26 * ((drawysig - mariod_y)%32)), .data_out(mariod_rl3));
    JR jump_rigtd(.Clk(VGA_Clk), .read_addr((drawxsig - mariod_x + process1)%26 + 26 * ((drawysig - mariod_y)%32)), .data_out(mariod_jr));
    JR jump_leftd(.Clk(VGA_Clk), .read_addr((10'd25 - drawxsig + mariod_x - process1)%26 + 26 * ((drawysig - mariod_y)%32)), .data_out(mariod_jl));
    DEAD deaddd(.Clk(VGA_Clk), .read_addr((drawxsig - mariod_x + process1)%26 + 26 * ((drawysig - mariod_y)%32)), .data_out(mariod_die));
	 
	// The followings are for loading sprites for Luigi in Dual-Player mode
    STANDL_R stand_rl(.Clk(VGA_Clk), .read_addr((drawxsig - luigi_x + process1)%26 + 26 * ((drawysig - luigi_y)%32)), .data_out(luigi_sr));
    STANDL_R stand_ll(.Clk(VGA_Clk), .read_addr((10'd25 - drawxsig + luigi_x - process1)%26 + 26 * ((drawysig - luigiy)%32)), .data_out(luigi_sl));
    WRL_1 walk_rigt_1l(.Clk(VGA_Clk), .read_addr((drawxsig - luigi_x + process1)%26 + 26 * ((drawysig - luigi_y)%32)), .data_out(luigi_rr1));
    WRL_2 walk_rigt_2l(.Clk(VGA_Clk), .read_addr((drawxsig - luigi_x + process1)%26 + 26 * ((drawysig - luigi_y)%32)), .data_out(luigi_rr2));
    WRL_3 walk_rigt_3l(.Clk(VGA_Clk), .read_addr((drawxsig - luigi_x + process1)%26 + 26 * ((drawysig - luigi_y)%32)), .data_out(luigi_rr3));
    WRL_1 walk_left_1l(.Clk(VGA_Clk), .read_addr((10'd25 - drawxsig + luigi_x - process1)%26 + 26 * ((drawysig - luigi_y)%32)), .data_out(luigi_rl1));
    WRL_2 walk_left_2l(.Clk(VGA_Clk), .read_addr((10'd25 - drawxsig + luigi_x - process1)%26 + 26 * ((drawysig - luigi_y)%32)), .data_out(luigi_rl2));
    WRL_3 walk_left_3l(.Clk(VGA_Clk), .read_addr((10'd25 - drawxsig + luigi_x - process1)%26 + 26 * ((drawysig - luigi_y)%32)), .data_out(luigi_rl3));
    JRL jump_rigtl(.Clk(VGA_Clk), .read_addr((drawxsig - luigi_x + process1)%26 + 26 * ((drawysig - luigi_y)%32)), .data_out(luigi_jr));
    JRL jump_leftl(.Clk(VGA_Clk), .read_addr((10'd25 - drawxsig + luigi_x - process1)%26 + 26 * ((drawysig - luigi_y)%32)), .data_out(luigi_jl));
    DEADL deaddl(.Clk(VGA_Clk), .read_addr((drawxsig - luigi_x + process1)%26 + 26 * ((drawysig - luigi_y)%32)), .data_out(luigi_die));
	 
    // The following is for loading the sprite for the ground
    BACKGROUND ground(.Clk(VGA_Clk),  .read_addr(drawxsig % 32 + 32* (drawysig%64)),  .data_out(groundd));
	 
	 
	 
endmodule