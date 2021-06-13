package game.states;

class LevelTwoState extends PlayState {
	override public function create() {
		super.create();
		createLevel('0002_Level_1');
	}
}