module APB_Master
(
	input [7:0] apb_write_paddr,apb_read_paddr,
	input [7:0] apb_write_data, apb_read_data,
	input preset_n, 
	input pclk,
	input read, write, transfer, pready,

	output psel,
	output reg penable,
	output reg [8:0]paddr,
	output reg pwrite,
	output reg [7:0]pwdata, apb_read_data_out,
	output pslverr
);

	reg [1:0] present_state, next_state;

	reg invalid_setup_error;
	reg setup_error;
	reg invalid_read_paddr, invalid_write_paddr, invalid_write_data;

	parameter IDLE   = 2'b00;
	parameter SETUP  = 2'b01;
	parameter ACCESS = 2'b10;

	always @ (posedge pclk)
	begin
		if(!preset_n)
			present_state <= IDLE;
		else
			present_state <= next_state;
	end

	always @ (*)
	begin
		pwrite = write;

		case(present_state)
			
			IDLE : begin
				penable = 0;
				if(!transfer)
					next_state = IDLE;
				else
					next_state = SETUP;
			end

			SETUP : begin
				penable = 0;
				
				if(read == 1'b1 && write == 1'b0)
				begin
					paddr = apb_read_paddr;
				end
				
				else if(read == 1'b0 && write == 1'b1)
				begin
					paddr  = apb_write_paddr;
					pwdata = apb_write_data;
				end

			end

			ACCESS : begin
				
				if(psel)
					begin
						penable = 1'b1;
					end
				else
					begin
						penable = 1'b0;
					end

				if(transfer && !pslverr)
					begin
						if(pready)
							begin
								if(read == 1'b0 && write == 1'b1)
									begin
										next_state = SETUP;
									end
								else if(read == 1'b1 && write == 1'b0)
									begin
										next_state = SETUP;
										apb_read_data_out = apb_read_data;
									end
						else
							begin
								next_state = ACCESS;
							end
				else
					begin
						next_state = IDLE;
					end
							end
					end
			end

		endcase
	end

	assign psel = (present_state == !IDLE) ? 1'b1 : 1'b0;

	//PSLAVE ERROR LOGIC
	always@(*)
	begin
		invalid_setup_error = setup_error || invalid_read_paddr || invalid_write_data || invalid_write_paddr;
		if(!preset_n)
		begin
			setup_error = 1'b0;
			invalid_read_paddr = 1'b0;
			invalid_write_paddr = 1'b0;
		end
		else if(present_state == IDLE && next_state == ACCESS)
		begin
			setup_error = 1'b1;
		end
		else if((apb_write_data == 8'dx) && (read == 1'b0) && (write == 1'b1) && (present_state == SETUP) || (present_state == ACCESS))
			begin
				invalid_write_data = 1'b1;
			end
		else if((apb_read_paddr == 9'dx) && (read == 1'b1) && (write == 1'b0) && (present_state == SETUP) || (present_state == ACCESS))
			begin
				invalid_read_paddr = 1'b1;
			end
		else if((apb_write_paddr == 9'dx) && (read == 1'b0) && (write == 1'b1) && (present_state == SETUP) || (present_state == ACCESS))
			begin
				invalid_write_paddr = 1'b1;
			end
		else
			begin
				invalid_write_paddr = 1'b0;
				invalid_write_data = 1'b0;
				invalid_read_paddr = 1'b0;
			end
	end

	pslverr = invalid_setup_error;

endmodule : APB_Master