`include "udp_para.v"
module udp(	rst_n,
			phy_rst_n,
			phy_clk_tx,
			phy_clk_rx,
			rx_dv,
			tx_data,
			tx_en,
			rx_data,
			en,
			to_fifo,
			key1,
			led,
			rx_er);
//-------------------------------------------
//interface
input rx_er;
input rx_dv;
input phy_clk_rx;
input phy_clk_tx;
input rst_n;
input key1;
input [3:0] rx_data;
output [3:0] tx_data;
output tx_en;
output phy_rst_n;
output [7:0] led;
output en;
output [3:0] to_fifo;
//-----------------------------------------
assign phy_rst_n=1;
wire fifo_en;
//-----------------------------------------
//sys reset;
wire sys_rst_n_s=rst_n;
/* sys_reset sys_reset_send(			.clk		(phy_clk_tx),
									.rst_n		(rst_n),
									.sys_rst_n	(sys_rst_n_s)
						); */
//sys reset;
wire sys_rst_n_r=rst_n;
/* sys_reset sys_reset_rec(			.clk		(phy_clk_rx),
									.rst_n		(rst_n),
									.sys_rst_n	(sys_rst_n_r)
						); */
//-------------------------------------------
/*assign led[0]=en;

assign led[1]=fifo_en;

assign led[7]=rx_er;

assign led[6]=empty_fifo;*/
//
wire arp_req;
wire empty_fifo;

wire [3:0] from_fifo;
wire fifo_full;
wire arp;
//-------------------------------------------
wire [31:0] dst_ip;
wire [47:0] dst_mac;
/* udp_send udp_send_top(	.s_clk		(phy_clk_tx),
						.rst_n		(sys_rst_n_s),
						.s_en		(tx_en),
						.fifo_data	(from_fifo),
						.fifo_en	(fifo_en),
						.dataout	(tx_data),
						.go			(~key1 | ~empty_fifo |arp_req),
						//.go			(key1|arp_req),
						.dst_mac	(dst_mac),
						.dst_ip		(dst_ip),
						.arp(arp)
						//.go			(key1 | en)
					); */
/* arp_reply arp_reply(			.s_clk(phy_clk_tx),
								.rst_n(sys_rst_n_s),
								.s_en(tx_en),
								.dataout(tx_data),
								.go(key1 | arp_req) 
					); */


udp_receive udp_receive_top(	.r_clk		(phy_clk_rx),
								.rst_n		(sys_rst_n_r),
								.r_dv		(rx_dv),
								.fifo_data	(to_fifo),
								.fifo_en	(en),
								.datain		(rx_data),
								.arp_req	(arp_req),
								.arp		(arp),
								.dst_ip		(dst_ip),
								.dst_mac	(dst_mac)
							);
//---------------------------------------------
//assign led={4'hf,to_fifo};
assign led={8'hff};
/*test test1(
				.rst(rst_n),
				.clk(phy_clk_tx),
				.led(led)
				);*/
//--------------------------------------
/* `ifdef altera
	fifo 		fifo1(
					.data(to_fifo),
					.rdclk(phy_clk_tx),
					.rdreq(fifo_en),
					.wrclk(phy_clk_rx),
					.wrreq(en),
					.q(from_fifo),
					.rdempty(empty_fifo),
					.wrfull(fifo_full));

`else
fifo 		fifo1	(	.rst(rst_n), 
						.wr_clk(phy_clk_rx), 
						.rd_clk(phy_clk_tx),
						.din(to_fifo),
						.wr_en(en),
						.rd_en(fifo_en),
						.dout(from_fifo),
						.full(fifo_full),
						.empty(empty_fifo)
						);
`endif */
endmodule