module adler32(
	input clock, rst_n,
	input size_valid,
	input[3:0] size_id,
	input[31:0] size,
	input data_valid,
	input[3:0] data_id,
	input[7:0] data,
	input checksum_ready,
	
	output reg size_ready,
	output reg data_ready,
	output reg checksum_valid,
	output reg [3:0] checksum_id,
	output reg [31:0] checksum
);
	
	reg [7:0] dataIn;
	reg [3:0] use_matrix = 0;
	reg [3:0] finish_matrix = 0;
	reg [3:0] id1, id2, id3, id4;
	reg [31:0] size1, size2, size3, size4;
	reg [15:0] a1, b1, a2, b2, a3, b3, a4, b4;
	
	always @ *
	begin
		dataIn <= data;
	end
	
	always @ (posedge clock)
	begin
		data_ready <= 1;
		// Active Low Reset
		if(!rst_n)
		begin
			size_ready <= 0;
			data_ready <= 0;
			use_matrix <= 0;
			finish_matrix <= 0;
			checksum_valid <= 0;
		end
		
		// InLoad Block
		if(size_valid)
		begin
			if(use_matrix[3] == 0)
			begin
				id1 <= size_id;
				size1 <= size;
				a1 <= 1;
				b1 <= 0;
				use_matrix[3] <= 1;
				size_ready <= 1;
			end
			else
				if(use_matrix[2] == 0)
				begin
					id2 <= size_id;
					size2 <= size;
					a2 <= 1;
					b2 <= 0;
					use_matrix[2] <= 1;
					size_ready <= 1;
				end
				else
					if(use_matrix[1] == 0)
					begin
						id3 <= size_id;
						size3 <= size;
						a3 <= 1;
						b3 <= 0;
						use_matrix[1] <= 1;
						size_ready <= 1;
					end
					else
						if(use_matrix[0] == 0)
						begin
							id4 <= size_id;
							size4 <= size;
							a4 <= 1;
							b4 <= 0;	
							use_matrix [0] <= 1;
							size_ready <= 1;
						end	
						else
						begin
							size_ready <= 0;
						end
		end
		
		//Compute Block
		if(data_valid)
		begin
			case(data_id)
			id1:
			begin
				if(size1 >= 1)
				begin
					size1 <= (size1 - 1); // decrement size1
					// compute A and B
					a1 <= (a1+dataIn >= 65521)?(a1+dataIn-65521):a1+dataIn; // Check modulo and compute
				
					b1 <= (b1+a1+dataIn >= 65521)?(b1+a1+dataIn-65521):b1+a1+dataIn; // Check modulo and compute
					data_ready <= 1;
				end	
				if(size1 == 1)
				begin
					if(a1+dataIn >= 65521 && b1+a1+dataIn >= 65521)
					begin
						checksum <= {(b1+a1+dataIn-65521),(a1+dataIn-65521)};
					end
					else if(a1+dataIn >= 65521)
					begin
						checksum <= {(b1+a1+dataIn),(a1+dataIn-65521)};
					end
					else if(b1+a1+dataIn >= 65521)
					begin
						checksum <= {(b1+a1+dataIn-65521),(a1+dataIn)};
					end
					else
					begin
						checksum <= {(b1+a1+dataIn),(a1+dataIn)};
					end
					finish_matrix[3] <= 1;
					checksum_valid <= 1;
					checksum_id <= id1;
				end
			end
			id2:
			begin
				if(size2 >= 1)
				begin
					size2 <= (size2 - 1); // decrement size2
					// compute A and B
					a2 <= (a2+dataIn >= 65521)?(a2+dataIn-65521):a2+dataIn; // Check modulo and compute
				
					b2 <= (b2+a2+dataIn >= 65521)?(b2+a2+dataIn-65521):b2+a2+dataIn; // Check modulo and compute
					data_ready <= 1;
				end		
				if(size2 == 1)
				begin
					if(a2+dataIn >= 65521 && b2+a2+dataIn >= 65521)
					begin
						checksum <= {(b2+a2+dataIn-65521),(a2+dataIn-65521)};
					end
					else if(a2+dataIn >= 65521)
					begin
						checksum <= {(b2+a2+dataIn),(a2+dataIn-65521)};
					end
					else if(b2+a2+dataIn >= 65521)
					begin
						checksum <= {(b2+a2+dataIn-65521),(a2+dataIn)};
					end
					else
					begin
						checksum <= {(b2+a2+dataIn),(a2+dataIn)};
					end
					finish_matrix[2] <= 1;
					checksum_valid <= 1;
					checksum_id <= id2;
				end
			end
			id3:
			begin
				if(size3 >= 1)
				begin
					size3 <= (size3 - 1); // decrement size3
					// compute A and B
					a3 <= (a3+dataIn >= 65521)?(a3+dataIn-65521):a3+dataIn; // Check modulo and compute
				
					b3 <= (b3+a3+dataIn >= 65521)?(b3+a3+dataIn-65521):b3+a3+dataIn; // Check modulo and compute
					data_ready <= 1;
				end	
				if(size3 == 1)
				begin
					if(a3+dataIn >= 65521 && b3+a3+dataIn >= 65521)
					begin
						checksum <= {(b3+a3+dataIn-65521),(a3+dataIn-65521)};
					end
					else if(a3+dataIn >= 65521)
					begin
						checksum <= {(b3+a3+dataIn),(a3+dataIn-65521)};
					end
					else if(b3+a3+dataIn >= 65521)
					begin
						checksum <= {(b3+a3+dataIn-65521),(a3+dataIn)};
					end
					else
					begin
						checksum <= {(b3+a3+dataIn),(a3+dataIn)};
					end
					finish_matrix[1] <= 1;
					checksum_valid <= 1;
					checksum_id <= id3;
				end				
			end
			id4:
			begin
				if(size4 >= 1)
				begin
					size4 <= (size4 - 1); // decrement size4
					// compute A and B
					a4 <= (a4+dataIn >= 65521)?(a4+dataIn-65521):a4+dataIn; // Check modulo and compute
				
					b4 <= (b4+a4+dataIn >= 65521)?(b4+a4+dataIn-65521):b4+a4+dataIn; // Check modulo and compute
					data_ready <= 1;
				end	
				if(size4 == 1)
				begin
					if(a4+dataIn >= 65521 && b4+a4+dataIn >= 65521)
					begin
						checksum <= {(b4+a4+dataIn-65521),(a4+dataIn-65521)};
					end
					else if(a4+dataIn >= 65521)
					begin
						checksum <= {(b4+a4+dataIn),(a4+dataIn-65521)};
					end
					else if(b4+a4+dataIn >= 65521)
					begin
						checksum <= {(b4+a4+dataIn-65521),(a4+dataIn)};
					end
					else
					begin
						checksum <= {(b4+a4+dataIn),(a4+dataIn)};
					end
					finish_matrix[0] <= 1;
					checksum_valid <= 1;
					checksum_id <= id4;
				end
			end
			default:
			begin
			end
			endcase
		end
		
		//OffLoad Block
		if(checksum_ready)
		begin
			if(finish_matrix[3] == 1)
			begin
				checksum_valid <= 0;
				use_matrix[3] <= 0;
				finish_matrix[3] <= 0;
			end
			else
				if(finish_matrix[2] == 1)
				begin
					checksum_valid <= 0;
					use_matrix[2] <= 0;
					finish_matrix[2] <= 0;
				end
				else
					if(finish_matrix[1] == 1)
					begin
						checksum_valid <= 0;
						use_matrix[1] <= 0;
						finish_matrix[1] <= 0;
					end
					else
						if(finish_matrix[0] == 1)
						begin
							checksum_valid <= 0;
							use_matrix[0] <= 0;
							finish_matrix[0] <= 0;
						end	
		end
	end
endmodule