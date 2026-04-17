module topMbist(CLK, nRESET, algr_en, data_OUT, W_addr, 
                result_comp0, result_comp1, result_comp2, result_comp3);

    input CLK;
    input nRESET;
    input algr_en;

    output wire [7:0] data_OUT;
    output wire [7:0] W_addr;
    output wire result_comp0, result_comp1, result_comp2, result_comp3;
    wire [7:0] W_data;
    wire [7:0] expData;
    wire iWrite_reg, iRead_reg, writeAll_reg, DATA_EN_reg, ADDR_EN_reg;
    wire ADDR_RST_reg, compare_EN_reg, captureData_reg, rstComp_reg;
    wire [1:0] memSel_reg;

    wire [3:0] compSel_reg;
    wire [3:0] gen_Turn_reg;
    wire [2:0] PAT_SEL_reg;

mscan mscan(CLK, nRESET, algr_en, data_OUT, W_addr, result_comp0, 
                result_comp1, result_comp2, result_comp3, iWrite_reg, iRead_reg, memSel_reg, writeAll_reg, DATA_EN_reg, ADDR_EN_reg,
                ADDR_RST_reg, gen_Turn_reg, PAT_SEL_reg, compare_EN_reg, captureData_reg, compSel_reg, rstComp_reg);

data_gen u_data_gen0
    (
        .CLK(CLK),
        .nRESET(nRESET),
        .DATA_EN(DATA_EN_reg),
        .gen_Turn(gen_Turn_reg),
        .PAT_SEL(PAT_SEL_reg),
        .DATA_MBIST(W_data),
        .DATA_comp(expData)
    );

    addr_gen u_addr_gen0
    (
        .CLK(CLK),
        .nRESET(nRESET),
        .ADDR_EN(ADDR_EN_reg),
        .ADDR_RST(ADDR_RST_reg),
        .ADDR_MBIST(W_addr),
        .gen_Turn(gen_Turn_reg),
        .PAT_SEL(PAT_SEL_reg)
    );

    comparator u_comparator0
    (   
        .CLK(CLK),
        .nRESET(nRESET),
        .rstComp(rstComp_reg),
        .dataMem(data_OUT),
        .ExpDATA(expData),
        .RESULT(result_comp0),
        .compSel(compSel_reg[0]),
        .captureData(captureData_reg),
        .compare_EN(compare_EN_reg)
    );

    comparator u_comparator1
    (
        .CLK(CLK),
        .nRESET(nRESET),
        .rstComp(rstComp_reg),
        .dataMem(data_OUT),
        .ExpDATA(expData),
        .RESULT(result_comp1),
        .compSel(compSel_reg[1]),
        .captureData(captureData_reg),
        .compare_EN(compare_EN_reg)
    );

    comparator u_comparator2
    (
        .CLK(CLK),
        .nRESET(nRESET),
        .rstComp(rstComp_reg),
        .dataMem(data_OUT),
        .ExpDATA(expData),
        .RESULT(result_comp2),
        .compSel(compSel_reg[2]),
        .captureData(captureData_reg),
        .compare_EN(compare_EN_reg)
    );
    
    comparator u_comparator3
    (
        .CLK(CLK),
        .nRESET(nRESET),
        .rstComp(rstComp_reg),
        .dataMem(data_OUT),
        .ExpDATA(expData),
        .RESULT(result_comp3),
        .compSel(compSel_reg[3]),
        .captureData(captureData_reg),
        .compare_EN(compare_EN_reg)
    );    

    memBank u_memBank0
    (.iClk(CLK),
     .iAddr(W_addr),
     .iWrite(iWrite_reg),
     .iWrData(W_data),
     .iRead(iRead_reg),
     .memSel(memSel_reg),
     .writeAll(writeAll_reg),
     .data_OUT(data_OUT));






endmodule