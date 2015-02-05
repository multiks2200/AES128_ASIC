module mix_columns (clk,cpu_rd,cpu_rd_data,reset,data_in,data_in_vld,data_out,data_out_vld,pntr_num)

	input clk
	input cpu_read;
	input cpu_read_data;
	input reset;
	input data_in [`BLOCK_DATA_WIDTH-1:0]
	input data_in_vld
	input pntr_num [1:0]

	output data_out [`BLOCK_DATA_WIDTH-1:0]
	output data_out_vld
	output pntr_num [1:0]

	//Output signal regs
	reg [127:0] data_out;
	reg data_out_vld;

	// Counter regs
	reg reg_pntr_cntr [`CPU_DATA_WIDTH-1:0];

	//Debug regs
	reg reg_mix_columns_debug[`CPU_DATA_WIDTH-1:0];
	

	//When reset comes in, set every regiser to the reset value.
	always @ posedge reset begin
	reg_pntr_cntr <= {`CPU_DATA_WIDTH{1b'0}};
	reg_sub_bytes_debug <= {`CPU_DATA_WIDTH{1b'0}};
	sbox [15:0][15:0] <= `SBOX_VALUES;
	
	end

	always @ posedge clk begin

		//If data in is valid perform subbytes operation, as it is specified in AES specificaton, by calling subbytes function defined below.
		if  data_in_vld begin
			//Perform mix_columns on the first word
			data_out[`first_wrd_1st_byte]   <= xtime(data_in[`first_wrd_1st_byte] ^ data_in[`first_wrd_2nd_byte]) ^ data_in[`first_wrd_2nd_byte] ^ data_in[`first_wrd_3rd_byte] ^ data_in[`first_wrd_4th_byte];
			
			data_out[`first_wrd_2nd_byte]   <= data_in[`first_wrd_1st_byte] ^ xtime(data_in[`first_wrd_2nd_byte] ^ data_in[`first_wrd_3rd_byte]) ^ data_in[`first_wrd_3rd_byte] ^ data_in[`first_wrd_4th_byte];
			
			data_out[`first_wrd_3rd_byte]   <= data_in[`first_wrd_1st_byte] ^ data_in[`first_wrd_2nd_byte] ^ xtime(data_in[`first_wrd_3rd_byte] ^ data_in[`first_wrd_4th_byte]) ^ data_in[`first_wrd_4th_byte];
			
			data_out[`first_wrd_4th_byte]   <= data_in[`first_wrd_1st_byte] ^ data_in[`first_wrd_2nd_byte]) ^ data_in[`first_wrd_3rd_byte] ^ xtime(data_in[`first_wrd_4th_byte] ^ data_in[`first_wrd_1st_byte]);
			//Perform mix_columns on the second word
			data_out[`second_wrd_1st_byte]   <= xtime(data_in[`second_wrd_1st_byte] ^ data_in[`second_wrd_2nd_byte]) ^ data_in[`second_wrd_2nd_byte] ^ data_in[`second_wrd_3rd_byte] ^ data_in[`second_wrd_4th_byte];
			
			data_out[`second_wrd_2nd_byte]   <= data_in[`second_wrd_1st_byte] ^ xtime(data_in[`second_wrd_2nd_byte] ^ data_in[`second_wrd_3rd_byte]) ^ data_in[`second_wrd_3rd_byte] ^ data_in[`second_wrd_4th_byte];
			
			data_out[`second_wrd_3rd_byte]   <= data_in[`second_wrd_1st_byte] ^ data_in[`second_wrd_2nd_byte] ^ xtime(data_in[`second_wrd_3rd_byte] ^ data_in[`second_wrd_4th_byte]) ^ data_in[`second_wrd_4th_byte];
			
			data_out[`second_wrd_4th_byte]   <= data_in[`second_wrd_1st_byte] ^ data_in[`second_wrd_2nd_byte]) ^ data_in[`second_wrd_3rd_byte] ^ xtime(data_in[`second_wrd_4th_byte] ^ data_in[`second_wrd_1st_byte]);
			//Perform mix_columns on the third word
			data_out[`third_wrd_1st_byte]   <= xtime(data_in[`third_wrd_1st_byte] ^ data_in[`third_wrd_2nd_byte]) ^ data_in[`third_wrd_2nd_byte] ^ data_in[`third_wrd_3rd_byte] ^ data_in[`third_wrd_4th_byte];
			
			data_out[`third_wrd_2nd_byte]   <= data_in[`third_wrd_1st_byte] ^ xtime(data_in[`third_wrd_2nd_byte] ^ data_in[`third_wrd_3rd_byte]) ^ data_in[`third_wrd_3rd_byte] ^ data_in[`third_wrd_4th_byte];
			
			data_out[`third_wrd_3rd_byte]   <= data_in[`third_wrd_1st_byte] ^ data_in[`third_wrd_2nd_byte] ^ xtime(data_in[`third_wrd_3rd_byte] ^ data_in[`third_wrd_4th_byte]) ^ data_in[`third_wrd_4th_byte];
			
			data_out[`third_wrd_4th_byte]   <= data_in[`third_wrd_1st_byte] ^ data_in[`third_wrd_2nd_byte]) ^ data_in[`third_wrd_3rd_byte] ^ xtime(data_in[`third_wrd_4th_byte] ^ data_in[`third_wrd_1st_byte]);
			//Perform mix_columns on the fourth word
			data_out[`fourth_wrd_1st_byte]   <= xtime(data_in[`fourth_wrd_1st_byte] ^ data_in[`fourth_wrd_2nd_byte]) ^ data_in[`fourth_wrd_2nd_byte] ^ data_in[`fourth_wrd_3rd_byte] ^ data_in[`fourth_wrd_4th_byte];
			
			data_out[`fourth_wrd_2nd_byte]   <= data_in[`fourth_wrd_1st_byte] ^ xtime(data_in[`fourth_wrd_2nd_byte] ^ data_in[`fourth_wrd_3rd_byte]) ^ data_in[`fourth_wrd_3rd_byte] ^ data_in[`fourth_wrd_4th_byte];
			
			data_out[`fourth_wrd_3rd_byte]   <= data_in[`fourth_wrd_1st_byte] ^ data_in[`fourth_wrd_2nd_byte] ^ xtime(data_in[`fourth_wrd_3rd_byte] ^ data_in[`fourth_wrd_4th_byte]) ^ data_in[`fourth_wrd_4th_byte];
			
			data_out[`fourth_wrd_4th_byte]   <= data_in[`fourth_wrd_1st_byte] ^ data_in[`fourth_wrd_2nd_byte]) ^ data_in[`fourth_wrd_3rd_byte] ^ xtime(data_in[`fourth_wrd_4th_byte] ^ data_in[`fourth_wrd_1st_byte]);
			//Set data out valid for output, at the next clock when valid comes and is sampled as such
			data_out_vld <= 1'b
			//Pass the pointers number to the next block
			pntr_num <= pntr_num;
			//Increase pointers counter once pointers value comes in with data_in_vld signal
			case (pntr_num)

				1'b00 : reg_pntr_cntr[`REG_PNTR_CNTR_FIRST ] <= reg_pntr_cntr[`REG_PNTR_CNTR_FIRST ] + 1'b;

				1'b01 : reg_pntr_cntr[`REG_PNTR_CNTR_SECOND] <= reg_pntr_cntr[`REG_PNTR_CNTR_SECOND] + 1'b;

				1'b10 : reg_pntr_cntr[`REG_PNTR_CNTR_THIRD ] <= reg_pntr_cntr[`REG_PNTR_CNTR_THIRD ] + 1'b;

				1'b11 : reg_pntr_cntr[`REG_PNTR_CNTR_FOURTH] <= reg_pntr_cntr[`REG_PNTR_CNTR_FOURTH] + 1'b;

			endcase
			//If data comes in and cpu read is perfomed at the same time, set up the innterupt register.
			if data_in_vld and cpu_read begin
				reg_shift_rows_debug[`CPU_READ_AND_VALID_BOTH_HIGH] <= 1'b1;
			end
			
		end
	end


	function [7:0] xtime;

		input block_byte_data[7:0];
		//If MSB is high, xor with 8’h1B  irreducible polynomial (x^8 + x^4 + x^3 + x + 1) and then shift left by 1 bit, otherwise just do the left shift.
		if block_byte_data[7] begin
		  block_byte_data = (block_byte_data ^ 8'h1b ) << 1;
		end else
			block_byte_data = block_byte_data << 1;
		end
	end

end
