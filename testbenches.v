

 /*
   #################################################################################
   TEST 1 no icw3(no casc) , automatic ,fully  nested , skip ocw2 ,read mask ,read irr
   ###################################################################################
   */
module testbench1();
   reg [7:0] DataTopic,DataFromPic,irr;
   reg rd ,wr,A0,cs,En,INTA;
   wire INT;
   wire[7:0]DataWire;

   always @(DataWire)begin
      if(wr ==1)
      DataFromPic = DataWire;
   end

   assign DataWire = (wr ==0 && cs ==0)? DataTopic : 'bzzzzzzzz;

  
    initial begin
         $monitor("INOUT: DataWire:%b\nINPUT:    DataIn:%b ,irr:%b ,rd:%b,wr:%b ,cs:%b, A0:%b \nOUTPUT:    DataOut:%b ,INT:%b\n",DataWire,DataTopic,irr,rd, wr,cs, A0,DataFromPic , INT);
        INTA = 1 ; 
        irr= 0;
        wr<=1 ;
        cs <=1;
        rd <=1;
        // sendtopiccc = 'b10;
        
        #100//send icw1 (no icw3 bas fih icw4 )
        $display("\nsend icw1 with level trigger mode &single mode:");
        DataTopic <= 'b0000011011;
        wr<=0 ;
        cs <=0;
        A0 <=0;

        //icw2 for the data vector and will concatenate 01010 with the number of 
        
        #100   
        
        wr=1 ;
        cs =1;
    
        #100
        $display("\nsend icw2(for the data vector and will concatenate 01110 with the number of bit)");
        wr<=0 ;
        cs <=0;
        A0 <=1;
        DataTopic <= 'b01110101;

        #100
         wr<=1 ;
        cs <=1;
       

         #100 //icw4 (auto)
        $display("\nsend icw4 with automatic mode:");
        DataTopic <= 'b00000010;
        wr<=0 ;
        cs <=0;
        A0 <=1;
        
        #100   
        wr<=1 ;
        cs <=1;

        #100  //ocw1 set mask  (bit 1,6,7 ignored)
        $display("\nSend ocw1 to set mask :(ignoring irr[1]&irr[6]&irr[7])");
        wr<=0 ;
        cs <=0;
        A0 <=1;
        DataTopic <= 'b11000010;

         #100
         wr<=1 ;
        cs <=1;

 
        
        #100  //ocw3 
        $display("\n OCW3 : to read irr when read signal comes:");
        wr<=0 ;
        cs <=0;
        A0 <=0;
        DataTopic <= 'b00001010;
        

         #100
         $display("\nsend impulses from i/o devices :");
         wr<=1 ;
         cs <=1;
         irr <= 'b10010110;
        #100
        irr <= 0;

        #100
        $display("\nsend read signal with A0 = 0 & RR_RIS = 10 .so it will send the irr to the cpu");
         cs <=0;
         rd<=0;

         #100
         cs <=1;
         rd<=1;

        //impulse1
         #100
         $display("\nimpulse 1 came:");
         INTA = 0;
         #100
         INTA = 1 ;


         
        #100
        $display("\nsend read signal with A0 = 0 & RR_RIS = 10 .so it will send the irr to the cpu after sending impulse1 and updating inner irr reg : ");
         cs <=0;
         rd<=0;
   
         #100
         cs <=1;
         rd<=1;
       
        //impulse 2
         #100
        $display("\nimpulse 2 came: so the vector of service routiene should be sent as an output  ");
         INTA = 0;
         #100
         INTA = 1 ;

          //impulse1
         #100
         $display("\nimpulse 1 came:");
         INTA = 0;
         #100
         INTA = 1 ;


         
        #100
        $display("\nsend read signal with A0 = 0 & RR_RIS = 10 .so it will send the IRR register after being updated to the cpu ");
         cs <=0;
         rd<=0;

         #100
         cs <=1;
         rd<=1;
       
        //impulse 2
         #100
        $display("\nimpulse 2 came: so the vector of service routiene should be sent as an output  ");
         INTA = 0;
         #100
         INTA = 1 ;
         

        #100 
        $display("send read signal to show the mask "); 
        A0<=1;
        cs <=0;
        rd<=0;
         
     end
   
   PIC pic1(,DataWire,rd ,wr,A0,cs,En,INTA,irr,INT);

 
endmodule

/*
   #################################################################################
   TEST 2 no icw1(no casc , no icw3 ,no icw4) , not auto  ,rotational ,read isr
   ###################################################################################
   */
module testbench2();
   reg [7:0] DataTopic,DataFromPic,irr;
   reg rd ,wr,A0,cs,En,INTA;
   wire INT;
   wire[7:0]DataWire;

   always @(DataWire)begin
      if(wr ==1)
      DataFromPic = DataWire;
   end

   assign DataWire = (wr ==0 && cs ==0)? DataTopic : 'bzzzzzzzz;

    
   initial begin 
     $monitor("INOUT: DataWire:%b\nINPUT:    DataIn:%b ,irr:%b ,rd:%b,wr:%b ,cs:%b, A0:%b \nOUTPUT:    DataOut:%b ,INT:%b\n",DataWire,DataTopic,irr,rd, wr,cs, A0,DataFromPic,INT);
        INTA = 1 ; 
        irr= 0;
        wr<=1 ;
        cs <=1;
        rd <=1;
        
        #100//send icw1 (no icw3 bas fih icw4 )
        $display("\nsend icw1 with edge trigger mode &single mode:");
        DataTopic <= 'b0000010010;
        wr<=0 ;
        cs <=0;
        A0 <=0;

          //icw2 for the data vector and will concatenate 01010 with the number of 
        
        #100   
        
        wr=1 ;
        cs =1;

        #100
        $display("\nsend icw2(for the data vector and will concatenate 01110 with the number of bit)");
        wr<=0 ;
        cs <=0;
        A0 <=1;
        DataTopic <= 'b01110101;

        #100
         wr<=1 ;
        cs <=1;
 

        #100  //ocw1 set mask  (no masks )
        $display("\nSend ocw1 to set mask :(no masks)");
        wr<=0 ;
        cs <=0;
        A0 <=1;
        DataTopic <= 'b00000000;

         #100
         wr<=1 ;
        cs <=1;
      //   Datain <= 'bxxxxxxxx;

 
        
        #100  //ocw3 
        $display("\n OCW3 : to read isr when read signal comes:where RR_RIS =11 to read isr");
        wr<=0 ;
        cs <=0;
        A0 <=0;
        DataTopic <= 'b00001011;

         #100
         wr<=1 ;
        cs <=1;
      //   Datain <= 'bxxxxxxxx;

 
        
        #100  //ocw2
        $display("\n OCW2 : to allow the automatic rotating priority mode ");
        wr<=0 ;
        cs <=0;
        A0 <=0;
        DataTopic <= 'b10000000;
         #100
        wr<=1 ;
        cs <=1;
        irr<= 8'b00010010;
      //   Datain <= 'bxxxxxxxx;

        //impulse1
         #100
         $display("\nimpulse 1 came:");
         irr=0;
         INTA = 0;
         #100
         INTA = 1 ;

           
        //impulse 2
         #100
        $display("\nimpulse 2 came: so the vector of service routiene should be sent as an output  ");
         INTA = 0;

         #100
         INTA = 1 ;
         $display("\nsend read signal .so it will send the ISR to make sure that the isr and the IRR\nhaven't changed AND WAIT FOR OCW2");
         cs <=0;
         rd<=0;
         #100
         cs <=1;
         rd<=1;

         #100  //ocw2 3ashan ne2fel el interupt
        $display("\n OCW2 :to end the interrupt ");
        wr<=0 ;
        cs <=0;
        A0 <=0;
        DataTopic <= 'b10100000;
         #100
        wr<=1 ;
        cs <=1;
      //   Datain <= 'bxxxxxxxx;

         #100
         $display("\nsend read signal .to read ISR after sending ocw2 to end the interupt");
         cs <=0;
         rd<=0;
         #100
         cs <=1;
         rd<=1;
         
         #100
         $display("\nupdate irr by sending impulse at irr[0],to test the priority of the rotating mode(this bit will have a low priority)");
         irr=1;
         #100 
         irr = 0;

        //impulse1
         #100
         $display("\nimpulse 1 came:");
         irr=0;
         INTA = 0;
         #100
         INTA = 1 ;

           
        //impulse 2
         #100
        $display("\nimpulse 2 came: so the vector of service routiene should be sent as an output  ");
         INTA = 0;

         #100
         INTA = 1 ;
         $display("\nsend read signal .so it will send the ISR to make sure that the isr and the IRR\nhaven't changed AND WAIT FOR OCW2");
         cs <=0;
         rd<=0;

         #100
        cs <=1;
         rd<=1;
        #100  //ocw2 3ashan ne2fel el interupt
        $display("\n OCW2 :to end the interrupt ");
        wr<=0 ;
        cs <=0;
        A0 <=0;
         DataTopic <= 'b10100000;
   end

   PIC pic2(,DataWire,rd ,wr,A0,cs,En,INTA,irr,INT);

endmodule


/*
   #################################################################################
   TEST 3: Cascading: icw1(casc , no icw3 ,icw4) , auto  ,fully nested
   ###################################################################################
   */

module testbench3();
  
  reg [7:0] Datain,mirr,sirr;
  reg rd ,wr,A0,mcs,scs,mEn,sEn,INTA;
  wire mINT,sINT;
  wire[7:0]DataWire;

  assign DataWire = (wr ==0 && (mcs ==0 || scs==0))? Datain : 'bzzzzzzzz;

  wire[2:0] CASC;


  initial begin
        $monitor("INOUT: DataWire:%b\nINPUT:    DataIn:%b ,SLAVEirr:%b,   MASTERirr:%b \n  rd:%b,  wr:%b ,  scs:%b,  mcs:%b, A0:%b \nOUTPUT:    DataOut:%b ,   slaveINT:%b,    masterINT:%b\nCascadingLines:%b \n",DataWire,Datain,sirr,mirr,rd, wr,scs,mcs, A0,DataWire,sINT,mINT,CASC);
        INTA = 1 ; 
        sirr= 0;
        wr<=1 ;
        mcs <=1;
        rd <=1;
        mEn = 1;
        sEn =0 ;

        //initializing the master
        #100//send icw1 (no icw3 bas fih icw4 )
        $display("\n(MASTER)send icw1 with level sensing mode &single mode:");
        Datain <= 'b00011001;
        wr<=0 ;
        mcs <=0;
        A0 <=0;

        //icw2 for the data vector and will concatenate 01010 with the number of 
        
        #100   
        
        wr<=1 ;
        mcs<=1;

        #100
        $display("\n(MASTER)send icw2(for the data vector and will concatenate 01110 with the number of bit)");
        wr<=0 ;
        mcs <=0;
        A0 <=1;
        Datain <= 'b01110101;

        #100
         wr<=1 ;
        mcs <=1;

        #100
         $display("\n(MASTER)send icw3");
        wr<=0 ;
        mcs <=0;
        A0 <=1;
        Datain <= 'b11111111;

         #100
         wr<=1 ;
        mcs <=1;

         #100 //icw4 (auto)
        $display("\n(MASTER)send icw4 with automatic mode:");
        Datain <= 'b00000010;
        wr<=0 ;
        mcs <=0;
        A0 <=1;
        
        #100   
        wr<=1 ;
        mcs <=1;

         #100  
        $display("\n(MASTER)Send ocw1 to set mask :no masking for master)");
        wr<=0 ;
        mcs <=0;
        A0 <=1;
        Datain <= 'b00000000;

         #100
         wr<=1 ;
        mcs <=1;

        //initializing the slave
        #100//send icw1 (no icw3 bas fih icw4 )
        $display("\n(SLAVE)send icw1 with level sensing mode &single mode:");
        Datain <= 'b00011001;
        wr<=0 ;
        scs <=0;
        A0 <=0;


        
        #100   
        
        wr<=1 ;
        scs<=1;

        #100
        $display("\n(SLAVE)send icw2(for the data vector and will concatenate 01110 with the number of bit)");
        wr<=0 ;
        scs <=0;
        A0 <=1;
        Datain <= 'b01110101;

        #100
         wr<=1 ;
        scs <=1;


        #100
         $display("\n(SLAVE)send icw3");
        wr<=0 ;
        scs <=0;
        A0 <=1;
        Datain <= 'b00000001;

         #100
         wr<=1 ;
        scs <=1;

         #100 //icw4 (auto)
        $display("\n(SLAVE)send icw4 with automatic mode:");
        Datain <= 'b00000010;
        wr<=0 ;
        scs <=0;
        A0 <=1;
        
        #100   
        wr<=1 ;
        scs <=1;

         #100  
        $display("\n(SLAVE)Send ocw1 to set mask :no masking");
        wr<=0 ;
        scs <=0;
        A0 <=1;
        Datain <= 'b00000000;

         #100
         wr<=1 ;
        scs <=1;
        
        #100
        $display("\n(SLAVE)Interrupt on bit no 1 in slave");
        sirr <='b00000010;

        #100
        sirr <='b00000000;

        #100
         $display("\nImpulse 1 came:");
        INTA<=0;

        #100
        INTA<=1;

        #100
        $display("\nImpulse 2 came: so the vector of service routiene (SLAVE) should be sent as an output");
        INTA<=0;

        #100
        INTA<=1;


   end

  always @(sINT)begin
    mirr[1] <= sINT;
   end

 
   PIC master(CASC ,DataWire,rd ,wr,A0,mcs,mEn,INTA,mirr,mINT);
   PIC slave(CASC ,DataWire,rd ,wr,A0,scs,sEn,INTA,sirr,sINT);   

endmodule
