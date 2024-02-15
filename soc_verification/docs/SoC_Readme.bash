## README TO SETUP and RUN THE SOC TEST CASES
###################################################
Step 1. Copy from usb driver following two pkgs
     a. cp gcc-arm-none-eabi-7-2017-q4-major /home/SoC   # This is required for ARM gcc compiler 
     b. cp glibc-2.14      /home/SoC                     # ARM gcc compiles only with glibc-2.14 
     c. cp m3designstart   /home/SoC                     # This is ARM delivered SOC environment

Step 2. Build the gcc library 
     a. >cd glibc-2.14 
     b. >mkdir build
     c. >cd build
     d. >../configure --prefix=/opt/glibc-2.14  #may not work, pls ignore this step
     e. >make
     f. >sudo make install

Step 3. update cshrc  
     #Add in /home/cad/cshrc following line to point to latest glibc-2.14
     setenv LD_LIBRARY_PATH /opt/glibc-2.14/lib
     #Add to /home/cad/cshrc following line to point to arm-gcc bin
     setenv ARMGCC /home/gcc-arm-none-eabi-7-2017-q4-major
     #To the line containing set path = ..... add following at the end
     set path = (........  $ARMGCC/bin $path)

step 5. source the EDA license 
     > cd /home/SoC/m3designstart/logical/testbench/execution_tb/
     > csh
     > source /home/cad/cshrc
     > setenv LD_LIBRARY_PATH /opt/glibc-2.14/lib

step 6. Compile the RTL and TB
    >make clean
    >make compile SIMULATOR=ius
    >check for any errors in ius_compile.log

Step 7.  To compile tests 
      >make tests    # This will compile all the tests in the DB

Step 8. Update LD_LIBRARY_PATH
     #To run the tests you need to comment and source /home/cad/cshrc in following way
     #setenv LD_LIBRARY_PATH /opt/glibc-2.14/lib  
     # After commenting 
     > source /home/cad/cshrc
     > make run TESTNAME=hello SIMULATOR=ius
     > make run TESTNAME=uart_tests SIMULATOR=ius 

Step 9. Additional details 
     #To further dive into details of environment,tests, refer the document available in  
     /home/SOC/m3designstart/docs/arm_cortex_m3_designstart_eval_rtl_and_testbench_user_guide_100894_0000_00_en.pdf

Step 10 : Pending tasks
     # Current env runs on obfuscated rtl of cortexm3. Once new server is available we can have Cortex cycle accurate model to run in environment.
     # Explore the design,env and create new testcases.
