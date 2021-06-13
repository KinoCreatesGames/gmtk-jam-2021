package game.char;

import flixel.FlxObject;

class Player extends Actor {
	var state:State;

	public static inline var GRAVITY:Float = 100;
	public static inline var INVINCIBLE_TIME:Float = 1.5;

	public function new(x:Float, y:Float, ?actorData:ActorData) {
		super(x, y, actorData);
		this.drag.x = 600; // need to apply drag so that when velocity is 0
		// Player doesn't keep moving
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
		if (canWalk) {
			state.currentState = moving;
		}
	}

	function moving(elapsed:Float) {
		animation.play('run');
		if (canWalk == false) {
			this.velocity.set(0, 0);
			this.drag.x = 600;
			state.currentState = idle;
		} else {
			this.velocity.x = this.spd;
			this.drag.x = 0;
		}
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