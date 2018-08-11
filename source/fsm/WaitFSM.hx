package fsm;

import flixel.FlxG;
import fsm.FSMModule;
import fsm.IFSM;

/**
 * WaitFSM is a generic waiting module.  It waits a specified time and then calls another fsm module on the parent. 
 * @author Dave
 */
class WaitFSM extends FSMModule 
{
	
	var WAIT_TIME:Float = 1.5;
	var WAIT_VAR:Float = 1;
	var waitTime:Float;
	var NEXT_STATE:Array<String> = [];
	var lastState:String;
	var nextState:String;
	
	public function new(parent:IFSM) 
	{
		super(parent);
	}
	
	public function setWait(waitTime:Float, waitVariableTime:Float = 0) {
		WAIT_TIME = waitTime;
		WAIT_VAR = waitVariableTime;
	}
	
	/**
	 * Adds a new possible state that this state should change to when completed.  A random state will be picked from all the ones supplied.
	 * Call this multiple times to add multiple states.  States added more than once will have a more likely chance to be picked.
	 * @param	nextState	
	 */
	public function addPossibleState(nextState:String) {
		NEXT_STATE.push(nextState);
	}
	
	override public function changeFrom() 
	{
		lastState = nextState;
	}
	
	override public function changeTo() 
	{
		waitTime = WAIT_TIME + FlxG.random.float(0, WAIT_VAR);
	}
	override public function update(dt:Float) 
	{
		waitTime -= dt;
		if (waitTime > 0)
			return;
		
		nextState = NEXT_STATE[FlxG.random.int(0, NEXT_STATE.length - 1)];
		while (nextState == lastState)
			nextState = NEXT_STATE[FlxG.random.int(0, NEXT_STATE.length - 1)];
		
		parent.changeFSM(nextState);
	}
}