module PIC(/*inout [7:0]Dpic ,***********/inout [2:0]caspic, inout [7:0]D , input RDpic,WRpic,A0pic,CSpic,Enpic,INTApic,[7:0]irrpic  ,output INTpic );

    wire [7:0]datafromPrToRW ;
    wire Readd,endOfinitPic, intreqFromPrToControl;
    wire [7:0]datafromRWToControl;
    wire [4:1]ICWSpic;
    wire [3:1]OCWspic;
    wire imp1pic,imp2pic,endOfimp2pic,AEOIpic;
    wire[4:0]beginOfvectorAdresspic;
    wire[7:0]maskPic; 
    wire[1:0]RR_RISpic;
    wire [2:0]R_SL_EOIpic;
    wire OCW2isSentpic;
    wire endOfimp1pic;
    wire SNGLpic ; 
    wire [7:0]ICW3wordpic ; 

    
    RWModule RWinst (RDpic ,WRpic,A0pic,CSpic,
                datafromPrToRW,D,Readd,datafromRWToControl,
                ICWSpic,OCWspic,endOfinitPic);
    ControlLogic CLinst (A0pic,INTApic, intreqFromPrToControl,
                    ICWSpic,OCWspic,
                    datafromRWToControl, imp1pic,imp2pic,endOfimp2pic,INTpic,
                    AEOIpic,beginOfvectorAdresspic,maskPic,
                    RR_RISpic,R_SL_EOIpic,OCW2isSentpic,endOfimp1pic,
                    SNGLpic,LTIM,ICW3wordpic);

    PR PRinst (endOfinitPic,A0pic,Readd,
                irrpic,maskPic,R_SL_EOIpic,
                RR_RISpic,imp1pic,imp2pic,endOfimp2pic,endOfimp1pic,
                OCW2isSentpic,AEOIpic,beginOfvectorAdresspic,intreqFromPrToControl,
                datafromPrToRW,caspic,Enpic,SNGLpic,LTIM,ICW3wordpic);
    
endmodule
