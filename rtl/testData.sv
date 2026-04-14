module testData(CLK, nRESET, iWrite, iRead, memSel, writeAll, DATA_EN,
                ADDR_EN, ADDR_RST, gen_Turn, PAT_SEL, data_OUT, W_addr,
                compare_EN, result_comp0, result_comp1, result_comp2, result_comp3,
                captureData, compSel, rstComp);

    input CLK;
    input nRESET;

    input iWrite;
    input iRead;
    input [1:0] memSel;
    input writeAll;

    input DATA_EN;
    input ADDR_EN;
    input ADDR_RST;
    input [3:0] gen_Turn;
    input [2:0] PAT_SEL;
    

    input compare_EN;
    input captureData;
    input [3:0] compSel;
    input rstComp;

    output [7:0] data_OUT;
    output [7:0] W_addr;
    output result_comp0;
    output result_comp1;
    output result_comp2;
    output result_comp3;


    wire [7:0] W_data;
    wire [7:0] expData;


    data_gen u_data_gen0
    (
        .CLK(CLK),
        .nRESET(nRESET),
        .DATA_EN(DATA_EN),
        .gen_Turn(gen_Turn),
        .PAT_SEL(PAT_SEL),
        .DATA_MBIST(W_data),
        .DATA_comp(expData)
    );

    addr_gen u_addr_gen0
    (
        .CLK(CLK),
        .nRESET(nRESET),
        .ADDR_EN(ADDR_EN),
        .ADDR_RST(ADDR_RST),
        .ADDR_MBIST(W_addr),
        .gen_Turn(gen_Turn),
        .PAT_SEL(PAT_SEL)
    );

    comparator u_comparator0
    (   
        .CLK(CLK),
        .nRESET(nRESET),
        .rstComp(rstComp),
        .dataMem(data_OUT),
        .ExpDATA(expData),
        .RESULT(result_comp0),
        .compSel(compSel[0]),
        .captureData(captureData),
        .compare_EN(compare_EN)
    );

    comparator u_comparator1
    (
        .CLK(CLK),
        .nRESET(nRESET),
        .rstComp(rstComp),
        .dataMem(data_OUT),
        .ExpDATA(expData),
        .RESULT(result_comp1),
        .compSel(compSel[1]),
        .captureData(captureData),
        .compare_EN(compare_EN)
    );

    comparator u_comparator2
    (
        .CLK(CLK),
        .nRESET(nRESET),
        .rstComp(rstComp),
        .dataMem(data_OUT),
        .ExpDATA(expData),
        .RESULT(result_comp2),
        .compSel(compSel[2]),
        .captureData(captureData),
        .compare_EN(compare_EN)
    );
    
    comparator u_comparator3
    (
        .CLK(CLK),
        .nRESET(nRESET),
        .rstComp(rstComp),
        .dataMem(data_OUT),
        .ExpDATA(expData),
        .RESULT(result_comp3),
        .compSel(compSel[3]),
        .captureData(captureData),
        .compare_EN(compare_EN)
    );    
    

    memBank u_memBank0
    (.iClk(CLK),
     .iAddr(W_addr),
     .iWrite(iWrite),
     .iWrData(W_data),
     .iRead(iRead),
     .memSel(memSel),
     .writeAll(writeAll),
     .data_OUT(data_OUT));




endmodule