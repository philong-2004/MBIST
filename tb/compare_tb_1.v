`timescale 1ns/1ps
module compare_tb_1();
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
    
    reg rstComp;
    reg compare_EN;
    reg captureData;
    reg [3:0] compSel;
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
    .captureData(captureData),
    .compSel(compSel),
    .rstComp(rstComp)
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
    rstComp = 0;
    captureData = 0;
    compSel = 4'b0000;
end


always #10 CLK = ~CLK;

initial begin 
    #100;
    nRESET = 1;
    ADDR_RST = 1;
    #20;
  $display("Starting write phase...");
    gen_Turn = 4'd3;
    PAT_SEL = 3'd0;    
    @(posedge CLK);
    repeat(128) begin
    writeAll = 1;
    DATA_EN = 1;
    ADDR_EN = 1; 

    @(posedge CLK);
    ADDR_EN = 0;     
    iWrite = 1; 
      
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

    repeat(127) begin   
    @(posedge CLK);
    rstComp = 0;
    ADDR_EN = 0;
    iRead = 1;
    memSel = 2'b00; //doc data mem0

    DATA_EN = 1; //sinh data expect cho comparator_0
    gen_Turn = 4'd3;
    PAT_SEL = 3'd0;  
    
    //Doc data mem0
    @(posedge CLK); // Comparator_0 capture data 
    captureData = 1;
    compSel = 4'b0001; //chọn comparator_0 để so sánh data mem0

    @(posedge CLK);
    iRead = 0;
    captureData = 0;
    compSel = 4'b0000; //reset compSel sau khi đã capture data từ mem0
    DATA_EN = 0;

    @(posedge CLK);
    iRead = 1;
    memSel = 2'b01; //doc data mem1

    DATA_EN = 1; //sinh data expect cho comparator_1
    gen_Turn = 4'd3;
    PAT_SEL = 3'd0;

    @(posedge CLK); // Comparator_1 capture data 
    captureData = 1;
    compSel = 4'b0010; //chọn comparator_1 để so sánh data mem1

    @(posedge CLK);
    iRead = 0;
    captureData = 0;
    compSel = 4'b0000; //reset compSel sau khi đã capture data từ mem1
    DATA_EN = 0;

    @(posedge CLK);
    iRead = 1; //doc data mem2
    memSel = 2'b10;

    DATA_EN = 1; //sinh data expect cho comparator_2
    gen_Turn = 4'd3;
    PAT_SEL = 3'd0;  

    @(posedge CLK); // Comparator_2 capture data 
    captureData = 1;
    compSel = 4'b0100; //chọn comparator_2 để so sánh data mem2

    @(posedge CLK);
    iRead = 0;  
    captureData = 0;
    compSel = 4'b0000; //reset compSel sau khi đã capture data từ mem2
    DATA_EN = 0;

    @(posedge CLK);
    iRead = 1;
    memSel = 2'b11; //doc data mem3
     
    DATA_EN = 1;     //sinh data expect cho comparator_3
    gen_Turn = 4'd3;
    PAT_SEL = 3'd0;      

    @(posedge CLK); // Comparator_3 capture data 
    captureData = 1;
    compSel = 4'b1000; //chọn comparator_3 để so sánh data mem3

    @(posedge CLK);
    iRead = 0;  
    captureData = 0;
    compSel = 4'b0000; //reset compSel sau khi đã capture data từ mem3
    DATA_EN = 0; 
    gen_Turn = 4'd0;
    PAT_SEL = 3'd0;   
    @(posedge CLK);  
    compare_EN = 1; // Bắt đầu so sánh kết quả sau khi đã capture data từ cả 4 memBank
    @(posedge CLK);
    compare_EN = 0;    
    rstComp = 1; // Reset comparator sau khi hoàn thành so sánh
    ADDR_EN = 1;
    end

    @(posedge CLK);
    #100;
    $finish;
end
always @(posedge CLK) begin
    if (compare_EN) begin
        $display("Time: %0t | result0: %b | result1: %b | result2: %b | result3: %b", 
            $time, result_comp0, result_comp1, result_comp2, result_comp3);
    end
end

initial begin

    $monitor("Time: %0t |iRead: %b | iWrite: %b | W_addr: %d |memSel: %b | data_OUT: %h", $time, iRead, iWrite, W_addr, memSel, data_OUT);
    
end

endmodule