package game.char;

import game.objects.NonSolid;
import game.objects.Fast;
import source.game.objects.Slow;
import game.objects.Large;
import game.objects.Small;
import game.objects.Word;

// Note we'll be using tiles so don't go over the tile limit
class Actor extends FlxSprite {
	public var name:String;
	public var data:ActorData;
	public var atk:Int;
	public var def:Int;
	public var spd:Int;
	public var notSolid:Bool;
	public var wordModList:Array<Word>;

	public function new(x:Float, y:Float, actorData:ActorData) {
		super(x, y);
		data = actorData;
		notSolid = false;
		wordModList = [];
		if (data != null) {
			assignStats();
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

	public function applyWord(word:Word) {
		switch (Type.getClass(word)) {
			case Small:

			case Large:

			case Slow:
				this.spd = cast this.spd * .5;
			case Fast:
				this.spd = cast this.spd * 1.5;
			case NonSolid:
				this.notSolid = true;
			case _:
				// Do nothing
		}
		this.wordModList.push(word);
	}

	public function removeWord(word:Word) {
		switch (Type.getClass(word)) {
			case Small:
				this.scale.set(0.5, .5);
				this.updateHitbox();
			case Large:
				this.scale.set(0.5, 0.5);
				this.updateHitbox();
			case Slow:
				this.spd = cast this.spd / .5;
			case Fast:
				this.spd = cast this.spd / 1.5;
			case NonSolid:
				this.notSolid = false;
			case _:
				// Do nothing
		}
		this.wordModList.remove(word);
	}
}