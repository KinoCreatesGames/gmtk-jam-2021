package game.states;

import game.objects.Walk;
import game.objects.Fast;

class LevelOneState extends PlayState {
	override public function create() {
		super.create();
		createLevel(new ldtkData.LDTkProj().all_levels.Level_0);
	}

	override function nextLevel():FlxState {
		return new LevelTwoState();
	}
}