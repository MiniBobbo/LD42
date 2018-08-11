package signal;

/**
 * @author Dave
 */
interface ISignal 
{
	public function getSignal(signal:String, ?data:Dynamic):Void;
}