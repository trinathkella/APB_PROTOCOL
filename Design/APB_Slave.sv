module APB_Slave (

	input pclk,
	input preset_n,
	input pselx,
	input penable,
	input pwrite,
	input [7:0] paddr,
	input [7:0] pwdata,

	output reg pready,
	output [7:0] prdata
	
);

	//MEMORY 
	reg [7:0] memory [7:0];

	//Address for the location
	reg [7:0] address;

	assign prdata = memory[address]; //Reading the Data from the particular address

	always @(*)
	begin
	 	if(!preset_n)
	 		begin
	 			pready = 1'b0;
	 		end

	 	//Read Transfer
	 	else if(pselx && !penable && !pwrite)
	 		begin
	 			pready = 1'b0;
	 		end

	 	//Read Transfer
	 	else if(pselx && penable && !pwrite)
	 		begin
	 			pready  = 1'b1;
	 			address = paddr;
	 		end

	 	//Write Transfer
	 	else if(pselx && !penable && pwrite)
	 		begin
	 			pready = 1'b0;
	 		end

	 	//Write Transfer
	 	else if(pselx && penable && pwrite)
	 		begin
	 			pready = 1'b1;
	 			memory[address] = pwdata;
	 		end

	 	else 
	 		begin
	 			pready = 1'b0;
	 		end

	 end 

endmodule : APB_Slave