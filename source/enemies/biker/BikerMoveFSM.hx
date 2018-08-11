package enemies.biker;

import fsm.FSMModule;
import fsm.IFSM;

/**
 * ...
 * @author Dave
 */
class BikerMoveFSM extends FSMModule 
{

	
	
	var b:Biker;
	public function new(parent:IFSM) 
	{
		super(parent);
		b = cast parent;
	}
	
	
	
}