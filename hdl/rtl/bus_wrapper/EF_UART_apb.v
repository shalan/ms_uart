
/*
	Copyright 2023 efabless

	Author: Mohamed Shalan (mshalan@efabless.com)

	This file is auto-generated by wrapper_gen.py

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	    http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.

*/


`timescale			1ns/1ns
`default_nettype	none

`define		APB_BLOCK(name, init)	always @(posedge PCLK or negedge PRESETn) if(~PRESETn) name <= init;
`define		APB_REG(name, init)		`APB_BLOCK(name, init) else if(apb_we & (PADDR[15:0]==``name``_ADDR)) name <= PWDATA;
`define		APB_ICR(sz)				`APB_BLOCK(ICR_REG, sz'b0) else if(apb_we & (PADDR[15:0]==ICR_REG_ADDR)) ICR_REG <= PWDATA; else ICR_REG <= sz'd0;

module EF_UART_apb (
	input	wire 		RX,
	output	wire 		TX,
	input	wire 		PCLK,
	input	wire 		PRESETn,
	input	wire [31:0]	PADDR,
	input	wire 		PWRITE,
	input	wire 		PSEL,
	input	wire 		PENABLE,
	input	wire [31:0]	PWDATA,
	output	wire [31:0]	PRDATA,
	output	wire 		PREADY,
	output	wire 		irq
);
	localparam[15:0] TXDATA_REG_ADDR = 16'h0000;
	localparam[15:0] RXDATA_REG_ADDR = 16'h0004;
	localparam[15:0] PRESCALE_REG_ADDR = 16'h0008;
	localparam[15:0] TXFIFOLEVEL_REG_ADDR = 16'h000c;
	localparam[15:0] RXFIFOLEVEL_REG_ADDR = 16'h0010;
	localparam[15:0] TXFIFOT_REG_ADDR = 16'h0014;
	localparam[15:0] RXFIFOT_REG_ADDR = 16'h0018;
	localparam[15:0] CONTROL_REG_ADDR = 16'h001c;
	localparam[15:0] ICR_REG_ADDR = 16'h0f00;
	localparam[15:0] RIS_REG_ADDR = 16'h0f04;
	localparam[15:0] IM_REG_ADDR = 16'h0f08;
	localparam[15:0] MIS_REG_ADDR = 16'h0f0c;

	reg	[15:0]	PRESCALE_REG;
	reg	[3:0]	TXFIFOT_REG;
	reg	[3:0]	RXFIFOT_REG;
	reg	[2:0]	CONTROL_REG;
	reg	[3:0]	RIS_REG;
	reg	[3:0]	ICR_REG;
	reg	[3:0]	IM_REG;

	wire[7:0]	rdata;
	wire[7:0]	RXDATA_REG	= rdata;
	wire[15:0]	prescale	= PRESCALE_REG[15:0];
	wire[3:0]	tx_level;
	wire[3:0]	TXFIFOLEVEL_REG	= tx_level;
	wire[3:0]	rx_level;
	wire[3:0]	RXFIFOLEVEL_REG	= rx_level;
	wire[3:0]	txfifotr	= TXFIFOT_REG[3:0];
	wire[3:0]	rxfifotr	= RXFIFOT_REG[3:0];
	wire		en	= CONTROL_REG[0:0];
	wire		tx_en	= CONTROL_REG[1:1];
	wire		rx_en	= CONTROL_REG[2:2];
	wire		tx_empty;
	wire		_TX_EMPTY_FLAG_FLAG_	= tx_empty;
	wire		tx_level_below;
	wire		_TX_BELOW_FLAG_FLAG_	= tx_level_below;
	wire		rx_full;
	wire		_RX_FULL_FLAG_FLAG_	= rx_full;
	wire		rx_level_above;
	wire		_TR_ABOVE_FLAG_FLAG_	= rx_level_above;
	wire[3:0]	MIS_REG	= RIS_REG & IM_REG;
	wire		apb_valid	= PSEL & PENABLE;
	wire		apb_we	= PWRITE & apb_valid;
	wire		apb_re	= ~PWRITE & apb_valid;
	wire		_clk_	= PCLK;
	wire		_rst_	= ~PRESETn;
	wire		rd	= (apb_re & (PADDR[15:0]==RXDATA_REG_ADDR));
	wire		wr	= (apb_we & (PADDR[15:0]==TXDATA_REG_ADDR));
	wire[7:0]	wdata	= PWDATA[7:0];

	EF_UART inst_to_wrap (
		.clk(_clk_),
		.rst_n(~_rst_),
		.prescale(prescale),
		.en(en),
		.rd(rd),
		.wr(wr),
		.wdata(wdata),
		.tx_empty(tx_empty),
		.tx_level(tx_level),
		.rdata(rdata),
		.rx_full(rx_full),
		.rx_level(rx_level),
		.RX(RX),
		.TX(TX),
		.tx_en(tx_en),
		.rx_en(rx_en),
		.tx_level_below(tx_level_below),
		.rx_level_above(rx_level_above),
		.txfifotr(txfifotr),
		.rxfifotr(rxfifotr)
	);

	`APB_REG(PRESCALE_REG, 0)
	`APB_REG(TXFIFOT_REG, 0)
	`APB_REG(RXFIFOT_REG, 0)
	`APB_REG(CONTROL_REG, 0)
	`APB_REG(IM_REG, 0)

	`APB_ICR(4)

	always @(posedge PCLK or negedge PRESETn)
		if(~PRESETn) RIS_REG <= 32'd0;
		else begin
			if(_TX_EMPTY_FLAG_FLAG_) RIS_REG[0] <= 1'b1; else if(ICR_REG[0]) RIS_REG[0] <= 1'b0;
			if(_TX_BELOW_FLAG_FLAG_) RIS_REG[1] <= 1'b1; else if(ICR_REG[1]) RIS_REG[1] <= 1'b0;
			if(_RX_FULL_FLAG_FLAG_) RIS_REG[2] <= 1'b1; else if(ICR_REG[2]) RIS_REG[2] <= 1'b0;
			if(_TR_ABOVE_FLAG_FLAG_) RIS_REG[3] <= 1'b1; else if(ICR_REG[3]) RIS_REG[3] <= 1'b0;

		end

	assign irq = |MIS_REG;

	assign	PRDATA = 
			(PADDR[15:0] == PRESCALE_REG_ADDR) ? PRESCALE_REG :
			(PADDR[15:0] == TXFIFOT_REG_ADDR) ? TXFIFOT_REG :
			(PADDR[15:0] == RXFIFOT_REG_ADDR) ? RXFIFOT_REG :
			(PADDR[15:0] == CONTROL_REG_ADDR) ? CONTROL_REG :
			(PADDR[15:0] == RIS_REG_ADDR) ? RIS_REG :
			(PADDR[15:0] == ICR_REG_ADDR) ? ICR_REG :
			(PADDR[15:0] == IM_REG_ADDR) ? IM_REG :
			(PADDR[15:0] == RXDATA_REG_ADDR) ? RXDATA_REG :
			(PADDR[15:0] == TXFIFOLEVEL_REG_ADDR) ? TXFIFOLEVEL_REG :
			(PADDR[15:0] == RXFIFOLEVEL_REG_ADDR) ? RXFIFOLEVEL_REG :
			(PADDR[15:0] == MIS_REG_ADDR) ? MIS_REG :
			32'hDEADBEEF;


	assign PREADY = 1'b1;

endmodule
