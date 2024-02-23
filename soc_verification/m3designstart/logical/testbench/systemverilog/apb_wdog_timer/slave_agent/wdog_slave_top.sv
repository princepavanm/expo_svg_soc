class slave_agent_top extends uvm_env;
`uvm_component_utils(slave_agent_top)
slave_agent agent_h[];
env_config m_cfg;
extern function new(string name="slave_agent_top",uvm_component parent);
extern function void build_phase(uvm_phase phase);
endclass

function slave_agent_top:: new(string name="slave_agent_top",uvm_component parent);
super.new(name,parent);
endfunction

function void slave_agent_top::build_phase(uvm_phase phase);
if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
	`uvm_fatal("slave DRIVER","Unable to get slave config in driver")
agent_h=new[m_cfg.has_slave_agent];
	foreach(agent_h[i])
	agent_h[i]=slave_agent::type_id::create($sformatf("agent_h[%0d]",i),this);

endfunction
