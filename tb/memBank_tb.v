`timescale 1ns/1ps

module memBank_tb;
        reg            iClk;
        reg    [7:0]   iAddr;
        reg            iWrite;
        reg    [7:0]   iWrData;
        reg            iRead;
        reg           writeAll;
        reg    [1:0]   memSel;
        wire     [7:0]   data_OUT;

memBank dut (
    .iClk   (iClk),
    .iAddr  (iAddr),
    .iWrite (iWrite),
    .iWrData(iWrData),
    .iRead  (iRead),
    .writeAll(writeAll),
    .memSel(memSel),
    .data_OUT(data_OUT)
);

initial begin 
    iClk = 0;
    iAddr = 0;
    iWrite = 0;
    iWrData = 0;
    iRead = 0;
    writeAll = 0;
    memSel = 2'b00;
end

always #10 iClk = ~iClk;

initial begin
    // //test ghi data vao tat ca mem
    // #100;
    // iAddr = 8'd31;
    // iWrData = 8'd42;
    // iWrite = 1;
    // writeAll = 1;

    // //doc data tu tung mem
    // repeat(5) @(posedge iClk);
    // iWrite = 0;
    // writeAll = 0;
    // iRead = 1;
    // memSel = 2'b00; 
    // repeat(2)@(posedge iClk);
    // iRead = 0;
    // repeat(2)@(posedge iClk);
    // iRead = 1;
    // memSel = 2'b01;
    // repeat(2)@(posedge iClk);   
    // iRead = 0;
    // repeat(2)@(posedge iClk);
    // iRead = 1;
    // memSel = 2'b10;
    // repeat(2)@(posedge iClk);
    // iRead = 0;
    // repeat(2)@(posedge iClk);
    // iRead = 1;
    // memSel = 2'b11;
    // repeat(2)@(posedge iClk);
    // iRead = 0;

    //test ghi data vao tung mem
    // repeat(5)@(posedge iClk);
    iAddr = 8'd10;
    iWrData = 8'd20;
    @(posedge iClk);
    iWrite = 1;
    memSel = 2'b00;
    @(posedge iClk);
    iWrite = 0;
    @(posedge iClk);
    iAddr = 8'd15;
    iWrData = 8'd25;
    @(posedge iClk);
    iWrite = 1;
    memSel = 2'b01;
    @(posedge iClk);
    iWrite = 0;
    @(posedge iClk);
    iAddr = 8'd20;
    iWrData = 8'd30;
    @(posedge iClk);
    iWrite = 1;
    memSel = 2'b10;
    @(posedge iClk);
    iWrite = 0;
    @(posedge iClk);
    iAddr = 8'd25;
    iWrData = 8'd35;
    @(posedge iClk);
    iWrite = 1;
    memSel = 2'b11;
    @(posedge iClk);
    iWrite = 0;

    //doc data tu tung mem
    repeat(5) @(posedge iClk);
    iRead = 1;
    memSel = 2'b00; 
    iAddr = 8'd10;
    repeat(2)@(posedge iClk);
    iRead = 0;
    iAddr = 8'd15;
    @(posedge iClk);
    iRead = 1;
    memSel = 2'b01;
    repeat(2)@(posedge iClk);   
    iRead = 0;
    iAddr = 8'd20;
    repeat(2)@(posedge iClk);
    iRead = 1;
    memSel = 2'b10;
    repeat(2)@(posedge iClk);
    iRead = 0;
    iAddr = 8'd25;
    @(posedge iClk);
    iRead = 1;
    memSel = 2'b11;
    repeat(2)@(posedge iClk);
    iRead = 0;
    #100;
    $finish;

end

endmodule