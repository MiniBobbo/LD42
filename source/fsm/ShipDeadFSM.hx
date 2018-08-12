package fsm;

/**
 * ...
 * @author Dave
 */
class ShipDeadFSM extends FSMModule 
{

	public function new(parent:IFSM) 
	{
		super(parent);
	}
	
	override public function changeTo() 
	{
		H.signalAll('defeat');
	}
	
}