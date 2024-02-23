
GLS=0
GUI=0
GUI_OPTS=" "

#Directory path
MODULE_PATH = ../../APB_WATCHDOG
TEST_NAME= test_phase_jumping
SEED = 1
DUMP_OPTS = VCD_ON  ## [VCD_ON, VCD_OFF]
ASSERT_OPTS = ASSERT_OFF  ## [ASSERT_ON, ASSERT_OFF]

ifeq ($(GLS),0)
#RTL files path
	DUT_DIR = $(MODULE_PATH)/rtl
	DUT_files = $(MODULE_PATH)/rtl/cmsdk_apb_watchdog.v
else
#NETLIST files
	DUT_DIR = $(MODULE_PATH)/gates
	DUT_files = $(MODULE_PATH)/gates/UART_synth.v
endif

ifeq ($(GUI),0)
	GUI_OPTS=" "
else
	GUI_OPTS=+gui
endif

TB_DIR = $(MODULE_PATH)/tb
SV_DIR = $(MODULE_PATH)/tb/sv
TEST_DIR = $(MODULE_PATH)/tests
LOG_DIR = $(MODULE_PATH)/sim/logs
COV_DIR = $(MODULE_PATH)/sim/coverage

#TOP FILE
TOP_TB_file=$(TB_DIR)/top/top.sv

#package incluude
PKG_file=$(SV_DIR)/apb_watchdog_pkg.sv

#including RTL and TB directries
INC_DIR = +incdir+$(DUT_DIR) +incdir+$(TB_DIR) +incdir+$(SV_DIR) +incdir+$(SV_DIR)/master_agent +incdir+$(SV_DIR)/slave_agent +incdir+$(SV_DIR)/reset_agent +incdir+$(TB_DIR)/top +incdir+$(TEST_DIR) +incdir+$(LOG_DIR) +incdir+$(COV_DIR)


#compilation with seed operation
comp = ncverilog +access+rwc -uvm -gui -seed $(SEED) +define+$(DUMP_OPTS) +define+$(ASSERT_OPTS) $(DUT_files) $(INC_DIR) $(PKG_file) $(TOP_TB_file)
comp_cov = ncverilog +access+rwc -uvm -coverage all +define+$(DUMP_OPTS) +define+$(ASSERT_OPTS) -seed $(SEED) $(DUT_files) $(INC_DIR) $(PKG_file) $(TOP_TB_file)

phase_cov = ncverilog +access+rwc -uvm -coverage all  +define+$(DUMP_OPTS) +define+$(ASSERT_OPTS) -seed $(SEED) $(DUT_files) $(INC_DIR) $(PKG_file) $(TOP_TB_file)

## compile and run the test cases
#################################
comp_run: clean_test
	mkdir $(LOG_DIR)/$(TEST_NAME)_$(SEED);
	$(comp) $(GUI_OPTS) +UVM_VERBOSITY=UVM_MEDIUM +UVM_TESTNAME=$(TEST_NAME) -l $(LOG_DIR)/$(TEST_NAME)_$(SEED)/$(TEST_NAME)_$(SEED).log;
	\mv -f *.vcd $(LOG_DIR)/$(TEST_NAME)_$(SEED)/

## compile and run the test cases with Coverage ON
comp_run_cov: clean_test
	mkdir $(LOG_DIR)/$(TEST_NAME)_$(SEED);
	$(comp_cov) $(GUI_OPTS) +UVM_VERBOSITY=UVM_MEDIUM +define+original +UVM_TESTNAME=$(TEST_NAME) -l $(LOG_DIR)/$(TEST_NAME)_$(SEED)/$(TEST_NAME)_$(SEED).log;
	mv -f cov_work $(LOG_DIR)/$(TEST_NAME)_$(SEED);
	\mv -f *.vcd $(LOG_DIR)/$(TEST_NAME)_$(SEED)/

run_phase: clean_test
	mkdir $(LOG_DIR)/$(TEST_NAME)_$(SEED);
	$(comp_cov) +UVM_VERBOSITY=UVM_MEDIUM +UVM_TESTNAME=$(TEST_NAME) -l $(LOG_DIR)/$(TEST_NAME)_$(SEED)/$(TEST_NAME)_$(SEED).log;
	mv -f cov_work $(LOG_DIR)/$(TEST_NAME)_$(SEED);
	\mv -f *.vcd $(LOG_DIR)/$(TEST_NAME)_$(SEED)/


## Coverage analysis and merge ptions 
#####################################
cover_gui: 
	imc -gui &

cover_merge:
	imc -exec test.cmd ; mv cov_work *.key *.log ./coverage

## html report generation automation is pending 

check_results:
	cd ../scripts; perl check_results.pl > results.txt; mv results.txt ../sim; cd ../sim; gvim results.txt


clean_test:
	rm -rf *.err cov_work INCA_libs *.dsn *.trn *.log *.vcd $(LOG_DIR)/$(TEST_NAME)_$(SEED) 

clean_all:
	rm -rf *.err cov_work INCA_libs *.dsn *.trn *.log *.vcd $(LOG_DIR)/* $(COV_DIR)/*
#################################################################

