package game.states;

class LevelOneState extends PlayState {
	override public function create() {
		super.create();
		createLevel('0001_Level_0');
	}

	override function nextLevel():FlxState {
		return new LevelTwoState();
	}
}