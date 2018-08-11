package fsm;
import haxe.ds.StringMap;

/**
 * ...
 * @author Dave
 */
class FSM 
{
	var stateMap:StringMap<FSMModule>;
	var entity:IFSM;
	public var currentModule(default, null):FSMModule;
	public var currentModuleName(default, null):String;
	public var skipModule(default, null):Bool = false;
	
	
	public function new(entity:IFSM) 
	{
		this.entity = entity;
		stateMap = new StringMap<FSMModule>();
	}
	
	/**
	 * Calls the update function on the current module unless hold() was called.
	 * @param	dt		Elapsed time since the last call
	 */
	public function update(dt:Float) {
		if (currentModule != null && !skipModule)
			currentModule.update(dt);
	}
	
	public function hold() {
		skipModule = true;
	}
	
	public function resume() {
		skipModule = false;
	}
	public function addtoMap(key:String, module:FSMModule) {
		stateMap.set(key, module);
	}
	
	public function changeState(key:String) {
		if (key == 'none')
			currentModule = null;
		if (!stateMap.exists(key))
			return;
		if (currentModule != null)
			currentModule.changeFrom();
		currentModule = stateMap.get(key);
		currentModule.changeTo();
		currentModuleName = key;
	}
	
}