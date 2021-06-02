/* 2-input multiplexor */  

module mux2 (in0, in1, select, out);

input in0,in1,select;  
output out;
wire s0,w0,w1; 

not n1 (s0, select);
and a1 (w0, s0, in0);
and a2 (w1, select, in1);
or g3	(out, w0, w1); 

endmodule // mux2
