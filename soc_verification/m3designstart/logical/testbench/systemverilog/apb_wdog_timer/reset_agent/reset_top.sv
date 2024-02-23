class reset_agent_top extends uvm_env;
	`uvm_component_utils(reset_agent_top)
	reset_agent agent_h[];
	env_config m_cfg;
	
	extern function new(string name="reset_agent_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
endclass

function reset_agent_top:: new(string name="reset_agent_top",uvm_component parent);
	super.new(name,parent);
endfunction

function void reset_agent_top::build_phase(uvm_phase phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
		`uvm_fatal("MASTER DRIVER","Unable to get reset config in driver")
	agent_h=new[m_cfg.has_reset_agent];
	foreach(agent_h[i])
	agent_h[i]=reset_agent::type_id::create($sformatf("agent_h[%0d]",i),this);

endfunction
