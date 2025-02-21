module APB_Top_Module (
	
	input pclk,
	input preset_n,
	input transfer, read, write,
	input [8:0] apb_read_paddr,
	input [8:0] apb_write_paddr,
	input [7:0] apb_write_data_in,

	output pslverr,
	output [7:0]apb_read_data_out
	
);

	wire [7:0] pwdata, prdata;
	wire [7:0] prdata_from_slave;
	wire [8:0] paddr;
	wire pready, pready_from_slave;
	wire penable;
	wire psel;
	wire pwrite;

	assign pready = paddr[8] ? pready_from_slave : 1'b0;

	assign prdata = paddr[8] ? prdata_from_slave : 8'dx;


	//Master
	APB_Master master(.apb_write_paddr(apb_write_paddr), .apb_read_paddr(apb_read_paddr),
				 .apb_write_data(apb_write_data_in), .apb_read_data(prdata), .preset_n(preset_n),
				 .pclk(pclk), .read(read), .write(write), .transfer(transfer), .pready(pready),
				 .psel(psel), .penable(penable), .paddr(paddr), .pwrite(pwrite),
				 .pwdata(pwdata), .apb_read_data_out(apb_read_data_out), .pslverr(pslverr));

	//Slave
	APB_Slave slave(.pclk(pclk), .preset_n(preset_n), .pselx(psel), .penable(penable), .pwrite(pwrite), 
				      .paddr(paddr), .pwdata(pwdata), .prdata(prdata_from_slave), .pready(pready_from_slave));

endmodule : APB_Top_Module
