package game.char;

import flixel.FlxObject;

class Player extends Actor {
	var state:State;

	public static inline var GRAVITY:Float = 100;
	public static inline var INVINCIBLE_TIME:Float = 1.5;

	public function new(x:Float, y:Float, ?actorData:ActorData) {
		super(x, y, actorData);
		state = new State(idle);
	}

	override function createSprite() {
		loadGraphic(this.data.sprite.assetPath(), true, 24, 24, true);
		animation.add('idle', [0], 12, true);
		animation.add('run', [0, 1, 2], 12, true);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
	}

	function idle(elapsed:Float) {
		animation.play('idle');
	}

	function moving(elapsed:Float) {
		animation.play('run');
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		state.update(elapsed);
		applyPhysics(elapsed);
	}

	function applyPhysics(elapsed:Float) {
		acceleration.y = GRAVITY;
		this.bound();
	}
}