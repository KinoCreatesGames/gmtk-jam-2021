package game.states;

import game.objects.NonSolid;
import game.objects.Reverse;
import game.objects.Jump;
import game.objects.Fast;
import game.objects.Walk;

class LevelSixState extends PlayState {
	override public function create() {
		super.create();
		createLevel('0006_Level_5');
	}

	override public function addWords() {
		var jump = new Jump(30, 90);
		var reverse = new Reverse(30, 120);
		var fast = new Fast(30, 150);
		var fast = new Fast(70, 150);
		wordGrp.add(jump);
		wordGrp.add(reverse);
		wordGrp.add(fast);
		wordGrp.add(fast);
	}

	override public function applyModifiers() {
		this.player.canWalk = true;
	}

	override public function nextLevel() {
		return new ThankYouState();
	}
}