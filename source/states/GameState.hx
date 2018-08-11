package states;

import attacks.UnivAttack;
import enemies.Enemy;
import enemies.biker.Biker;
import entities.Effects;
import entities.Player;
import entities.Ship;
import factories.EffectFactory;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint.FlxCallbackPoint;
import flixel.util.FlxColor;
import hud.Crosshair;
import hud.HUD;
import inputhelper.InputHelper;
import levels.Wave;

/**
 * ...
 * @author Dave
 */
class GameState extends FlxState 
{

	var bg1:FlxBackdrop;
	var bg2:FlxBackdrop;
	var bg3:FlxBackdrop;
	
	var camTarget:FlxSprite;
	var crosshair:FlxSprite;
	
	public var p(default, null):Player;
	var parm:FlxSprite;
	public var ship(default, null):Ship;
	
	var hud:HUD;
	var playerAttacks:FlxTypedGroup<UnivAttack>;
	
	var enemies:FlxTypedGroup<Enemy>;
	var effects:FlxTypedGroup<Effects>;
	var bgeffects:FlxTypedGroup<Effects>;
	
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		H.registerGameState(this);
		FlxG.worldBounds.set(0, 0, H.LEVEL_SIZE, H.LEVEL_SIZE);
		createBG();
		
		createPlayer();
		
		createGroups();
		
		createHUD();
		
		camTarget = new FlxSprite(0, 0);
		camTarget.makeGraphic(1, 1, FlxColor.TRANSPARENT);
		FlxG.mouse.visible = false;
		FlxG.camera.follow(camTarget, FlxCameraFollowStyle.LOCKON );
		FlxG.camera.setScrollBoundsRect(0, 0, H.LEVEL_SIZE, H.LEVEL_SIZE);
		FlxG.watch.add(p, 'acceleration');
		addToScene();
	}
	
	private function createHUD() {
		crosshair = new Crosshair();
		hud = new hud.HUD();
		
	}
	
	private function createGroups() {
		playerAttacks = new FlxTypedGroup<UnivAttack>();
		effects = new FlxTypedGroup<Effects>();
		EffectFactory.registerEffects(effects);
		enemies = new FlxTypedGroup<Enemy>();

	}
	
	private function addToScene() {
		add(effects);
		add(ship);
		add(parm);
		add(enemies);
		add(p);

		add(playerAttacks);
		add(hud);
		add(crosshair);
		
	}
	private function createPlayer(){
		p = new Player();
		p.setPosition(200, 200);
		parm = new FlxSprite();
		parm.frames = H.getFrames();
		parm.animation.frameName = 'player_arm_0';
		parm.setSize(32, 32);
		parm.centerOffsets();
		parm.centerOrigin();
		parm.setPosition(p.x, p.y);
		p.registerArm(parm);
		
		
		ship = new Ship();
		ship.reset(H.LEVEL_SIZE/2 - ship.width/2, H.LEVEL_SIZE/2 - ship.height/2);
		ship.toggleThrust();
		
		
	}
	private function createBG() {
		//var bg1 = new FlxBackdrop('assets/images/stars_0.png');
		//bg1.velocity.x = -80;
		//add(bg1);
		//var bg2 = new FlxBackdrop('assets/images/stars_1.png');
		//bg2.velocity.x = -100;
		//add(bg2);
		var bg3 = new FlxBackdrop('assets/images/stars_0.png');
		bg3.y = 30;
		//bg3.scale.set(.5, .5);
		bg3.velocity.x = -540;
		add(bg3);
	}
	
	override public function update(elapsed:Float):Void 
	{
		InputHelper.updateKeys();
		
		FlxG.overlap(enemies, playerAttacks, enemyHitByAttack);
		
		super.update(elapsed);
		hud.update(elapsed);
		var pos = FlxG.mouse.getPosition();
		camTarget.x = (p.x + pos.x)/2;
		camTarget.y = (p.y + pos.y) / 2;
		
		if (FlxG.keys.justPressed.L) {
			spawnTestWave();
		}
	}
	
	private function spawnTestWave() {
		//var b = new Biker();
		//b.reset(100, 100);
		//enemies.add(b);
		
		var wave = new Wave();
		wave.enemyCount = 3;
		wave.enemyType = EnemyTypes.BIKER;
		wave.pickRandomLocation();
		var es = wave.spawnWave();
		for (e in es)
			enemies.add(e);
	}
	
	
	/**
	 * Gets the first available player attack or creates a new one if one is not available.
	 * @return	A new player attack.
	 */
	public function getPlayerAttack():UnivAttack {
		var a = playerAttacks.getFirstAvailable();
		if (a == null) {
			a = new UnivAttack();
			playerAttacks.add(a);
		}
		return a;
	}
	
	public function enemyHitByAttack(e:Enemy, a:UnivAttack) {
		if (!a.alive || !e.alive)
			return;
		a.hitEntity(e);
		e.takeDamage(a.damage);
	}
	
	private function updateMap() {
		
	}
}