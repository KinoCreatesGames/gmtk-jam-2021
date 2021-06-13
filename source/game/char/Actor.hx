package game.char;

import flixel.FlxObject;
import game.objects.NonSolid;
import game.objects.Fast;
import game.objects.Slow;
import game.objects.Large;
import game.objects.Small;
import game.objects.Walk;
import game.objects.Word;
import game.objects.Jump;
import game.objects.Reverse;

// Note we'll be using tiles so don't go over the tile limit
class Actor extends FlxSprite {
	public var name:String;
	public var data:ActorData;
	public var atk:Int;
	public var def:Int;
	public var spd:Int;
	public var notSolid:Bool = false;
	public var wordModList:Array<Word>;
	public var canWalk:Bool = false;
	public var isReverse:Bool = false;
	public var jumpSound:FlxSound;

	public function new(x:Float, y:Float, ?actorData:ActorData) {
		super(x, y);
		data = actorData;
		notSolid = false;
		wordModList = [];
		jumpSound = FlxG.sound.load(AssetPaths.jump_sound__ogg);
		if (data != null) {
			assignStats();
			createSprite();
		}
	}

	/**
	 * Assigns all the stats that come directly from Depot for each actor.
	 */
	public function assignStats() {
		name = data.name;
		health = data.health;
		// atk = data.atk;
		// def = data.def;
		spd = data.spd;
	}

	/**
	 * Assigns the sprite information and sets up animations for the 
	 * entity.
	 */
	public function createSprite() {}

	public function applyWord(word:Word) {
		if (word != null) {
			this.wordModList.push(word);
			word.allowCollisions = FlxObject.NONE;
			word.visible = false;
			switch (Type.getClass(word)) {
				case Small:

				case Large:

				case Slow:
					this.spd = cast this.spd * .5;
				// this.velocity.x = this.spd * (this.isReverse ? -1 : 1);
				case Fast:
					this.spd = cast this.spd * 1.5;
				// this.velocity.x = this.spd * (this.isReverse ? -1 : 1);
				case Walk:
					canWalk = true;
				case NonSolid:
					this.notSolid = true;
				case Reverse:
					this.isReverse = true;
					facing = FlxObject.LEFT;
					this.spd = this.spd * -1;
					trace(this.spd);
					trace(this.velocity);
				case Jump:
					if (this.isTouching(FlxObject.FLOOR)) {
						this.velocity.y -= 128;
						this.jumpSound.play();
					}
					this.removeWord();
				case _:
					// Do nothing
			}
		}
	}

	public function removeWord() {
		var word = this.wordModList.pop();
		if (word != null) {
			switch (Type.getClass(word)) {
				case Walk:
					canWalk = false;
				case Small:
					this.scale.set(0.5, .5);
					this.updateHitbox();
				case Large:
					this.scale.set(0.5, 0.5);
					this.updateHitbox();
				case Slow:
					this.spd = cast this.spd / .5;
				// this.velocity.x = this.spd * (this.isReverse ? -1 : 1);
				case Fast:
					this.spd = cast this.spd / 1.5;
				// this.velocity.x = this.spd * (this.isReverse ? -1 : 1);
				case NonSolid:
					this.notSolid = false;
				case Reverse:
					this.isReverse = false;
					facing = FlxObject.RIGHT;
					this.spd = this.spd * -1;
				case _:
					// Do nothing
			}

			word.setPosition(this.x, this.y - 32);
			word.allowCollisions = FlxObject.ANY;
			word.visible = true;
		}
	}
}