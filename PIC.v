module PIC(inout [2:0]cas, inout [7:0]D , input rd,wr,A0,cs,En,INTA,[7:0]irr  ,output INT );

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

    
    RWModule RWinst (rd ,wr,A0,cs,
                datafromPrToRW,D,Readd,datafromRWToControl,
                ICWSpic,OCWspic,endOfinitPic);
    ControlLogic CLinst (A0,INTA, intreqFromPrToControl,
                    ICWSpic,OCWspic,
                    datafromRWToControl, imp1pic,imp2pic,endOfimp2pic,INT,
                    AEOIpic,beginOfvectorAdresspic,maskPic,
                    RR_RISpic,R_SL_EOIpic,OCW2isSentpic,endOfimp1pic,
                    SNGLpic,LTIM,ICW3wordpic);

    PR PRinst (endOfinitPic,A0,Readd,
                irr,maskPic,R_SL_EOIpic,
                RR_RISpic,imp1pic,imp2pic,endOfimp2pic,endOfimp1pic,
                OCW2isSentpic,AEOIpic,beginOfvectorAdresspic,intreqFromPrToControl,
                datafromPrToRW,cas,En,SNGLpic,LTIM,ICW3wordpic);
    
endmodule
