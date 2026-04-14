`timescale 1ns/1ps
module testData_tb();
    reg CLK;
    reg nRESET;
    reg iWrite;
    reg iRead;
    reg [1:0] memSel;
    reg writeAll;

    reg DATA_EN;
    reg ADDR_EN;
    reg ADDR_RST;
    reg [3:0] gen_Turn;
    reg [2:0] PAT_SEL;
    reg compare_EN;
    reg captureData;
    wire result_comp0, result_comp1, result_comp2, result_comp3;

    wire [7:0] data_OUT;
    wire [7:0] W_addr;
testData dut (
    .CLK(CLK),
    .nRESET(nRESET),
    .iWrite(iWrite),
    .iRead(iRead),
    .memSel(memSel),
    .writeAll(writeAll),
    .DATA_EN(DATA_EN),
    .ADDR_EN(ADDR_EN),
    .ADDR_RST(ADDR_RST),
    .gen_Turn(gen_Turn),
    .PAT_SEL(PAT_SEL),
    .data_OUT(data_OUT),
    .W_addr(W_addr),
    .compare_EN(compare_EN),
    .result_comp0(result_comp0),
    .result_comp1(result_comp1),
    .result_comp2(result_comp2),
    .result_comp3(result_comp3),
    .captureData(captureData)
);

initial begin 
    CLK = 0;
    nRESET = 0;
    iWrite = 0;
    iRead = 0;
    memSel = 2'b00;
    writeAll = 0;
    DATA_EN = 0;
    ADDR_EN = 0;
    ADDR_RST = 0;
    gen_Turn = 0;
    PAT_SEL = 0;
    compare_EN = 0;
    captureData = 0;
end


always #10 CLK = ~CLK;

initial begin 
    #100;
    nRESET = 1;
    ADDR_RST = 1;
    #20;
    writeAll = 0;
  $display("Starting write phase...");
    gen_Turn = 4'd1;
    PAT_SEL = 3'd0;    
    repeat(128) begin
    @(posedge CLK);     
    DATA_EN = 1;
    ADDR_EN = 1; 

    @(posedge CLK);
    ADDR_EN = 0;     
    memSel = 2'b00;  // Test Mscan mem0
    iWrite = 1; 
    @(posedge CLK);    
    iWrite = 0;
      
    @(posedge CLK);
    iWrite = 1;     
    memSel = 2'b00; // Test checker board mem1
    @(posedge CLK);
    iWrite = 0;     
 
    @(posedge CLK);
    iWrite = 1;      
    memSel = 2'b10; // Test Mscan mem2    
    @(posedge CLK);
    iWrite = 0; 
    
    @(posedge CLK);
    iWrite = 1;     
    memSel = 2'b11; // Test checker board mem3
    @(posedge CLK);
    iWrite = 0;         
    DATA_EN = 0;
    @(posedge CLK);

    end

    $display("Write phase completed. Starting read phase...");
    @(posedge CLK);
    ADDR_RST = 0;
    @(posedge CLK);
    ADDR_RST = 1;
    
    @(posedge CLK);
    iWrite = 0;
    iRead = 0;
    writeAll = 0;
    compare_phase = 1;
    repeat(128) begin   
    @(posedge CLK);
    iRead = 1;
    DATA_EN = 1; 
    memSel = 2'b00;
    gen_Turn = 4'd1;
    PAT_SEL = 3'd0;  

    @(posedge CLK);
    iRead = 0;
    DATA_EN = 0;

    @(posedge CLK);
    iRead = 1;
    DATA_EN = 1; 
    memSel = 2'b01;
    gen_Turn = 4'd0;
    PAT_SEL = 3'd1; 
    @(posedge CLK);
    iRead = 0;
    DATA_EN = 0;

    @(posedge CLK);
    iRead = 1;
    DATA_EN = 1; 
    memSel = 2'b10;
    gen_Turn = 4'd1;
    PAT_SEL = 3'd0;     
    @(posedge CLK);
    iRead = 0;  
    DATA_EN = 0;

    @(posedge CLK);
    iRead = 1;
    DATA_EN = 1;     
    memSel = 2'b11;
    gen_Turn = 4'd0;
    PAT_SEL = 3'd1;      
    @(posedge CLK);
    iRead = 0;  
    DATA_EN = 0; 
    gen_Turn = 4'd0;
    PAT_SEL = 3'd0;   
    @(posedge CLK);  
    compare_EN = 1;
    @(posedge CLK);
    compare_EN = 0;    
    ADDR_EN = 1;
    @(posedge CLK);
    ADDR_EN = 0;

    end
    @(posedge CLK);
    compare_phase = 0;
    #100;
    $finish;
end
initial begin
$monitor("Time: %0t |iRead: %b | iWrite: %b | W_addr: %d |memSel: %h | data_OUT: %h", $time, iRead, iWrite, W_addr, memSel, data_OUT);
end

endmodule