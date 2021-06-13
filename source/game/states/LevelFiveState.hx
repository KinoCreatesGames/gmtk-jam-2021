package game.states;

import game.objects.NonSolid;
import game.objects.Reverse;
import game.objects.Jump;
import game.objects.Fast;
import game.objects.Walk;

class LevelFiveState extends PlayState {
	override public function create() {
		super.create();
		createLevel('0005_Level_4');
	}

	override public function addWords() {
		var walk = new Walk(30, 30);
		var notSolid = new NonSolid(30, 90);
		var reverse = new Reverse(30, 120);
		wordGrp.add(walk);
		wordGrp.add(reverse);
		wordGrp.add(notSolid);
	}

	override public function nextLevel() {
		return new LevelSixState();
	}
}