package states;

import attacks.UnivAttack;
import enemies.Enemy;
import enemies.biker.Biker;
import entities.CamTarget;
import entities.Effects;
import entities.Player;
import entities.Ship;
import factories.EffectFactory;
import factories.LevelFactory;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint.FlxCallbackPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import hud.Crosshair;
import hud.HUD;
import inputhelper.InputHelper;
import levels.Level;
import levels.Wave;
import signal.ISignal;

enum LevelState {
	PLAYING;
	VICTORY;
	LOSS;
}

/**
 * ...
 * @author Dave
 */
class GameState extends FlxState 
{

	var bg1:FlxBackdrop;
	var bg2:FlxBackdrop;
	var bg3:FlxBackdrop;
	
	public var camTarget:CamTarget;
	public var crosshair:FlxSprite;
	
	public var p(default, null):Player;
	var parm:FlxSprite;
	var pshield:FlxSprite;
	public var ship(default, null):Ship;
	
	public var hud:HUD;
	var playerAttacks:FlxTypedGroup<UnivAttack>;
	var enemyAttacks:FlxTypedGroup<UnivAttack>;
	
	public var enemies:FlxTypedGroup<Enemy>;
	var effects:FlxTypedGroup<Effects>;
	var bgeffects:FlxTypedGroup<Effects>;
	var fgeffects:FlxTypedGroup<Effects>;
	
	public var signalable:Array<ISignal>;
	
	var levelTime:Float = 0;
	var levelStep:Int = 0;
	var levelTimer:FlxTimer;
	
	var currentLevel:Level;
	
	public var state:LevelState = LevelState.PLAYING;
	var cutsceneManager:CutsceneManager;
	
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		currentLevel = H.currentLevel;
		MM.play(MM.MusicTypes.BATTLE);
		H.registerGameState(this);
		createGroups();
		FlxG.worldBounds.set(0, 0, H.LEVEL_SIZE, H.LEVEL_SIZE);
		createBG();
		createPlayer();
		createHUD();
		camTarget = new CamTarget();
		FlxG.mouse.visible = false;
		FlxG.camera.follow(camTarget, FlxCameraFollowStyle.LOCKON );
		FlxG.camera.setScrollBoundsRect(0, 0, H.LEVEL_SIZE, H.LEVEL_SIZE);
		FlxG.watch.add(p, 'acceleration');
		addToScene();
		
		levelTimer = new FlxTimer();
		
		
		toggleTimer();
	}
	
	
	
	private function toggleTimer(on:Bool = true) {
		
		if (on) {
			levelTimer.start(1, levelTimeStep, 0);
		} else {
			levelTimer.active = false;
		}
	}
	
	private function createHUD() {
		crosshair = new Crosshair();
		hud = new hud.HUD();
		signalable.push(hud);
		
	}
	
	/**
	 * This gets called every second by the levelTimer.
	 * @param	_
	 */
	private function levelTimeStep(_) {
		levelStep++;
		currentLevel.advanceTime(levelStep);
		
	}
	
	private function createGroups() {
		
		signalable = [];
		cutsceneManager = new CutsceneManager();
		signalable.push(cutsceneManager);
		playerAttacks = new FlxTypedGroup<UnivAttack>();
		enemyAttacks = new FlxTypedGroup<UnivAttack>();
		effects = new FlxTypedGroup<Effects>();
		EffectFactory.registerEffects(effects);
		fgeffects = new FlxTypedGroup<Effects>();
		EffectFactory.registerFgEffects(fgeffects);
		enemies = new FlxTypedGroup<Enemy>();

		FlxG.watch.add(enemies, 'length', 'Enemy Count:');
		FlxG.watch.add(playerAttacks, 'length', 'Player shots:');
	}
	
	private function addToScene() {
		add(effects);
		add(ship);
		add(parm);
		add(enemies);
		add(p);
		add(pshield);

		add(playerAttacks);
		add(enemyAttacks);
		add(hud);
		add(crosshair);
		add(fgeffects);
		
	}
	private function createPlayer(){
		p = new Player();
		p.setPosition(1000, 1000);
		
		
		parm = new FlxSprite();
		parm.frames = H.getFrames();
		parm.animation.frameName = 'player_arm_0';
		parm.setSize(32, 32);
		parm.centerOffsets();
		parm.centerOrigin();
		parm.setPosition(p.x, p.y);
		p.registerArm(parm);

		
		pshield = new FlxSprite();
		pshield.frames = H.getFrames();
		pshield.animation.addByPrefix('shield', 'player_shield_', 30, false);
		pshield.animation.play('shield');
		pshield.setSize(64, 64);
		pshield.centerOffsets();
		p.registeShield(pshield);

		signalable.push(p);
		
		ship = new Ship();
		ship.reset(H.LEVEL_SIZE/2 - ship.width/2, H.LEVEL_SIZE/2 - ship.height/2);
		ship.toggleThrust();
		signalable.push(ship);
		
		
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
	
	private function victory() {
		trace('WIN!');
		H.signalAll('victory');
		state = LevelState.VICTORY;
		FlxSpriteUtil.fadeOut(crosshair, .5);
		FlxTween.tween(camTarget, {x:p.x, y:p.y}, .3, {ease:FlxEase.quadInOut, onComplete: function (_) {FlxG.camera.follow(p); }});
	}
	
	override public function update(elapsed:Float):Void 
	{
		//Be careful with pausing.  
		levelTime += elapsed;
		if(state == LevelState.PLAYING)
			hud.updateShipSticker(levelTime, currentLevel.totalTime);
		
		if (levelTime >= currentLevel.totalTime && state == LevelState.PLAYING) {
			victory();
		}
		
		InputHelper.updateKeys();
		
		if (state == LevelState.PLAYING){
			FlxG.overlap(enemies, playerAttacks, enemyHitByAttack);
			FlxG.overlap(ship, enemyAttacks, shipHitByAttack);
			FlxG.overlap(p, enemyAttacks, playerHitByAttack);
			
		}
		
		super.update(elapsed);
		if (state == LevelState.PLAYING) {
			if (InputHelper.isButtonJustPressed('weaponup'))
				hud.weaponUp();
			if (InputHelper.isButtonJustPressed('weapondown'))
				hud.weaponDown();
			
			hud.update(elapsed);
			var pos = FlxG.mouse.getPosition();
			camTarget.x = (p.x + pos.x)/2;
			camTarget.y = (p.y + pos.y) / 2;
		}
		#if debug
		if (FlxG.keys.justPressed.L) {
			spawnTestWave();
		}
		#end
	}
	
	private function spawnTestWave() {
		var wave = new Wave(1, 3, EnemyTypes.BIKER);
		wave.pickRandomLocation();
		var es = wave.spawnWave();
		for (e in es)
			enemies.add(e);
	}
	
	
	/**
	 * Gets the first available player attack or creates a new one if one is not available.
	 * @return	A player attack.
	 */
	public function getPlayerAttack():UnivAttack {
		var a = playerAttacks.getFirstAvailable();
		if (a == null) {
			a = new UnivAttack();
			playerAttacks.add(a);
		}
		return a;
	}

	public function getEnemyAttack():UnivAttack {
		var a = enemyAttacks.getFirstAvailable();
		if (a == null) {
			a = new UnivAttack();
			enemyAttacks.add(a);
		}
		return a;
	}
	
	public function enemyHitByAttack(e:Enemy, a:UnivAttack) {
		if (!a.alive || !e.alive)
			return;
		a.hitEntity(e);
		e.getSignal('hit', a);
	}
	public function shipHitByAttack(s:Ship, a:UnivAttack) {
		if (!a.alive || !s.alive)
			return;
		if (!a.hitShip)
		return;
		a.hitEntity(s);
		//Signal the ship that it was hit by an attack
		s.getSignal('hit', a);
	}
	
	public function playerHitByAttack(p:Player, a:UnivAttack) {
		if (!a.alive)
			return;
		a.hitEntity(p);
		if (a.hitPlayer && !FlxSpriteUtil.isFlickering(p)) {
			p.getSignal('stun', a);
		} else if (!a.hitPlayer) {
			a.hitEntity(p);
			p.getSignal('shield');
		}
			
	}
	
	private function updateMap() {
		
	}
}