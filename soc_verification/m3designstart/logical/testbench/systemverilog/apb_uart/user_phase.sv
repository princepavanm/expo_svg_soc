// 2) Define the user-defined phase class (boilerplate code)
typedef class env_parent;
class training_phase extends uvm_task_phase; // User-defined phase class 

	static local training_phase m_singleton_inst;

	protected function new (string name ="training_phase");
		super.new(name);
	endfunction

// Define a static function to return a singleton instance of this class
// Will be called below to identify the phase when inserting it into a schedule
	static function training_phase get;
		if (m_singleton_inst == null)
			m_singleton_inst = new("training_phase");
			return m_singleton_inst;
		endfunction

// A phase is a function with behavior defined by its exec_task method
// exec_task is called implicitly when the phase is entered (depending on the schedule)
	task exec_task(uvm_component comp,uvm_phase phase);
		env_parent e;
		if ($cast(e, comp))
		e.training_phase(phase); // Call the overridden user-defined phase task
		`uvm_info("USER DEFINED PHASE","training phase[USER DEFINED PHASE] entering",UVM_MEDIUM)
	endtask 
endclass
