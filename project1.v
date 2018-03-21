module adler32(
	input clock, rst_n, size_valid, data_start,
	input [31:0] size, // bytes in the message
	input [7:0] data, // input byte of the message
	output checksum_valid, // Is 1 when checksum has been computed
	output [31:0] checksum // Value of checksum
);
	reg [1:0] decision;
	
	controller U1 (clock, rst_n, size_valid, data_start, size, decision);
	dataPath U2 (decision, data, checksum_valid, checksum);

endmodule

module controller(
	input clock, rst_n, size_valid, data_start, //these values will help decided the correct decision
	input [31:0] inSize,
	output reg [1:0] decision
);
	reg [31:0] size;

	always @(posedge clock)
		if(!rst_n)
			begin
			decision <= 3; // signal reset
			size <= 0;
			end
		else if(size_valid)
			begin
			decision <= 2; // signal size found
			size <= inSize; // load message size
			end
		else if(data_start)
			begin
			decision <= 1; // signal start of message
			end
		else
			begin
			if(size > 0) 
				size <= (size - 1); // decrement each cycle
			else
				decision <= 0; // signal end of message
			end
endmodule

module dataPath(
	input [1:0] decision,
	input [7:0] data,
	output reg checksum_performed,
	output reg [31:0] checksum
);

	reg [15:0] A, B;
	
	always @ *
	begin
		case(decision)
		0:	begin // end of message case
			checksum <= {B,A};
			checksum_performed <= 1;
			end
		1:	begin // message found case
			A <= A + data;	// Compute A
			A <= (A > 65520)?(A-65521):A; // Check modulo
			
			B <= B + A;		// Compute B
			B <= (B > 65520)?(B-65521):B; // Check modulo
			end
		2:	begin // size found case
			A <= 1;
			B <= 0;
			end
		3:	begin // reset case
			checksum <= 0;
			checksum_performed <= 0;
			end
		default:begin
				end
		endcase
	end

endmodule




















